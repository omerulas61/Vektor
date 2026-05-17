import 'package:flutter/material.dart';
import 'package:vektor/screens/kayit_sayfasi.dart';
import 'package:vektor/screens/login_page.dart';
import 'package:vektor/screens/kurum_kayit_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';

class GirisSecimSayfasi extends StatelessWidget {
  const GirisSecimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Arka plan görseli
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.85),
                  AppColors.primary.withValues(alpha: 0.95),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Logo & Başlık
                  _buildHeader(),
                  const Spacer(flex: 2),
                  // Seçenek Butonları
                  _buildOptionCard(
                    context,
                    title: "KULLANICI KAYIT OL",
                    subtitle: "Yardım istemek veya gönüllü olmak için",
                    icon: Icons.person_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const KayitSayfasi())),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    title: "KURUM KAYIT OL ",
                    subtitle: "Resmi kurum ve STK yönetimi için",
                    icon: Icons.account_balance_rounded,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
                    ),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const KurumKayitSayfasi())),
                  ),
                  const Spacer(),
                  // Giriş yap linki
                  _buildLoginLink(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
          ),
          child: const Icon(Icons.crisis_alert_rounded, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 20),
        const Text(
          "VEKTÖR",
          style: TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
          ),
          child: const Text(
            "Afet Koordinasyon Sistemi",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoginPage())),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded,
                color: Colors.white.withValues(alpha: 0.8), size: 18),
            const SizedBox(width: 8),
            RichText(
              text: const TextSpan(
                text: "Zaten hesabın var mı?  ",
                style: TextStyle(color: Colors.white60, fontSize: 14),
                children: [
                  TextSpan(
                    text: "Giriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
