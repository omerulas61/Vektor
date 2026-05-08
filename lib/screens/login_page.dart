import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Sorgu için gerekli
import 'package:vektor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Verileri okumak için Controller'lar
  final TextEditingController _userAdSoyadController = TextEditingController();
  final TextEditingController _userSifreController = TextEditingController();

  final TextEditingController _kurumAdController = TextEditingController();
  final TextEditingController _kurumSifreController = TextEditingController();

  bool _yukleniyor = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _userAdSoyadController.dispose();
    _userSifreController.dispose();
    _kurumAdController.dispose();
    _kurumSifreController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Kullanıcı Giriş Kontrolü (Firebase Sorgusu)
  Future<void> _kullaniciGirisYap() async {
    // Boş alan kontrolü
    if (_userAdSoyadController.text.trim().isEmpty || _userSifreController.text.trim().isEmpty) {
      _hataGoster("Lütfen tüm alanları doldurun.");
      return;
    }

    setState(() => _yukleniyor = true);

    try {
      // Veritabanında Ad Soyad ve Şifre ikilisini arıyoruz
      var sorgu = await FirebaseFirestore.instance
          .collection('Kullanicilar')
          .where('adSoyad', isEqualTo: _userAdSoyadController.text.trim())
          .where('sifre', isEqualTo: _userSifreController.text.trim())
          .get();

      if (sorgu.docs.isNotEmpty) {
        // --- DEĞİŞİKLİK BURADA BAŞLIYOR ---
        // Veritabanındaki ilk dökümandan ismi alıyoruz
        String gelenIsim = sorgu.docs.first.get('adSoyad');

        // --- BURASI YENİ: Hafızaya Kayıt İşlemi ---
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Giriş yapıldı olarak işaretle
        await prefs.setString('userName', gelenIsim); // İsmi sakla
        // ----------------------------------------


        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(adSoyad: gelenIsim), // İsmi HomePage'e gönderiyoruz
            ),
          );
        }
        // --- DEĞİŞİKLİK BURADA BİTİYOR ---
      } else {
        // Eşleşme yoksa hata göster
        if (mounted) {
          _hataGoster("Hatalı Ad Soyad veya Şifre!");
        }
      }
    } catch (e) {
      _hataGoster("Bir hata oluştu: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  void _hataGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Yap"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "Kullanıcı"),
            Tab(icon: Icon(Icons.business), text: "Kurum"),
          ],
        ),
      ),
      body: _yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildUserLoginForm(),
          _buildAgencyLoginForm(),
        ],
      ),
    );
  }

  Widget _buildUserLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInput(label: "Ad Soyad", icon: Icons.person_outline, controller: _userAdSoyadController),
          _buildInput(label: "Şifre", icon: Icons.lock_outline, isPassword: true, controller: _userSifreController),
          const SizedBox(height: 30),
          _buildLoginButton("Giriş Yap", _kullaniciGirisYap),
        ],
      ),
    );
  }

  Widget _buildAgencyLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInput(label: "Kurum Adı", icon: Icons.account_balance, controller: _kurumAdController),
          _buildInput(label: "Kurum Şifresi", icon: Icons.vpn_key, isPassword: true, controller: _kurumSifreController),
          const SizedBox(height: 30),
          _buildLoginButton("Kurum Girişi", () {
            _hataGoster("Kurum girişi henüz aktif değil.");
          }),
        ],
      ),
    );
  }

  Widget _buildInput({required String label, required IconData icon, required TextEditingController controller, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildLoginButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}