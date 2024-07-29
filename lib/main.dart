/*
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SideMenu.dart';
import 'SeansKontrol.dart'; // SeansKontrol sayfasını ekleyin
import 'dart:async'; // Timer için

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sınav Otomasyon Sistemi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Platforma göre farklı widget döndürme
    if (kIsWeb) {
      return WebHomePage();
    } else {
      return MobileHomePage();
    }
  }
}

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F3B),
        title: Text('Sınav Otomasyon Sistemi',
            style: TextStyle(color: Colors.white)),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Center(
              child: DateTimeDisplay(),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeDisplay extends StatefulWidget {
  @override
  _DateTimeDisplayState createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  String _dateTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _dateTime = DateTime.now().toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tarih ve Saat: $_dateTime',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        IconButton(
          icon: Icon(Icons.visibility),
          iconSize: 48,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeansKontrolSayfa()),
            );
          },
        ),
        Text(
          'Seans Kontrol',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class SeansKontrol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seans Kontrol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              'Seans Kontrol Sayfası',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Home Page'),
      ),
      body: Center(
        child: Text(
          'This is the mobile design',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SideMenu.dart';
import 'SeansKontrol.dart'; // SeansKontrol sayfasını ekleyin
import 'dart:async'; // Timer için

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sınav Otomasyon Sistemi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Platforma göre farklı widget döndürme
    if (kIsWeb) {
      return WebHomePage();
    } else {
      return MobileHomePage();
    }
  }
}

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F3B),
        title: Text('Sınav Otomasyon Sistemi',
            style: TextStyle(color: Colors.white)),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Center(
              child: DateTimeDisplay(),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeDisplay extends StatefulWidget {
  @override
  _DateTimeDisplayState createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  String _dateTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _dateTime = DateTime.now().toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tarih ve Saat: $_dateTime',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        Container(
          height: 200, // Önizleme yüksekliği
          child: SeansKontrolSayfa(), // SeansKontrol sayfasının önizlemesi
        ),
      ],
    );
  }
}

class SeansKontrol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seans Kontrol'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround, //buraya sonra bakılacak.
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 200,
              color: Colors.green,
            ),
            SizedBox(height: 40),
            Text(
              'Seans Kontrol Sayfası',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Home Page'),
      ),
      body: Center(
        child: Text(
          'This is the mobile design',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SeansKontrol.dart';
import 'SideMenu.dart';
import 'DateTime.dart'; // DateTimePage sayfasını ekleyin
import 'dart:async'; // Timer için

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sınav Otomasyon Sistemi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Platforma göre farklı widget döndürme
    if (kIsWeb) {
      return WebHomePage();
    } else {
      return MobileHomePage();
    }
  }
}

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F3B),
        title: Text('Sınav Otomasyon Sistemi',
            style: TextStyle(color: Colors.white)),
      ),
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Center(
              child: DateTimeDisplay(),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeDisplay extends StatefulWidget {
  @override
  _DateTimeDisplayState createState() => _DateTimeDisplayState();
}

class _DateTimeDisplayState extends State<DateTimeDisplay> {
  String _dateTime = '';

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _dateTime = DateTime.now().toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Deneme()),
            );
          },
          child: Text(
            'Tarih ve Saat: $_dateTime',
            style:
                TextStyle(fontSize: 24, decoration: TextDecoration.underline),
          ),
        ),
        SizedBox(height: 20),
        IconButton(
          icon: Icon(Icons.visibility),
          iconSize: 48,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeansKontrolSayfa()),
            );
          },
        ),
        Text(
          'Seans Kontrol',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class MobileHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Home Page'),
      ),
      body: Center(
        child: Text(
          'This is the mobile design',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
