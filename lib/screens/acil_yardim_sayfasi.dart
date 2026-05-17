import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_harita_sayfasi.dart';
import 'package:vektor/theme/app_theme.dart';

class AcilYardimSayfasi extends StatelessWidget {
  const AcilYardimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> emergencyTypes = [
      {
        'icon': Icons.house_siding_rounded,
        'label': 'Enkaz Altındayım',
        'description': 'Çökmüş yapı altında mahsur kaldım',
        'turKodu': 'Enkaz Altında',
        'color': const Color(0xFFB71C1C),
        'bgColor': const Color(0xFFFFEBEE),
      },
      {
        'icon': Icons.medical_services_rounded,
        'label': 'Yaralı Var',
        'description': 'Tıbbi müdahale gerektiren yaralı',
        'turKodu': 'Yaralı',
        'color': const Color(0xFFE65100),
        'bgColor': const Color(0xFFFFF3E0),
      },
      {
        'icon': Icons.local_fire_department_rounded,
        'label': 'Yangın / Patlama',
        'description': 'Yangın veya patlama tehlikesi',
        'turKodu': 'Yangın',
        'color': const Color(0xFFFF6F00),
        'bgColor': const Color(0xFFFFF8E1),
      },
      {
        'icon': Icons.water_rounded,
        'label': 'Su Baskını',
        'description': 'Sel veya su baskını tehlikesi',
        'turKodu': 'Sel',
        'color': const Color(0xFF0277BD),
        'bgColor': const Color(0xFFE1F5FE),
      },
      {
        'icon': Icons.elderly_rounded,
        'label': 'Kayıp Kişi',
        'description': 'Kayıp veya ulaşılamayan kişi',
        'turKodu': 'Kayıp',
        'color': const Color(0xFF6A1B9A),
        'bgColor': const Color(0xFFF3E5F5),
      },
      {
        'icon': Icons.food_bank_rounded,
        'label': 'Temel İhtiyaç',
        'description': 'Gıda, su veya barınak ihtiyacı',
        'turKodu': 'Temel İhtiyaç',
        'color': const Color(0xFF2E7D32),
        'bgColor': const Color(0xFFE8F5E9),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst başlık
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7F0000), Color(0xFFB71C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "ACİL YARDIM TALEBİ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Uyarı bandı
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.amber, size: 22),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "Durumunuzu seçin, haritada konumunuzu belirleyin.",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Kart listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: emergencyTypes.length,
              itemBuilder: (context, index) {
                final item = emergencyTypes[index];
                return _buildEmergencyCard(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(
      BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AcilHaritaSayfasi(
              isKurum: false,
              secilenTur: item['turKodu'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: item['bgColor'],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(item['icon'], color: item['color'], size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['label'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (item['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded,
                  color: item['color'], size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
