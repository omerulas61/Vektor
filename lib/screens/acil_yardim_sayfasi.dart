import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_harita_sayfasi.dart'; // Harita sayfanı import et

class AcilYardimSayfasi extends StatelessWidget {
  const AcilYardimSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ACİL YARDIM TALEBİ"),
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Durumunuzu en iyi tanımlayan seçeneği seçin:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildEmergencyButton(
                      context,
                      Icons.house_siding,
                      "Enkaz Altındayım",
                      "Enkaz Altında"
                  ),
                  _buildEmergencyButton(
                      context,
                      Icons.medical_services,
                      "Yaralı Var",
                      "Yaralı"
                  ),
                  _buildEmergencyButton(
                      context,
                      Icons.fire_truck,
                      "Yangın / Patlama",
                      "Yangın"
                  ),
                  _buildEmergencyButton(
                      context,
                      Icons.waves,
                      "Su Baskını",
                      "Sel"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context, IconData icon, String label, String turKodu) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
      ),
      onPressed: () {
        // Butona basıldığında harita sayfasını "seçim modunda" açıyoruz
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcilHaritaSayfasi(
              isKurum: false,
              secilenTur: turKodu, // Hangi butona basıldığını haritaya gönderiyoruz
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}