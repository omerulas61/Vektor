import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/theme/app_theme.dart';

class GelenTaleplerSayfasi extends StatelessWidget {
  const GelenTaleplerSayfasi({super.key});

  // Kategori bazlı ikon ve renk eşleşmeleri
  Map<String, dynamic> _getKategoriOzellikleri(String tur) {
    switch (tur) {
      case 'Enkaz Altında':
        return {'icon': Icons.house_siding_rounded, 'color': const Color(0xFFB71C1C), 'bgColor': const Color(0xFFFFEBEE)};
      case 'Yaralı':
        return {'icon': Icons.medical_services_rounded, 'color': const Color(0xFFE65100), 'bgColor': const Color(0xFFFFF3E0)};
      case 'Yangın':
        return {'icon': Icons.local_fire_department_rounded, 'color': const Color(0xFFFF6F00), 'bgColor': const Color(0xFFFFF8E1)};
      case 'Sel':
        return {'icon': Icons.water_rounded, 'color': const Color(0xFF0277BD), 'bgColor': const Color(0xFFE1F5FE)};
      case 'Kayıp':
        return {'icon': Icons.elderly_rounded, 'color': const Color(0xFF6A1B9A), 'bgColor': const Color(0xFFF3E5F5)};
      case 'Temel İhtiyaç':
        return {'icon': Icons.food_bank_rounded, 'color': const Color(0xFF2E7D32), 'bgColor': const Color(0xFFE8F5E9)};
      default:
        return {'icon': Icons.warning_amber_rounded, 'color': AppColors.secondary, 'bgColor': const Color(0xFFE3F2FD)};
    }
  }

  // Yetkilinin talebi sonuçlandırmasını (Kapatmasını) sağlayan fonksiyon
  Future<void> _talebiGuncelle(BuildContext context, String docId, String yeniDurum) async {
    try {
      await FirebaseFirestore.instance
          .collection('EtkinlikNoktalari')
          .doc(docId)
          .update({'durum': yeniDurum});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Talep durumu '$yeniDurum' olarak güncellendi."),
            backgroundColor: AppColors.accentGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      debugPrint("Güncelleme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst Başlık (Kurumsal Lacivert Gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
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
                            "GELEN YARDIM TALEPLERİ",
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
                    // Kurumsal Bilgi Bandı
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_rounded, color: Colors.lightBlueAccent, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Sahadan gelen tüm ihbarları, müdahale durumlarını ve toplanan maddi destekleri buradan yönetin.",
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

          // Canlı Talep Listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('EtkinlikNoktalari')
                  .orderBy('zaman', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Veriler yüklenirken bir hata oluştu."));
                }

                // Sadece gerçek afetzede ihbarlarını filtrele (Toplanma alanlarını gösterme)
                var talepler = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['tur'] != 'Toplanma Noktası';
                }).toList();

                if (talepler.isEmpty) {
                  return const Center(
                    child: Text(
                      "Şu an sistemde incelenmeyi bekleyen bir talep bulunmuyor.",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: talepler.length,
                  itemBuilder: (context, index) {
                    var doc = talepler[index];
                    var data = doc.data() as Map<String, dynamic>;

                    String docId = doc.id;
                    String baslik = data['baslik'] ?? 'İsimsiz Bildirim';
                    String tur = data['tur'] ?? 'Genel';
                    String durum = data['durum'] ?? 'Bekliyor';
                    int toplananBagis = data['toplananBagis'] ?? 0;
                    GeoPoint? konum = data['konum'];

                    var ozellik = _getKategoriOzellikleri(tur);

                    String konumMetni = konum != null
                        ? "${konum.latitude.toStringAsFixed(4)}, ${konum.longitude.toStringAsFixed(4)}"
                        : "Konum Bilgisi Yok";

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Dinamik Kategori İkonu
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

                              // Talep Bilgileri
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      baslik,
                                      style: const TextStyle(
                                        fontSize: 16,
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
                                        // Tür Rozeti
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: (ozellik['color'] as Color).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            tur.toUpperCase(),
                                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ozellik['color']),
                                          ),
                                        ),
                                        // Konum Bilgisi
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.location_on_rounded, color: Colors.grey, size: 14),
                                            const SizedBox(width: 2),
                                            Text(
                                              konumMetni,
                                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: AppColors.divider, height: 1),
                          ),

                          // Finansal Takip ve Durum Çubuğu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Toplam Ulaşan Bağış Bilgisi (İstediğin Kritik Kısım)
                              Row(
                                children: [
                                  const Icon(Icons.volunteer_activism_rounded, color: Colors.green, size: 18),
                                  const SizedBox(width: 6),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Ulaşan Maddi Yardım", style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                      Text(
                                        "$toplananBagis ₺",
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Durum Yönetim Butonları
                              if (durum != 'Çözüldü')
                                Row(
                                  children: [
                                    // Gönüllü yoldaysa veya durum bekliyorsa "Çözüldü" olarak işaretleme seçeneği
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 0,
                                      ),
                                      onPressed: () => _talebiGuncelle(context, docId, 'Çözüldü'),
                                      icon: const Icon(Icons.check_rounded, size: 16),
                                      label: const Text("Çözüldü Yap", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGreen.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.done_all_rounded, color: AppColors.accentGreen, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "Tamamlandı",
                                        style: TextStyle(color: AppColors.accentGreen, fontSize: 11, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
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