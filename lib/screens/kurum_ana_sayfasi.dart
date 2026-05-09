import 'package:flutter/material.dart';

class KurumAnaSayfasi extends StatelessWidget {
  final String kurumAdi; // Giriş yapan kurumun adını göstermek için

  const KurumAnaSayfasi({super.key, required this.kurumAdi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kurum Paneli"),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context), // Çıkış yapınca geri döner
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_center, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "Hoş Geldiniz,\n$kurumAdi",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text("Buradan yardım taleplerini yönetebilirsiniz."),
          ],
        ),
      ),
    );
  }
}