import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'package:excel/excel.dart';

class Gozetmenekle extends StatefulWidget {
  @override
  _ExcelTablePageState createState() => _ExcelTablePageState();
}

class _ExcelTablePageState extends State<Gozetmenekle> {
  List<List<dynamic>> _tableData = [];

  @override
  void initState() {
    super.initState();
    _getFirestoreData(); // Firestore verilerini al
  }

  Future<void> _getFirestoreData() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('GozetmenBilgi');
      QuerySnapshot querySnapshot = await collectionRef.get();
      List<List<dynamic>> tableData = [];

      querySnapshot.docs.forEach((doc) {
        tableData.add([doc['gözetmenAdı'], doc['bölüm'], doc.reference.id]); // Doküman ID'sini de listeye ekle
      });
      tableData.sort((a, b) => a[0].compareTo(b[0]));
      
      setState(() {
        _tableData = tableData;
      });
    } catch (e) {
      print('Firestore verilerini alma hatası: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      // Dosya seçme işlemleri
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = '.xlsx';
      uploadInput.click();

      uploadInput.onChange.listen((e) async {
        final files = uploadInput.files;
        if (files!.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();

          reader.onLoadEnd.listen((e) async {
            var bytes = reader.result as Uint8List;
            var excel = Excel.decodeBytes(bytes);

            List<List<dynamic>> tableData = [];
            for (var table in excel.tables.keys) {
              for (var row in excel.tables[table]!.rows) {
                tableData.add(row.map((cell) => cell?.value).toList());
              }
            }

            // Firebase Firestore'daki mevcut verileri temizle
            await _clearFirestoreData();

            // Firebase Firestore'a veri ekleme işlemleri
            CollectionReference collectionRef = FirebaseFirestore.instance.collection('GozetmenBilgi');

            for (var data in tableData) {
              await collectionRef.add({
                'gözetmenAdı': data[0].toString(), // Gözetmen adı
                'bölüm': data[1].toString(), // Bölüm adı
              });
            }

            setState(() {
              _tableData = tableData;
            });
          });

          reader.readAsArrayBuffer(file);
        }
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> _clearFirestoreData() async {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('GozetmenBilgi');
    QuerySnapshot querySnapshot = await collectionRef.get();

    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete(); // Her bir dokümanı sil
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gözetmen Ekle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_tableData.isEmpty)
              Center(
                child: ElevatedButton(
                  onPressed: _pickFile,
                  child: Text('Excel Dosyası Seç'),
                ),
              )
            else
              DataTable(
                columns: [
                  DataColumn(label: Text('Adı Soyadı')),
                  DataColumn(label: Text('Bölümü')),
                ],
                rows: _tableData.map((rowData) {
                  return DataRow(
                    cells: [
                      DataCell(Text('${rowData[0]}')),
                      DataCell(Text('${rowData[1]}')),
                    ],
                    // Satır silmek için bir işlev çağır
                    onSelectChanged: (isSelected) {
                      if (isSelected!) {
                        _deleteRow(rowData[2]); // Doküman ID'sini gönder
                      }
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: 'Excel Dosyası Yükle',
        child: Icon(Icons.upload),
      ),
    );
  }

  Future<void> _deleteRow(String docId) async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('GozetmenBilgi');
      await collectionRef.doc(docId).delete(); // Belirli bir dokümanı sil
      _getFirestoreData(); // Firestore verilerini yeniden al ve tabloyu güncelle
    } catch (e) {
      print('Dokümanı silme hatası: $e');
    }
  }
}
