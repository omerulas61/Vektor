import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AcilHaritaSayfasi extends StatefulWidget {
  @override
  _AcilHaritaSayfasiState createState() => _AcilHaritaSayfasiState();
}

class _AcilHaritaSayfasiState extends State<AcilHaritaSayfasi> {
  Set<Marker> _isaretciler = {};

  @override
  void initState() {
    super.initState();
    _noktalariGetir(); // Sayfa açılınca verileri çek
  }

  // Firestore'dan kurumların girdiği noktaları çeken fonksiyon
  void _noktalariGetir() async {
    var noktalar = await FirebaseFirestore.instance.collection('EtkinlikNoktalari').get();

    setState(() {
      _isaretciler = noktalar.docs.map((doc) {
        GeoPoint konum = doc['konum'];
        return Marker(
          markerId: MarkerId(doc.id),
          position: LatLng(konum.latitude, konum.longitude),
          infoWindow: InfoWindow(title: doc['baslik'], snippet: doc['tur']),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              doc['tur'] == 'toplanma' ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Acil Durum Haritası")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(39.9334, 32.8597), // Başlangıçta Ankara'yı açar
          zoom: 6,
        ),
        markers: _isaretciler, // İşaretçileri haritaya ekle
      ),
    );
  }
}