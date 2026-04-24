<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_yardim_sayfasi.dart';

void main() {
  runApp(const VektorApp());
}

class VektorApp extends StatelessWidget {
  const VektorApp({super.key}); // Key hatası düzeltildi

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vektör Yardım',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key}); // Key hatası düzeltildi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "VEKTÖR",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
           image: DecorationImage(
           image: AssetImage("assets/image.png"),
           fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.5),
               BlendMode.darken,
              ),
             ),
             ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Üst Bilgi Kartı
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85), // Yeni kullanım
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFE0E6ED),
                      child: Icon(Icons.person, size: 35, color: Color(0xFF6C7B8A)),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hoş geldiniz,",
                          style: TextStyle(
                            color: Color(0xFF2E3D49),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Afet Koordinasyon Platformu",
                          style: TextStyle(color: Color(0xFF6C7B8A)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Acil Durum İşlemleri",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Kartlar Grid'i
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildEmergencyCard(
                      context,
                      title: "YARDIM İSTE",
                      subtitle: "Talep oluştur",
                      icon: Icons.campaign,
                      cardColor: Colors.white.withValues(alpha: 0.9),
                      iconColor: Colors.redAccent,
                      targetPage: const AcilYardimSayfasi(),
                    ),
                    _buildEmergencyCard(
                      context,
                      title: "GÖNÜLLÜ OL",
                      subtitle: "Destek ol",
                      icon: Icons.handshake,
                      cardColor: Colors.white.withValues(alpha: 0.9),
                      iconColor: Colors.blueAccent,
                    ),
                    _buildEmergencyCard(
                      context,
                      title: "ACİL HARİTA",
                      subtitle: "Güvenli bölgeler",
                      icon: Icons.map,
                      cardColor: Colors.white.withValues(alpha: 0.9),
                      iconColor: Colors.orange,
                    ),
                    _buildEmergencyCard(
                      context,
                      title: "DESTEK OL",
                      subtitle: "Maddi yardım",
                      icon: Icons.volunteer_activism,
                      cardColor: Colors.white.withValues(alpha: 0.9),
                      iconColor: Colors.purple,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Hazırlık"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "Uyarı"),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: "Müdahale"),
          BottomNavigationBarItem(icon: Icon(Icons.healing), label: "İyileştirme"),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color cardColor,
      required Color iconColor,
      Widget? targetPage}) {
    return InkWell(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2E3D49),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF6C7B8A), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
=======
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
>>>>>>> 6bb9e2071cbff437434be4fba97183b6afe4b478
}