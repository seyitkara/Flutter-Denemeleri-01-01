import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Deneme extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Deneme> {
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _timeController1 = TextEditingController();
  final TextEditingController _timeController2 = TextEditingController();
  final TextEditingController _aralik1 = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        controller.text = DateFormat('dd.MM.yyyy').format(picked);
      });
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        final now = DateTime.now();
        final dt =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        controller.text = DateFormat('HH:mm').format(dt);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarih ve Saat Girişi'),
      ),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 150),
              TextField(
                controller: _dateController1,
                decoration: InputDecoration(
                  labelText: 'Başlangıç Tarihi',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _dateController1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateController2,
                decoration: InputDecoration(
                  labelText: 'Bitiş Tarihi',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _dateController2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _timeController1,
                decoration: InputDecoration(
                  labelText: 'Başlangıç Saati',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _timeController1),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _timeController2,
                decoration: InputDecoration(
                  labelText: 'Bitiş Saati',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _timeController2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _aralik1,
                decoration: InputDecoration(
                  labelText: 'Saat Aralığı',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  deleteCollection('dates');
                  deleteCollection('hours');
                  deleteCollection('combinedDatesTimes');

                  await Future.delayed(Duration(seconds: 5));

                  String startDateString = _dateController1.text;
                  String endDateString = _dateController2.text;

                  int aralikb = int.parse(_aralik1.text);
                  print(aralikb);

                  String startHoursString = _timeController1.text;
                  String endHoursString = _timeController2.text;

                  DateTime startDate =
                      DateFormat('dd.MM.yyyy').parse(startDateString);
                  DateTime endDate =
                      DateFormat('dd.MM.yyyy').parse(endDateString);

                  DateTime now = DateTime.now();
                  DateTime startTime =
                      DateFormat('HH:mm').parse(startHoursString);
                  DateTime endTime = DateFormat('HH:mm').parse(endHoursString);

                  startTime = DateTime(now.year, now.month, now.day,
                      startTime.hour, startTime.minute);
                  endTime = DateTime(now.year, now.month, now.day, endTime.hour,
                      endTime.minute);

                  List<String> hoursList = [];
                  DateTime current = startTime;

                  while (current.isBefore(endTime) ||
                      current.isAtSameMomentAs(endTime)) {
                    hoursList.add(DateFormat('HH:mm').format(current));
                    current = current.add(Duration(hours: aralikb));
                  }

                  _saveHoursToFirestore(hoursList);

                  List<DateTime> dateList = getDateList(startDate, endDate);
                  String dateListString = dateList.toString();
                  print(dateList);

                  List<String> combinedList = [];
                  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
                  DateFormat timeFormatter = DateFormat('HH:mm');

                  for (DateTime date in dateList) {
                    for (String time in hoursList) {
                      DateTime parsedTime = timeFormatter.parse(time);
                      DateTime combinedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        parsedTime.hour,
                        parsedTime.minute,
                      );
                      combinedList.add(DateFormat('yyyy-MM-dd HH:mm')
                          .format(combinedDateTime));
                    }
                  }

                  _saveCombinedListToFirestore(combinedList);

                  for (int i = 0; i < dateList.length; i++) {
                    // Firestore'a tarih bilgisini ekleme
                    await FirebaseFirestore.instance.collection('dates').add({
                      'Gün${i + 1}': dateList[i].toString(),
                      'Durum${i + 1}': '1',
                    });
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tarih ve Saatler Kaydedildi')),
                  );
                },
                child: Text('Kaydet'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<DateTime> getDateList(DateTime startDate, DateTime endDate) {
  List<DateTime> dateList = [];
  for (DateTime date = startDate;
      date.isBefore(endDate.add(Duration(days: 1)));
      date = date.add(Duration(days: 1))) {
    dateList.add(date);
  }
  return dateList;
}

void deleteCollection(String collectionPath) async {
  try {
    // Firestore'dan koleksiyon referansı alınır
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionPath);

    // Koleksiyon içindeki tüm belgeler alınır
    QuerySnapshot snapshot = await collectionRef.get();

    // Her belge tek tek silinir
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
    print('Koleksiyon ve içindeki tüm belgeler silindi');
  } catch (e) {
    print('Hata: $e');
  }
}

Future<void> _saveHoursToFirestore(List<String> hoursList) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('hours');

    for (int i = 0; i < hoursList.length; i++) {
      await collectionRef.add({
        'hour${i + 1}': hoursList[i],
        'Durum${i + 1}': '1',
      });
    }
  } catch (e) {
    print('Hata: $e');
  }
}

Future<void> _saveCombinedListToFirestore(List<String> combinedList) async {
  try {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('combinedDatesTimes');

    for (int i = 0; i < combinedList.length; i++) {
      await collectionRef.add({
        'datetime${i + 1}': combinedList[i],
        'Durum${i + 1}': '1',
      });
    }
  } catch (e) {
    print('Hata: $e');
  }
}
