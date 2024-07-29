import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SeansKontrolSayfa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seans Ayarlama'),
      ),
      body: SeansKontrol(),
    );
  }
}

class SeansKontrol extends StatefulWidget {
  @override
  _SeansKontrolState createState() => _SeansKontrolState();
}

class _SeansKontrolState extends State<SeansKontrol> {
  List<Map<String, dynamic>> _datesAndStatuses = [];
  List<Map<String, dynamic>> _hoursAndStatuses = [];
  Map<String, bool> checkboxValues = {};

  @override
  void initState() {
    super.initState();
    _fetchDatesAndStatuses();
    _fetchHourAndStatuses();
    _fetchCheckboxValues();
  }

  Future<void> _fetchDatesAndStatuses() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('dates');
      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> datesAndStatuses = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Dokümandaki tarih ve durum bilgilerini bul ve listeye ekle
        for (var key in data.keys) {
          if (key.startsWith('Gün')) {
            String durumKey = 'Durum' + key.substring(3);
            if (data.containsKey(durumKey)) {
              datesAndStatuses.add({
                'date': DateTime.parse(data[key]),
                'status': data[durumKey],
              });
            }
          }
        }
      }

      // Tarihleri sıralı hale getir
      datesAndStatuses.sort((a, b) => a['date'].compareTo(b['date']));

      setState(() {
        _datesAndStatuses = datesAndStatuses;
      });
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<void> _fetchHourAndStatuses() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('hours');
      QuerySnapshot querySnapshot = await collectionRef.get();

      List<Map<String, dynamic>> hoursAndStatuses = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Dokümandaki saat ve durum bilgilerini bul ve listeye ekle
        for (var key in data.keys) {
          if (key.startsWith('hour')) {
            String durumKey = 'Durum' + key.substring(4);
            if (data.containsKey(durumKey)) {
              hoursAndStatuses.add({
                'hour': data[key],
                'status': data[durumKey],
              });
            }
          }
        }
      }

      // Saatleri sıralı hale getir
      hoursAndStatuses.sort((a, b) => a['hour'].compareTo(b['hour']));

      setState(() {
        _hoursAndStatuses = hoursAndStatuses;
      });
    } catch (e) {
      print('Hata: $e');
    }

  }

  Future<void> _fetchCheckboxValues() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('combinedDatesTimes');
      QuerySnapshot querySnapshot = await collectionRef.get();

      Map<String, bool> fetchedCheckboxValues = {};

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        for (var key in data.keys) {
          if (key.startsWith('datetime')) {
            String durumKey = 'Durum' + key.substring(8);
            if (data.containsKey(durumKey)) {
              DateTime datetime = DateTime.parse(data[key]);
              String formattedDate = DateFormat('dd.MM.yyyy').format(datetime);
              String formattedHour = DateFormat('HH:mm').format(datetime);
              String combinedKey = '$formattedDate-$formattedHour';

              fetchedCheckboxValues[combinedKey] = data[durumKey] == '1';
            }
          }
        }
      }

      setState(() {
        checkboxValues = fetchedCheckboxValues;
      });

    } catch (e) {
      print('Hata: $e');
    }

  }

  Future<void> _saveAllCheckboxValues() async {
    try {
      // Firestore'dan eski veritabanını sil
      await _deleteOldData();

      await Future.delayed(Duration(seconds: 5));

      // Tüm checkbox değerlerini al
      Map<String, bool> allCheckboxValues = {};

      for (var date in _datesAndStatuses) {
        for (var hour in _hoursAndStatuses) {
          String key = '${DateFormat('dd.MM.yyyy').format(date['date'])}-${hour['hour']}';
          bool value = checkboxValues[key] ?? false;
          allCheckboxValues[key] = value;
        }
      }

      // Tüm checkbox değerlerini yeni veritabanına kaydet
      await _saveDataToFirestore(allCheckboxValues);

      print('Tüm veriler başarıyla kaydedildi.');
    } catch (e) {
      print('Hata: $e');
    }
  }
  Future<void> _deleteOldData() async {
    try {
      // Eski veritabanını sil
      await FirebaseFirestore.instance.collection('combinedDatesTimes').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      print('Eski veri tabanı başarıyla silindi.');
    } catch (e) {
      print('Eski veri tabanını silme hatası: $e');
    }
  }

  Future<void> _saveDataToFirestore(Map<String, bool> data) async {
    try {
      // Yeni veritabanına verileri kaydet
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('combinedDatesTimes');

      for (var entry in data.entries) {
        String key = entry.key;
        bool value = entry.value;
        // Tarih ve saat formatını ayıkla
        List<String> parts = key.split('-');
        String formattedDate = parts[0];
        String formattedHour = parts[1];
        DateTime datetime = DateFormat('dd.MM.yyyy HH:mm').parse('$formattedDate $formattedHour');

        // Firestore'a kaydet
        await collectionRef.add({
          'datetime': DateFormat('yyyy-MM-dd HH:mm').format(datetime),
          'Durum': value ? '1' : '0',
        });
      }

      print('Yeni veri tabanına veriler başarıyla kaydedildi.');
    } catch (e) {
      print('Yeni veri tabanına kaydetme hatası: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(100.0),

                children: [
                  TableRow(
                    children: [
                      SizedBox(),
                      ..._hoursAndStatuses.map((item) => Center(child: Text(item['hour'].toString()))).toList(),
                    ],
                  ),
                  ..._datesAndStatuses.map((date) {
                    return TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Container(
                            height: 50.0,
                            child: Center(child: Text(DateFormat('dd.MM.yyyy').format(date['date']))),
                          ),
                        ),
                        ..._hoursAndStatuses.map((hour) {
                          String key = '${DateFormat('dd.MM.yyyy').format(date['date'])}-${hour['hour']}';
                          bool value = checkboxValues[key] ?? false;
                          return TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Container(
                              height: 50.0,
                              child: Center(
                                child: Checkbox(
                                  value: value,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      checkboxValues[key] = newValue ?? false;
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            _saveAllCheckboxValues();
            await Future.delayed(Duration(seconds: 10));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kayıt Başarılı')),
            );
          },
          child: Text('Tüm Verileri Kaydet'),
        ),
      ],
    );
  }
}
