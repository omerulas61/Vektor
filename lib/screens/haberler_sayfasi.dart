import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/theme/app_theme.dart';

class HaberlerSayfasi extends StatelessWidget {
  const HaberlerSayfasi({super.key});

  // AcilYardimSayfasi'ndaki turKodu değerleriyle birebir eşliyoruz
  Map<String, dynamic> _getAfetOzellikleri(String afetTuru) {
    switch (afetTuru) {
      case 'Enkaz Altında':
        return {
          'icon': Icons.house_siding_rounded,
          'color': const Color(0xFFB71C1C),
          'bgColor': const Color(0xFFFFEBEE),
        };
      case 'Yaralı':
        return {
          'icon': Icons.medical_services_rounded,
          'color': const Color(0xFFE65100),
          'bgColor': const Color(0xFFFFF3E0),
        };
      case 'Yangın':
        return {
          'icon': Icons.local_fire_department_rounded,
          'color': const Color(0xFFFF6F00),
          'bgColor': const Color(0xFFFFF8E1),
        };
      case 'Sel':
        return {
          'icon': Icons.water_rounded,
          'color': const Color(0xFF0277BD),
          'bgColor': const Color(0xFFE1F5FE),
        };
      case 'Kayıp':
        return {
          'icon': Icons.elderly_rounded,
          'color': const Color(0xFF6A1B9A),
          'bgColor': const Color(0xFFF3E5F5),
        };
      case 'Temel İhtiyaç':
        return {
          'icon': Icons.food_bank_rounded,
          'color': const Color(0xFF2E7D32),
          'bgColor': const Color(0xFFE8F5E9),
        };
      default:
        return {
          'icon': Icons.warning_amber_rounded,
          'color': AppColors.secondary,
          'bgColor': const Color(0xFFE3F2FD),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst Başlık Alanı (Gradient Tasarım)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)], // Yeşil tonlarında haber/duyuru teması
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
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "CANLI AFET AKIŞI",
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
                    // Bilgilendirme Bandı
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.gavel_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Sistem üzerinden bildirilen anlık afet ihbarları ve yardım çağrıları.",
                              style: TextStyle(color: Colors.white70, fontSize: 13),
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

          // Canlı İhbar / Haber Listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('EtkinlikNoktalari')
                  .orderBy('zaman', descending: true) // En son eklenen en üstte görünür
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Veriler yüklenirken bir hata oluştu."));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Şu an sistemde aktif bir afet ihbarı bulunmuyor.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                // Sadece gerçek afetleri filtrele (Toplanma Noktalarını haber olarak gösterme)
                var afetCagrileri = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['tur'] != 'Toplanma Noktası';
                }).toList();

                if (afetCagrileri.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aktif afet ihbarı bulunmuyor.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: afetCagrileri.length,
                  itemBuilder: (context, index) {
                    var doc = afetCagrileri[index];
                    var data = doc.data() as Map<String, dynamic>;

                    String baslik = data['baslik'] ?? 'Acil Durum Bildirisi';
                    String afetTuru = data['tur'] ?? 'Genel İhbar';
                    String durum = data['durum'] ?? 'Bekliyor';
                    GeoPoint? konum = data['konum'];

                    var ozellik = _getAfetOzellikleri(afetTuru);
                    bool isYolda = durum == 'Gönüllü Yolda';

                    // Koordinatları okunabilir metne çeviriyoruz
                    String konumMetni = konum != null
                        ? "${konum.latitude.toStringAsFixed(4)}, ${konum.longitude.toStringAsFixed(4)}"
                        : "Bilinmeyen Konum";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dinamik İkon Alanı
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: ozellik['bgColor'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(ozellik['icon'], color: ozellik['color'], size: 24),
                          ),
                          const SizedBox(width: 14),

                          // Haber İçeriği (Başlık, Afet Türü, Konum)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  baslik,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    // Afet Türü Etiketi
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: (ozellik['color'] as Color).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        afetTuru.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: ozellik['color'],
                                        ),
                                      ),
                                    ),

                                    // Konum Bilgisi (Koordinat)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.location_on_rounded, color: Colors.grey, size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          konumMetni,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Müdahale Durum Bilgisi
                                Row(
                                  children: [
                                    Text(
                                      "Müdahale: ",
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    Text(
                                      durum,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isYolda ? AppColors.accentGreen : AppColors.accentOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}