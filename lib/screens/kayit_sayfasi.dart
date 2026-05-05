import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore için gerekli
import 'package:vektor/main.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final _formKey = GlobalKey<FormState>();

  // Verileri kontrol etmek için Controller'lar
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController(); // Şifre için yeni controller
  final TextEditingController _yakinAdSoyadController = TextEditingController();
  final TextEditingController _yakinTelController = TextEditingController();

  final List<String> _kanGruplari = ["A+", "A-", "B+", "B-", "AB+", "AB-", "0+", "0-"];
  String? _secilenKanGrubu;
  bool _yukleniyor = false; // İşlem sırasında butonu kilitlemek için

  // Firebase'e veri gönderen asenkron fonksiyon
  Future<void> _verileriKaydet() async {
    try {
      await FirebaseFirestore.instance.collection('Kullanicilar').add({
        'adSoyad': _adSoyadController.text.trim(),
        'telefon': _telController.text.trim(),
        'sifre': _sifreController.text.trim(), // Şifre Firestore'a ekleniyor
        'kanGrubu': _secilenKanGrubu,
        'yakinAdSoyad': _yakinAdSoyadController.text.trim(),
        'yakinTelefon': _yakinTelController.text.trim(),
        'kayitTarihi': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata oluştu: ${e.toString()}")),
        );
      }
    }
  }

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için controller'ları temizliyoruz
    _adSoyadController.dispose();
    _telController.dispose();
    _sifreController.dispose(); // Şifre controller temizliği
    _yakinAdSoyadController.dispose();
    _yakinTelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcı Kaydı"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kişisel Bilgiler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 15),
              _buildTextField("Ad Soyad", Icons.person, _adSoyadController),
              _buildTextField("Telefon Numarası", Icons.phone, _telController, keyboardType: TextInputType.phone),

              // Şifre Alanı
              _buildTextField(
                  "Şifre Oluşturun",
                  Icons.lock,
                  _sifreController,
                  isPassword: true
              ),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Kan Grubu",
                  prefixIcon: const Icon(Icons.bloodtype, color: Colors.red),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _kanGruplari.map((String grup) {
                  return DropdownMenuItem(value: grup, child: Text(grup));
                }).toList(),
                onChanged: (val) => setState(() => _secilenKanGrubu = val),
                validator: (value) => value == null ? "Lütfen kan grubunuzu seçin" : null,
              ),

              const SizedBox(height: 30),
              const Text(
                "Acil Durum Yakını Bilgileri",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              const SizedBox(height: 15),
              _buildTextField("Yakın Ad Soyad", Icons.person_outline, _yakinAdSoyadController),
              _buildTextField("Yakın Telefon Numarası", Icons.phone_android, _yakinTelController, keyboardType: TextInputType.phone),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _yukleniyor ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _yukleniyor = true);
                      await _verileriKaydet();
                      if (mounted) setState(() => _yukleniyor = false);
                    }
                  },
                  child: _yukleniyor
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("KAYDI TAMAMLA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TextField Oluşturucu Widget
  Widget _buildTextField(
      String label,
      IconData icon,
      TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
        bool isPassword = false} // Şifre gizleme parametresi eklendi
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword, // Şifreyse karakterleri gizler
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Lütfen bu alanı doldurun";
          if (isPassword && value.length < 6) return "Şifre en az 6 karakter olmalıdır";
          return null;
        },
      ),
    );
  }
}