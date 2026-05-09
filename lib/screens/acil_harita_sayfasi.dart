import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AcilHaritaSayfasi extends StatefulWidget {
  final bool isKurum; // Kurum olup olmadığını anlamak için değişken ekledik
  final String? secilenTur;
  const AcilHaritaSayfasi({super.key, this.isKurum = false,this.secilenTur,});

  @override
  _AcilHaritaSayfasiState createState() => _AcilHaritaSayfasiState();
}

class _AcilHaritaSayfasiState extends State<AcilHaritaSayfasi> {
  GoogleMapController? _haritaKontrolcu;
  Set<Marker> _isaretciler = {};
  DateTime? _sonTiklamaZamani;


  // Düzenleme modu için değişkenler
  bool _duzenlemeModu = false;
  LatLng _merkezKonum = const LatLng(39.9334, 32.8597);

  @override
  void initState() {
    super.initState();
    _noktalariCanliDinle(); // Verileri anlık (stream) olarak çekmek daha iyidir
  }

  // Firestore'u anlık dinleyen fonksiyon
  void _noktalariCanliDinle() {
    FirebaseFirestore.instance
        .collection('EtkinlikNoktalari')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        setState(() {
          _isaretciler = snapshot.docs.map((doc) {
            GeoPoint konum = doc['konum'];
            String tur = doc['tur'] ?? 'bilinmiyor';
            return Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(konum.latitude, konum.longitude),
              infoWindow: InfoWindow(
                title: doc['baslik'],
                snippet: "$tur (Silmek için dokunun)",
              ),


              // BURASI YENİ: Sadece kurumsa tıklayınca silme uyarısı ver
              onTap: () {
                // Eğer hem kurum giriş yapmışsa hem de "Düzenle" modu açıksa
                if (widget.isKurum && _duzenlemeModu) {
                  _silmeOnayiAl(doc.id); // Tek tıklamada silme sorusunu sor
                } else if (widget.isKurum && !_duzenlemeModu) {
                  // Düzenleme modu kapalıyken sadece bilgi verebilirsin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Silmek için önce 'Düzenle' modunu açmalısınız."),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  tur == 'Toplanma Noktası'
                      ? BitmapDescriptor.hueAzure
                      : BitmapDescriptor.hueRed
              ),
            );
          }).toSet();
        });
      }
    });
  }

  Future<void> _yardimNoktasiEkle() async {
    try {
      await FirebaseFirestore.instance.collection('EtkinlikNoktalari').add({
        // widget.secilenTur diyerek yukarıdaki değere ulaşıyoruz
        'baslik': widget.secilenTur ?? "Acil Bildirim",
        'tur': widget.secilenTur ?? "Genel Yardım",
        'konum': GeoPoint(_merkezKonum.latitude, _merkezKonum.longitude),
        'zaman': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Yardım talebiniz başarıyla iletildi!")),
        );
        Navigator.pop(context); // Kayıttan sonra ana sayfaya dön
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }







  Future<void> _silmeOnayiAl(String docId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Noktayı Sil"),
        content: const Text("bu toplanma alanını veya bildirimini haritadan kaldırmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Vazgeç"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _noktayiSil(docId);
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Sil", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

// Firestore'dan veriyi silen asıl fonksiyon
  Future<void> _noktayiSil(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('EtkinlikNoktalari')
          .doc(docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nokta başarıyla silindi.")),
        );
      }
    } catch (e) {
      debugPrint("Silme hatası: $e");
    }
  }





  // Yeni Toplanma Noktası Ekleme
  Future<void> _toplanmaNoktasiEkle() async {
    try {
      await FirebaseFirestore.instance.collection('EtkinlikNoktalari').add({
        'baslik': 'Güvenli Toplanma Alanı',
        'tur': 'Toplanma Noktası',
        'konum': GeoPoint(_merkezKonum.latitude, _merkezKonum.longitude),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Toplanma noktası sisteme eklendi!")),
        );
        setState(() => _duzenlemeModu = false);
      }
    } catch (e) {
      debugPrint("Hata: $e");
    }
  }

  Future<void> _konumumaGit() async {
    bool servisEtkinmi = await Geolocator.isLocationServiceEnabled();
    if (!servisEtkinmi) return;

    LocationPermission izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
      if (izin == LocationPermission.denied) return;
    }

    Position konum = await Geolocator.getCurrentPosition();
    _haritaKontrolcu?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(konum.latitude, konum.longitude), zoom: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acil Durum Haritası"),
        backgroundColor: widget.isKurum ? Colors.blue.shade900 : null,
        foregroundColor: widget.isKurum ? Colors.white : null,
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: !_duzenlemeModu,
            initialCameraPosition: const CameraPosition(
              target: LatLng(39.9334, 32.8597),
              zoom: 6,
            ),
            onMapCreated: (controller) {
              _haritaKontrolcu = controller;
              _konumumaGit();
            },
            onCameraMove: (CameraPosition position) {
              _merkezKonum = position.target; // Harita kaydıkça orta noktayı güncelle
            },
            markers: _isaretciler,
          ),

          // 1. Düzenleme İkonu (Sadece mod açıkken merkeze gelir)
          if (_duzenlemeModu)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Icon(Icons.add_location_alt, color: Colors.blue, size: 50),
              ),
            ),

          // 2. Düzenle Butonu (Sadece kurumsa ve mod kapalıysa görünür)
          if (widget.isKurum && !_duzenlemeModu)
            Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton.extended(
                onPressed: () => setState(() => _duzenlemeModu = true),
                label: const Text("Düzenle"),
                icon: const Icon(Icons.edit_location_alt),
                backgroundColor: Colors.blue.shade900,
              ),
            ),

          // 3. Alt Kayıt Paneli (Düzenleme modu açıkken görünür)
          if (_duzenlemeModu)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Toplanma noktasını seçmek için haritayı kaydırın.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _toplanmaNoktasiEkle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("TOPLANMA NOKTASI OLARAK BELİRLE"),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _duzenlemeModu = false),
                        child: const Text("Vazgeç", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (widget.secilenTur != null && !widget.isKurum)
            Positioned(
              bottom: 30,
              left: 40,
              right: 40,
              child: Column(
                children: [
                  // Merkeze odaklanmayı kolaylaştıran bir işaretçi (opsiyonel)
                  const Icon(Icons.arrow_downward, color: Colors.white, size: 30),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _yardimNoktasiEkle, // Senin yazdığın fonksiyonu çağırıyoruz
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text(
                        "${widget.secilenTur?.toUpperCase()} KONUMUNU BİLDİR",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

// Kullanıcı için de merkeze bir pin koyalım ki nereyi seçtiğini anlasın
          if (widget.secilenTur != null && !widget.isKurum)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Icon(Icons.location_on, color: Colors.red, size: 50),
              ),
            ),










        ],
      ),
    );
  }
}