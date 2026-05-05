import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_yardim_sayfasi.dart';
import 'package:vektor/screens/giris_secim_sayfasi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const VektorApp());
}

class VektorApp extends StatelessWidget {
  const VektorApp({super.key});

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
      home: const GirisSecimSayfasi(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String adSoyad; // Giriş yapan kullanıcının ismini tutan değişken

  // Parametreyi constructor'a ekledik
  const HomePage({super.key, required this.adSoyad});

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
            image: const AssetImage("assets/image.png"),
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
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFFE0E6ED),
                      child: Icon(Icons.person, size: 35, color: Color(0xFF6C7B8A)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hoş geldiniz,",
                          style: TextStyle(
                            color: Color(0xFF2E3D49),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Sabit metin yerine adSoyad değişkenini koyduk
                        Text(
                          adSoyad,
                          style: const TextStyle(
                            color: Color(0xFF2E3D49),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
}