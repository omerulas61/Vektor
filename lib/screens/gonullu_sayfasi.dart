import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/theme/app_theme.dart';

class GonulluSayfasi extends StatefulWidget {
  const GonulluSayfasi({super.key});

  @override
  State<GonulluSayfasi> createState() => _GonulluSayfasiState();
}

class _GonulluSayfasiState extends State<GonulluSayfasi> {

  // AcilYardimSayfasi'ndaki yeni renk ve ikon haritasıyla birebir eşleme yapıyoruz
  Map<String, dynamic> _getTurOzellikleri(String tur) {
    switch (tur) {
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

  // Gönüllünün yardımı üstlenmesini sağlayan fonksiyon
  Future<void> _yardimiUstlen(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('EtkinlikNoktalari')
          .doc(docId)
          .update({
        'durum': 'Gönüllü Yolda',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text("Yardım talebini üstlendiniz. Yolunuz açık olsun!")),
              ],
            ),
            backgroundColor: AppColors.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst Başlık Alanı (Yeni Tasarıma Uygun)
          Container(
            color: AppColors.primary,
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
                            "SAHA GÖNÜLLÜ PANELİ",
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
                          Icon(Icons.handshake_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Afetzedelerin çağrılarını inceleyin ve destek olun.",
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

          // Canlı İhtiyaç Listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('EtkinlikNoktalari')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Veriler yüklenirken bir hata oluştu."));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Şu an aktif bir yardım çağrısı bulunmuyor."));
                }

                // Toplanma Noktası haricindeki gerçek yardım taleplerini filtrele
                var cagrilar = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['tur'] != 'Toplanma Noktası';
                }).toList();

                if (cagrilar.isEmpty) {
                  return const Center(child: Text("Aktif afetzede çağrısı bulunmuyor."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cagrilar.length,
                  itemBuilder: (context, index) {
                    var doc = cagrilar[index];
                    var data = doc.data() as Map<String, dynamic>;

                    String docId = doc.id;
                    String baslik = data['baslik'] ?? 'Acil Durum Bildirimi';
                    String tur = data['tur'] ?? 'Genel Yardım';
                    String durum = data['durum'] ?? 'Bekliyor';
                    GeoPoint? konum = data['konum'];

                    var ozellik = _getTurOzellikleri(tur);
                    bool isYolda = durum == 'Gönüllü Yolda';

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
                        children: [
                          // Dinamik İkon Alanı
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: ozellik['bgColor'],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(ozellik['icon'], color: ozellik['color'], size: 26),
                          ),
                          const SizedBox(width: 14),

                          // Detaylar
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
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      "Durum: ",
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isYolda
                                            ? AppColors.accentGreen.withValues(alpha: 0.1)
                                            : AppColors.accentOrange.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        durum,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: isYolda ? AppColors.accentGreen : AppColors.accentOrange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (konum != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    "Konum: ${konum.latitude.toStringAsFixed(4)}, ${konum.longitude.toStringAsFixed(4)}",
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ]
                              ],
                            ),
                          ),

                          // Eylem Butonu
                          isYolda
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.accentGreen, size: 32)
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                            onPressed: () => _yardimiUstlen(docId),
                            child: const Text(
                              "YÖNEL",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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