import 'package:flutter/material.dart';

void main() {
  runApp(const VektorApp());
}

class VektorApp extends StatelessWidget {
  const VektorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VEKTÖR - Afet Koordinasyon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Koyu arka plan
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo ve Başlık
              const Icon(Icons.location_on_outlined, size: 80, color: Colors.white),
              const Text(
                'VEKTÖR',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'AFET KOORDİNASYON PLATFORMU',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 60),

              // Afetzede Giriş Kartı (Turuncu Tonları)
              _buildSelectionCard(
                context,
                title: 'YARDIM İSTE',
                subtitle: 'Afetzede talebi oluştur',
                icon: Icons.campaign_rounded,
                color: Colors.orangeAccent,
                onTap: () {
                  print('Afetzede moduna giriliyor...');
                },
              ),

              const SizedBox(height: 20),

              // Gönüllü/Kuruluş Giriş Kartı (Mavi Tonları)
              _buildSelectionCard(
                context,
                title: 'GÖNÜLLÜ OL',
                subtitle: 'Görev eşleştirmesi yap',
                icon: Icons.handshake_rounded,
                color: Colors.lightBlueAccent,
                onTap: () {
                  print('Kuruluş moduna giriliyor...');
                },
              ),

              const SizedBox(height: 40),

              // Alt Süreç Göstergesi
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ProcessIcon(Icons.settings, "Hazırlık"),
                  _ProcessIcon(Icons.notification_important, "Uyarı"),
                  _ProcessIcon(Icons.medical_services, "Müdahale"),
                  _ProcessIcon(Icons.rebase_edit, "İyileştirme"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ProcessIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ProcessIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white38, size: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}