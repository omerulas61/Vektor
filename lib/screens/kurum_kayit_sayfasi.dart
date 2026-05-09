import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vektor/screens/kurum_ana_sayfasi.dart';

class KurumKayitSayfasi extends StatefulWidget {
  const KurumKayitSayfasi({super.key});

  @override
  State<KurumKayitSayfasi> createState() => _KurumKayitSayfasiState();
}

class _KurumKayitSayfasiState extends State<KurumKayitSayfasi> {
  // Verileri almak için kontrolcüler
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  // Firebase'e kaydetme fonksiyonu
  Future<void> _kurumKaydet() async {
    String ad = _adController.text.trim();
    String sifre = _sifreController.text.trim();

    if (ad.isEmpty || sifre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
      );
      return;
    }

    try {
      // Firebase Firestore'a ekleme yapıyoruz
      await FirebaseFirestore.instance.collection('Kurumlar').add({
        'kurum_adi': ad,
        'kurum_sifre': sifre,
        'kayit_tarihi': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kurum başarıyla kaydedildi!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => KurumAnaSayfasi(kurumAdi: ad),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata oluştu: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kurum Kaydı"),
        backgroundColor: const Color(0xFF0D47A1), // Koyu mavi (Vektör temasına uygun)
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 80, color: Color(0xFF0D47A1)),
            const SizedBox(height: 30),
            TextField(
              controller: _adController,
              decoration: const InputDecoration(
                labelText: "Kurum Adı",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sifreController,
              obscureText: true, // Şifreyi gizli yapar
              decoration: const InputDecoration(
                labelText: "Kurum Şifresi",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _kurumKaydet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                ),
                child: const Text("KAYDET VE GİRİŞ YAP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}