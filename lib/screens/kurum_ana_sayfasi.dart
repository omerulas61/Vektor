import 'package:flutter/material.dart';
import 'package:vektor/screens/acil_harita_sayfasi.dart';

class KurumAnaSayfasi extends StatelessWidget {
  final String kurumAdi; // Giriş yapan kurumun ismini tutan değişken

  const KurumAnaSayfasi({super.key, required this.kurumAdi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "VEKTÖR KURUM",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Çıkış mantığı buraya eklenebilir
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/image.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.6), // Kurum paneli biraz daha koyu olabilir
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Üst Bilgi Kartı (Kurum Bilgisi)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade900, width: 1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.account_balance, size: 35, color: Colors.blue.shade900),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Yetkili Kurum Paneli",
                            style: TextStyle(color: Color(0xFF6C7B8A), fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kurumAdi,
                            style: const TextStyle(
                              color: Color(0xFF2E3D49),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified, color: Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Yönetim ve Koordinasyon",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Kurum Fonksiyon Kartları
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildAdminCard(
                      context,
                      title: "GELEN TALEPLER",
                      subtitle: "Aktif yardım çağrıları",
                      icon: Icons.notifications_active,
                      iconColor: Colors.red,
                    ),
                    _buildAdminCard(
                      context,
                      title: "AFET HARİTASI",
                      subtitle: "Canlı yoğunluk takibi",
                      icon: Icons.map_outlined,
                      iconColor: Colors.blue.shade900,
                      targetPage: AcilHaritaSayfasi(), // Mevcut haritayı kurum da görebilir
                    ),
                    _buildAdminCard(
                      context,
                      title: "EKİP YÖNETİMİ",
                      subtitle: "Saha personeli takibi",
                      icon: Icons.groups,
                      iconColor: Colors.green.shade700,
                    ),
                    _buildAdminCard(
                      context,
                      title: "LOJİSTİK",
                      subtitle: "Kaynak ve depo yönetimi",
                      icon: Icons.local_shipping,
                      iconColor: Colors.orange.shade800,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Panel"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Görevler"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "İletişim"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context,
      {required String title,
        required String subtitle,
        required IconData icon,
        required Color iconColor,
        Widget? targetPage}) {
    return InkWell(
      onTap: () {
        if (targetPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetPage),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2E3D49),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF6C7B8A), fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}