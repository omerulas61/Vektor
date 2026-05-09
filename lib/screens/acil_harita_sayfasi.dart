import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AcilHaritaSayfasi extends StatefulWidget {
  @override
  _AcilHaritaSayfasiState createState() => _AcilHaritaSayfasiState();
}

class _AcilHaritaSayfasiState extends State<AcilHaritaSayfasi> {

  GoogleMapController? _haritaKontrolcu;
  Set<Marker> _isaretciler = {};

  Future<void> _konumumaGit() async {
    bool servisEtkinmi = await Geolocator.isLocationServiceEnabled();
    if (!servisEtkinmi) {
      // Kullanıcıya konum servislerini açmasını söyleyebilirsin
      return Future.error('Konum servisleri kapalı.');
    }

    LocationPermission izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied) {
      izin = await Geolocator.requestPermission();
      if (izin == LocationPermission.denied) {
        return Future.error('Konum izni reddedildi.');
      }
    }

    if (izin == LocationPermission.deniedForever) {
      return Future.error('Konum izinleri kalıcı olarak reddedildi.');
    }

    // İzinler tamamsa konumu al
    Position konum = await Geolocator.getCurrentPosition();
    _haritaKontrolcu?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(konum.latitude, konum.longitude), zoom: 17),
      ),
    );
  }


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
      appBar: AppBar(title: const Text("Acil Durum Haritası")),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(39.9334, 32.8597), // Türkiye geneli başlangıç
          zoom: 6,
        ),
        onMapCreated: (GoogleMapController controller) {
          _haritaKontrolcu = controller; // Kontrolcüyü ata
          _konumumaGit(); // Harita açılır açılmaz konuma odaklan
        },

        markers: _isaretciler,
      ),
    );
  }
  Future<void> _konumIzniIste() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }



}