import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SeansKontrol.dart';
import 'SideMenu.dart';
import 'DateTime.dart'; // DateTimePage sayfasını ekleyin
import 'dart:async'; // Timer için
import 'package:fluttertoast/fluttertoast.dart';

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
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    fToast = FToast();
    fToast.init(context);
  }

  void _updateDateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _dateTime = DateTime.now().toString();
      });
    });
  }

  void _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Toast mesaji budur"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 8),
    );

    // Toast konumu
    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 8),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: 16.0,
          left: 16.0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/my_image.png',
              width: 256,
              height: 256,
            ),
          ],
        ),
        SizedBox(width: 20),
        InkWell(
          onTap: () {
            _showToast();
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.visibility),
              iconSize: 48,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeansKontrol()),
                );
              },
            ),
          ],
        ),
        SizedBox(width: 20),
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
