import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vektor/screens/kurum_ana_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _userAdSoyadController = TextEditingController();
  final TextEditingController _userSifreController = TextEditingController();
  final TextEditingController _kurumAdController = TextEditingController();
  final TextEditingController _kurumSifreController = TextEditingController();

  bool _yukleniyor = false;
  bool _userSifreGizli = true;
  bool _kurumSifreGizli = true;

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

  Future<void> _kullaniciGirisYap() async {
    if (_userAdSoyadController.text.trim().isEmpty ||
        _userSifreController.text.trim().isEmpty) {
      _hataGoster("Lütfen tüm alanları doldurun.");
      return;
    }
    setState(() => _yukleniyor = true);
    try {
      var sorgu = await FirebaseFirestore.instance
          .collection('Kullanicilar')
          .where('adSoyad', isEqualTo: _userAdSoyadController.text.trim())
          .where('sifre', isEqualTo: _userSifreController.text.trim())
          .get();

      if (sorgu.docs.isNotEmpty) {
        var userDoc = sorgu.docs.first.data();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userName', userDoc['adSoyad'] ?? "");
        await prefs.setString('userBlood', userDoc['kanGrubu'] ?? "");
        await prefs.setString('userPhone', userDoc['telefon'] ?? "");
        await prefs.setString('userRelativeName', userDoc['yakinAdSoyad'] ?? "");
        await prefs.setString('userRelativePhone', userDoc['yakinTelefon'] ?? "");

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HomePage(adSoyad: userDoc['adSoyad'] ?? "Kullanıcı"),
            ),
          );
        }
      } else {
        _hataGoster("Hatalı Ad Soyad veya Şifre!");
      }
    } catch (e) {
      _hataGoster("Bir hata oluştu: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  Future<void> _kurumGirisYap() async {
    if (_kurumAdController.text.trim().isEmpty ||
        _kurumSifreController.text.trim().isEmpty) {
      _hataGoster("Lütfen kurum adı ve şifresini girin.");
      return;
    }
    setState(() => _yukleniyor = true);
    try {
      var sorgu = await FirebaseFirestore.instance
          .collection('Kurumlar')
          .where('kurum_adi', isEqualTo: _kurumAdController.text.trim())
          .where('kurum_sifre', isEqualTo: _kurumSifreController.text.trim())
          .get();

      if (sorgu.docs.isNotEmpty) {
        var kurumDoc = sorgu.docs.first.data();
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  KurumAnaSayfasi(kurumAdi: kurumDoc['kurum_adi'] ?? "Kurum"),
            ),
          );
        }
      } else {
        _hataGoster("Hatalı Kurum Adı veya Şifre!");
      }
    } catch (e) {
      _hataGoster("Bağlantı hatası: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _yukleniyor = false);
    }
  }

  void _hataGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mesaj)),
          ],
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst başlık alanı
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "Giriş Yap",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [
                      Tab(icon: Icon(Icons.person_rounded), text: "Kullanıcı"),
                      Tab(
                          icon: Icon(Icons.account_balance_rounded),
                          text: "Kurum"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // İçerik
          Expanded(
            child: _yukleniyor
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.secondary))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildUserLoginForm(),
                      _buildAgencyLoginForm(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(
              "Kullanıcı Girişi", Icons.person_rounded, AppColors.secondary),
          const SizedBox(height: 24),
          _buildInput(
            label: "Ad Soyad",
            icon: Icons.badge_rounded,
            controller: _userAdSoyadController,
          ),
          const SizedBox(height: 16),
          _buildInput(
            label: "Şifre",
            icon: Icons.lock_rounded,
            controller: _userSifreController,
            isPassword: true,
            isPasswordVisible: !_userSifreGizli,
            onTogglePassword: () =>
                setState(() => _userSifreGizli = !_userSifreGizli),
          ),
          const SizedBox(height: 32),
          _buildLoginButton("GİRİŞ YAP", _kullaniciGirisYap,
              AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildAgencyLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(
              "Kurum Girişi", Icons.account_balance_rounded, const Color(0xFF7B1FA2)),
          const SizedBox(height: 24),
          _buildInput(
            label: "Kurum Adı",
            icon: Icons.business_rounded,
            controller: _kurumAdController,
          ),
          const SizedBox(height: 16),
          _buildInput(
            label: "Kurum Şifresi",
            icon: Icons.vpn_key_rounded,
            controller: _kurumSifreController,
            isPassword: true,
            isPasswordVisible: !_kurumSifreGizli,
            onTogglePassword: () =>
                setState(() => _kurumSifreGizli = !_kurumSifreGizli),
          ),
          const SizedBox(height: 32),
          _buildLoginButton(
              "KURUM GİRİŞİ", _kurumGirisYap, const Color(0xFF7B1FA2)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInput({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: AppColors.textSecondary,
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
    );
  }

  Widget _buildLoginButton(String text, VoidCallback onPressed, Color color) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }
}
