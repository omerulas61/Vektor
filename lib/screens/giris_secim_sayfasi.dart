import 'package:flutter/material.dart';
import 'package:vektor/main.dart'; // HomePage'e erişmek için

class GirisSecimSayfasi extends StatelessWidget {
  const GirisSecimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arka plan resmi (Ana sayfadakiyle uyumlu olması için)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Karartma katmanı
          Container(
            color: Colors.black.withValues(alpha: 0.6),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_searching, size: 80, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    "VEKTÖR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const Text(
                    "Afet Koordinasyon Sistemi",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 60),

                  // Seçim Butonları
                  _buildOptionButton(
                    context,
                    title: "KULLANICI GİRİŞİ",
                    subtitle: "Yardım istemek veya destek olmak için",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildOptionButton(
                    context,
                    title: "KURUM GİRİŞİ",
                    subtitle: "Resmi kurum ve STK yönetimi için",
                    icon: Icons.account_balance,
                    onTap: () {
                      // Kurum girişi sayfası hazır olduğunda buraya eklenecek
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context,
      {required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blue.shade900),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF2E3D49),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}