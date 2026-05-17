import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/theme/app_theme.dart';

class DestekOlSayfasi extends StatelessWidget {
  const DestekOlSayfasi({super.key});

  // Afet türüne göre ikon ve renk haritası
  Map<String, dynamic> _getTurOzellikleri(String tur) {
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

  // Bağış miktarını alan ve veritabanını güncelleyen pencere
  void _bagisPenceresiniAc(BuildContext context, String docId, String afetzedeAdi) {
    final TextEditingController miktarController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "$afetzedeAdi İçin Destek",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Göndermek istediğiniz yardım miktarını Türk Lirası (₺) cinsinden giriniz.",
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: miktarController,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: "Destek Miktarı",
                  prefixIcon: Icon(Icons.line_weight_rounded, color: Color(0xFF7B1FA2)),
                  suffixText: "TL",
                  hintText: "Örn: 250",
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Lütfen bir miktar girin";
                  if (int.tryParse(v) == null || int.parse(v) <= 0) return "Geçerli bir miktar girin";
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Vazgeç", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                int girilenMiktar = int.parse(miktarController.text.trim());

                // Firestore güncellemesi (Mevcut paranın üstüne ekler)
                await FirebaseFirestore.instance
                    .collection('EtkinlikNoktalari')
                    .doc(docId)
                    .update({
                  'toplananBagis': FieldValue.increment(girilenMiktar),
                });

                if (context.mounted) {
                  Navigator.pop(ctx); // Pencereyi kapat
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text("$girilenMiktar ₺ değerindeki desteğiniz başarıyla iletildi!")),
                        ],
                      ),
                      backgroundColor: AppColors.accentGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              }
            },
            child: const Text("Destek Ol"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst Başlık (Mor Gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
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
                            "MADDİ DESTEK PANELİ",
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
                    // Bilgi Bandı
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Mağdur durumdaki afetzedelere doğrudan maddi destekte bulunun.",
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

          // Afetzede Listesi (Canlı Akış)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('EtkinlikNoktalari').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Veriler yüklenirken hata oluştu."));
                }

                // Toplanma alanları hariç gerçek kişileri/afet durumlarını listele
                var afetzedeler = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  return data['tur'] != 'Toplanma Noktası';
                }).toList();

                if (afetzedeler.isEmpty) {
                  return const Center(
                    child: Text("Maddi yardım bekleyen aktif afetzede kaydı bulunamadı."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: afetzedeler.length,
                  itemBuilder: (context, index) {
                    var doc = afetzedeler[index];
                    var data = doc.data() as Map<String, dynamic>;

                    String docId = doc.id;
                    String baslik = data['baslik'] ?? 'Afetzede Yardımı';
                    String tur = data['tur'] ?? 'Genel';
                    int tolananBagis = data['toplananBagis'] ?? 0;

                    var ozellik = _getTurOzellikleri(tur);

                    return GestureDetector(
                      onTap: () => _bagisPenceresiniAc(context, docId, baslik),
                      child: Container(
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
                            // İkon Alanı
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
                                  Text(
                                    "Kategori: $tur",
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 6),
                                  // Şu ana kadar toplanan miktar göstergesi
                                  Row(
                                    children: [
                                      const Icon(Icons.monetization_on_rounded, color: Colors.green, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Ulaşan Destek: ",
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                      Text(
                                        "$tolananBagis ₺",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Tıklama İpucu Butonu
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "DESTEK",
                                style: TextStyle(
                                  color: Color(0xFF4A148C),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
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