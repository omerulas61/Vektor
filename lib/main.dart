import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_yardim_sayfasi.dart';

void main() {
  runApp(VektorApp());
}

class VektorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vektör Yardım',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),

            // BAŞLIK
            Text(
              "VEKTÖR",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Afet Koordinasyon Platformu",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 50),

            // YARDIM İSTE BUTONU
            GestureDetector(
              onTap: () {
                // AYRI DOSYADAKİ SAYFAYA YÖNLENDİRME
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcilYardimSayfasi()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.campaign, color: Colors.white, size: 40),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "YARDIM İSTE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Afetzede talebi oluştur",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            // GÖNÜLLÜ OL BUTONU
            GestureDetector(
              onTap: () {
                // Gönüllü sayfası hazır olduğunda buraya da Navigator ekleyebilirsin
                print("Gönüllü ol tıklandı");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.handshake, color: Colors.white, size: 40),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GÖNÜLLÜ OL",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Görev eşleştirmesi yap",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            Spacer(),

            // ALT MENÜ
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bottomItem(Icons.home, "Hazırlık"),
                  _bottomItem(Icons.warning, "Uyarı"),
                  _bottomItem(Icons.build, "Müdahale"),
                  _bottomItem(Icons.healing, "İyileştirme"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        SizedBox(height: 5),
        Text(text, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
}