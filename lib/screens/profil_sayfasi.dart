import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vektor/screens/giris_secim_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';

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
      yakinTelefon = prefs.getString('userRelativePhone') ?? "Kayıtlı Değil";
    });
  }

  Future<void> _cikisYap() async {
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Çıkış Yap",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Oturumunuzu kapatmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Vazgeç"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Çıkış Yap"),
          ),
        ],
      ),
    );

    if (onay == true) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const GirisSecimSayfasi()),
          (route) => false,
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Profil başlığı
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3),
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(widget.adSoyad),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.adSoyad,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Kayıtlı Kullanıcı",
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // İçerik
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Kişisel Bilgiler"),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                        Icons.badge_rounded, "Ad Soyad", widget.adSoyad,
                        AppColors.secondary),
                    _buildDivider(),
                    _buildInfoRow(
                        Icons.phone_rounded, "Telefon", telefon,
                        AppColors.accentGreen),
                    _buildDivider(),
                    _buildInfoRow(
                        Icons.bloodtype_rounded, "Kan Grubu", kanGrubu,
                        AppColors.accent),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Acil Durum Bilgileri"),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                        Icons.person_outline_rounded, "Acil Yakın", yakinKisi,
                        AppColors.accentOrange),
                    _buildDivider(),
                    _buildInfoRow(
                        Icons.phone_android_rounded, "Yakın Telefonu",
                        yakinTelefon, AppColors.accentOrange),
                  ]),
                  const SizedBox(height: 32),
                  // Çıkış butonu
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _cikisYap,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text(
                        "OTURUMU KAPAT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 68, color: AppColors.divider);
  }
}
