import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vektor/screens/giris_secim_sayfasi.dart';

class ProfilSayfasi extends StatefulWidget {
  final String adSoyad;
  const ProfilSayfasi({super.key, required this.adSoyad});

  @override
  State<ProfilSayfasi> createState() => _ProfilSayfasiState();
}

class _ProfilSayfasiState extends State<ProfilSayfasi> {
  String telefon = "...";
  String kanGrubu = "...";
  String yakinKisi = "...";
  String yakinTelefon = "...";

  @override
  void initState() {
    super.initState();
    _bilgileriYukle();
  }

  Future<void> _bilgileriYukle() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      telefon = prefs.getString('userPhone') ?? "Kayıtlı Değil";
      kanGrubu = prefs.getString('userBlood') ?? "Belirtilmemiş";
      yakinKisi = prefs.getString('userRelativeName') ?? "Kayıtlı Değil";
      yakinTelefon = prefs.getString('userRelativePhone') ?? "Kayıtlı Değil"; // Ayrı aldık
    });
  }

  Future<void> _cikisYap() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const GirisSecimSayfasi()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Bilgileri"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profil Resmi
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFE0E6ED),
              child: Icon(Icons.person, size: 50, color: Color(0xFF6C7B8A)),
            ),
            const SizedBox(height: 25),

            // Kişisel Bilgiler Bölümü
            _buildProfileItem("Ad Soyad", widget.adSoyad, Icons.badge),
            _buildProfileItem("Telefon", telefon, Icons.phone),
            _buildProfileItem("Kan Grubu", kanGrubu, Icons.bloodtype),

            const SizedBox(height: 20),
            const Divider(thickness: 1), // Görsel ayırıcı çizgi
            const SizedBox(height: 10),

            // Acil Durum Bilgileri Bölümü
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Acil Durum Bilgileri",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildProfileItem("Acil Durum Yakını", yakinKisi, Icons.person_outline),
            _buildProfileItem("Yakın Telefonu", yakinTelefon, Icons.phone_android), // Yeni kutucuk

            const SizedBox(height: 40),

            // Oturumu Kapat Butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _cikisYap,
                icon: const Icon(Icons.logout),
                label: const Text("OTURUMU KAPAT", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontSize: 12)),
        subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}