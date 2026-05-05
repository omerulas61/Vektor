import 'package:flutter/material.dart';
import 'package:vektor/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserLoginForm(),
          _buildAgencyLoginForm(),
        ],
      ),
    );
  }

  // Kullanıcı Giriş Formu
  Widget _buildUserLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInput(label: "Ad Soyad", icon: Icons.person_outline),
          _buildInput(label: "Şifre", icon: Icons.lock_outline, isPassword: true),
          const SizedBox(height: 30),
          _buildLoginButton("Giriş Yap"),
        ],
      ),
    );
  }

  // Kurum Giriş Formu
  Widget _buildAgencyLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildInput(label: "Kurum Adı", icon: Icons.account_balance),
          _buildInput(label: "Kurum Şifresi", icon: Icons.vpn_key, isPassword: true),
          const SizedBox(height: 30),
          _buildLoginButton("Kurum Girişi"),
        ],
      ),
    );
  }

  Widget _buildInput({required String label, required IconData icon, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildLoginButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          // Giriş mantığı buraya gelecek
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        },
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}