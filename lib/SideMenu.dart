import 'package:flutter/material.dart';
import 'package:flutterdenemeler/DateTime.dart';
import 'package:flutterdenemeler/GozetmenEkle.dart';
import 'package:flutterdenemeler/SeansKontrol.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  // Menü elemanlarının açık/kapalı durumlarını tutan liste
  List<bool> _expandedStatus = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xFF0F0F3B),
      child: ListView(
        children: [
          ExpansionTile(
            title: Text('Sınav', style: TextStyle(color: Colors.white)),
            children: [
              ListTile(
                title:
                    Text('Tarih-Saat', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Deneme()));
                },
              ),
              ListTile(
                title: Text('Seans Ayarlama',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeansKontrolSayfa()));
                },
              ),
              ListTile(
                  title: Text('Sınav Listesi',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          ExpansionTile(
            title: Text('Gözetmen', style: TextStyle(color: Colors.white)),
            children: [
              ListTile(
                title: Text('Gözetmen Ekle',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Gozetmenekle()));
                },
              ),
              ListTile(
                  title: Text('Olmayanlar',
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  title: Text('Sınav Listesi',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
          ExpansionTile(
            title: Text('Menu Item 3', style: TextStyle(color: Colors.white)),
            children: [
              ListTile(
                  title: Text('Tarih-Saat',
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  title: Text('Olmayanlar',
                      style: TextStyle(color: Colors.white))),
              ListTile(
                  title: Text('Sınav Listesi',
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }
}
