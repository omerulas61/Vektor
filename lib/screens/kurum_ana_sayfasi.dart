import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_harita_sayfasi.dart';
import 'package:vektor/screens/giris_secim_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';

class KurumAnaSayfasi extends StatefulWidget {
  final String kurumAdi;
  const KurumAnaSayfasi({super.key, required this.kurumAdi});

  @override
  State<KurumAnaSayfasi> createState() => _KurumAnaSayfasiState();
}

class _KurumAnaSayfasiState extends State<KurumAnaSayfasi> {
  int _selectedIndex = 0;

  void _cikisYap() async {
    final bool? onay = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Çıkış Yap",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Kurumsal oturumunuzu kapatmak istiyor musunuz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Vazgeç"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Çıkış Yap"),
          ),
        ],
      ),
    );
    if (onay == true && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const GirisSecimSayfasi()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // Üst başlık
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: _cikisYap,
                tooltip: "Çıkış Yap",
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1A237E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.4),
                                width: 2),
                          ),
                          child: const Icon(Icons.account_balance_rounded,
                              size: 34, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Yetkili Kurum Paneli",
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.kurumAdi,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.green
                                          .withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "Aktif",
                                      style: TextStyle(
                                          color: Colors.greenAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.verified_rounded,
                            color: Colors.lightBlueAccent, size: 22),
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
                  // Özet istatistikler
                  _buildStatsRow(),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Yönetim ve Koordinasyon"),
                  const SizedBox(height: 14),
                  // Ana fonksiyon kartları
                  _buildMainGrid(context),
                  const SizedBox(height: 24),
                  _buildSectionLabel("Hızlı Erişim"),
                  const SizedBox(height: 14),
                  _buildQuickActions(context),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard("12", "Aktif Talep", Icons.notifications_active_rounded,
            AppColors.accent),
        const SizedBox(width: 12),
        _buildStatCard("5", "Saha Ekibi", Icons.groups_rounded,
            AppColors.accentGreen),
        const SizedBox(width: 12),
        _buildStatCard("3", "Toplanma\nNoktası", Icons.location_on_rounded,
            AppColors.secondary),
      ],
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary),
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
    final List<Map<String, dynamic>> cards = [
      {
        'title': 'GELEN TALEPLER',
        'subtitle': 'Aktif yardım çağrıları',
        'icon': Icons.notifications_active_rounded,
        'color': AppColors.accent,
        'bgColor': const Color(0xFFFFEBEE),
        'targetPage': null,
      },
      {
        'title': 'AFET HARİTASI',
        'subtitle': 'Canlı yoğunluk takibi',
        'icon': Icons.map_rounded,
        'color': AppColors.secondary,
        'bgColor': const Color(0xFFE3F2FD),
        'targetPage': AcilHaritaSayfasi(isKurum: true),
      },
      {
        'title': 'EKİP YÖNETİMİ',
        'subtitle': 'Saha personeli takibi',
        'icon': Icons.groups_rounded,
        'color': AppColors.accentGreen,
        'bgColor': const Color(0xFFE8F5E9),
        'targetPage': null,
      },
      {
        'title': 'LOJİSTİK',
        'subtitle': 'Kaynak ve depo yönetimi',
        'icon': Icons.local_shipping_rounded,
        'color': AppColors.accentOrange,
        'bgColor': const Color(0xFFFFF3E0),
        'targetPage': null,
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
        return _buildAdminCard(context, card);
      },
    );
  }

  Widget _buildAdminCard(BuildContext context, Map<String, dynamic> card) {
    final bool hasTarget = card['targetPage'] != null;
    return GestureDetector(
      onTap: () {
        if (hasTarget) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => card['targetPage']),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Bu özellik yakında aktif olacak."),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
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

  Widget _buildQuickActions(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.announcement_rounded,
        'label': 'Duyuru Yayınla',
        'color': AppColors.secondary,
      },
      {
        'icon': Icons.bar_chart_rounded,
        'label': 'Raporlar',
        'color': AppColors.accentGreen,
      },
      {
        'icon': Icons.settings_rounded,
        'label': 'Ayarlar',
        'color': AppColors.textSecondary,
      },
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(
                  right: action == actions.last ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  Icon(action['icon'], color: action['color'], size: 26),
                  const SizedBox(height: 6),
                  Text(
                    action['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.dashboard_rounded, 'label': 'Panel'},
      {'icon': Icons.assignment_rounded, 'label': 'Görevler'},
      {'icon': Icons.message_rounded, 'label': 'İletişim'},
      {'icon': Icons.settings_rounded, 'label': 'Ayarlar'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
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
