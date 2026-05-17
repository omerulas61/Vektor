import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_yardim_sayfasi.dart';
import 'package:vektor/screens/giris_secim_sayfasi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vektor/screens/profil_sayfasi.dart';
import 'package:vektor/screens/acil_harita_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';
import 'package:vektor/screens/gonullu_sayfasi.dart';
import 'package:vektor/screens/haberler_sayfasi.dart';
import 'package:vektor/screens/destek_ol_sayfasi.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? userName = prefs.getString('userName');

  runApp(VektorApp(
    isLoggedIn: isLoggedIn,
    userName: userName ?? "Kullanıcı",
  ));
}

class VektorApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userName;

  const VektorApp({
    super.key,
    required this.isLoggedIn,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vektör Yardım',
      theme: AppTheme.theme,
      home: isLoggedIn
          ? HomePage(adSoyad: userName)
          : const GirisSecimSayfasi(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String adSoyad;
  const HomePage({super.key, required this.adSoyad});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
          // Üst başlık
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF0D47A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Üst bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.crisis_alert_rounded,
                                    color: Colors.white70, size: 18),
                                const SizedBox(width: 6),
                                const Text(
                                  "VEKTÖR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 3,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProfilSayfasi(
                                      adSoyad: widget.adSoyad),
                                ),
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.15),
                                  border: Border.all(
                                      color:
                                      Colors.white.withValues(alpha: 0.4),
                                      width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(widget.adSoyad),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Karşılama
                        Text(
                          "Merhaba,",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.adSoyad,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Durum bandı
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Sistem Aktif",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                  // Acil durum banner
                  _buildEmergencyBanner(context),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Acil Durum İşlemleri"),
                  const SizedBox(height: 14),
                  _buildMainGrid(context),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Bilgi & Hazırlık"),
                  const SizedBox(height: 14),
                  _buildInfoCards(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AcilYardimSayfasi()),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F0000), Color(0xFFB71C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.35),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.campaign_rounded,
                  color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ACİL YARDIM İSTE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Tehlike anında hemen yardım çağır",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildMainGrid(BuildContext context) {
    // BURASI DÜZENLENDİ: Tüm kartlara tek tek resim yolları eklendi
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'GÖNÜLLÜ OL',
        'subtitle': 'Destek ekibine katıl',
        'icon': Icons.handshake_rounded,
        'color': AppColors.secondary,
        'bgColor': const Color(0xFFE3F2FD),
        'imagePath': 'assets/gonullu.png',
        'targetPage': const GonulluSayfasi(),
      },
      {
        'title': 'ACİL HARİTA',
        'subtitle': 'Güvenli bölgeler',
        'icon': Icons.map_rounded,
        'color': AppColors.accentOrange,
        'bgColor': const Color(0xFFFFF3E0),
        'imagePath': 'assets/harita.png',
        'targetPage': AcilHaritaSayfasi(),
      },
      {
        'title': 'DESTEK OL',
        'subtitle': 'Maddi yardım',
        'icon': Icons.volunteer_activism_rounded,
        'color': const Color(0xFF6A1B9A),
        'bgColor': const Color(0xFFF3E5F5),
        'imagePath': 'assets/destek.png',
        'targetPage': const DestekOlSayfasi(),
      },
      {
        'title': 'HABERLER',
        'subtitle': 'Güncel duyurular',
        'icon': Icons.newspaper_rounded,
        'color': AppColors.accentGreen,
        'bgColor': const Color(0xFFE8F5E9),
        'imagePath': 'assets/haberler.png',
        'targetPage': const HaberlerSayfasi(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return _buildCard(context, card);
      },
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> card) {
    final bool hasTarget = card['targetPage'] != null;
    return GestureDetector(
      onTap: () {
        if (hasTarget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => card['targetPage']),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: card['bgColor'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(card['icon'], color: card['color'], size: 26),
                ),
                if (!hasTarget)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "Yakında",
                      style: TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),

            // BURASI DÜZENLENDİ: Ortadaki beyaz boşluğa dinamik Image widget'ı yerleştirildi
            if (card['imagePath'] != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Image.asset(
                      card['imagePath'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              const Spacer(),

            Text(
              card['title'],
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              card['subtitle'],
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final List<Map<String, dynamic>> infoItems = [
      {
        'icon': Icons.checklist_rounded,
        'title': 'Afet Çantası Hazırla',
        'subtitle': '72 saatlik hazırlık listesi',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.phone_in_talk_rounded,
        'title': 'Acil Numaralar',
        'subtitle': 'AFAD, 112, İtfaiye',
        'color': AppColors.accent,
      },
    ];

    return Column(
      children: infoItems.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'], color: item['color'], size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      item['subtitle'],
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.textSecondary),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Ana Sayfa'},
      {'icon': Icons.warning_rounded, 'label': 'Uyarılar'},
      {'icon': Icons.build_rounded, 'label': 'Müdahale'},
      {'icon': Icons.healing_rounded, 'label': 'İyileştirme'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index]['icon'] as IconData,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 24,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[index]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}