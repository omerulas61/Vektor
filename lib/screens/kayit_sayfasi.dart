import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vektor/main.dart';
import 'package:vektor/theme/app_theme.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adSoyadController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();
  final TextEditingController _yakinAdSoyadController = TextEditingController();
  final TextEditingController _yakinTelController = TextEditingController();

  final List<String> _kanGruplari = [
    "A+", "A-", "B+", "B-", "AB+", "AB-", "0+", "0-"
  ];
  String? _secilenKanGrubu;
  bool _yukleniyor = false;
  bool _sifreGizli = true;
  int _aktifAdim = 0;

  Future<void> _verileriKaydet() async {
    try {
      await FirebaseFirestore.instance.collection('Kullanicilar').add({
        'adSoyad': _adSoyadController.text.trim(),
        'telefon': _telController.text.trim(),
        'sifre': _sifreController.text.trim(),
        'kanGrubu': _secilenKanGrubu,
        'yakinAdSoyad': _yakinAdSoyadController.text.trim(),
        'yakinTelefon': _yakinTelController.text.trim(),
        'kayitTarihi': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HomePage(adSoyad: _adSoyadController.text.trim()),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hata oluştu: ${e.toString()}"),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _adSoyadController.dispose();
    _telController.dispose();
    _sifreController.dispose();
    _yakinAdSoyadController.dispose();
    _yakinTelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Üst başlık
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            "Yeni Hesap Oluştur",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Adım göstergesi
                    _buildStepIndicator(),
                  ],
                ),
              ),
            ),
          ),
          // Form içeriği
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _aktifAdim == 0
                    ? _buildKisiselBilgiler()
                    : _buildYakinBilgileri(),
              ),
            ),
          ),
          // Alt buton
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(0, "Kişisel", Icons.person_rounded),
        _buildStepLine(),
        _buildStep(1, "Acil Kişi", Icons.emergency_rounded),
      ],
    );
  }

  Widget _buildStep(int index, String label, IconData icon) {
    final bool isActive = _aktifAdim >= index;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white24,
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.primary : Colors.white54,
            size: 22,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
        color: _aktifAdim >= 1 ? Colors.white : Colors.white24,
      ),
    );
  }

  Widget _buildKisiselBilgiler() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Kişisel Bilgiler", Icons.person_rounded,
            AppColors.secondary),
        const SizedBox(height: 20),
        _buildFormField(
          label: "Ad Soyad",
          icon: Icons.badge_rounded,
          controller: _adSoyadController,
          validator: (v) =>
              v == null || v.isEmpty ? "Bu alan zorunludur" : null,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: "Telefon Numarası",
          icon: Icons.phone_rounded,
          controller: _telController,
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v == null || v.isEmpty ? "Bu alan zorunludur" : null,
        ),
        const SizedBox(height: 16),
        _buildPasswordField(),
        const SizedBox(height: 16),
        _buildKanGrubuDropdown(),
      ],
    );
  }

  Widget _buildYakinBilgileri() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
            "Acil Durum Yakını", Icons.emergency_rounded, AppColors.accent),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Acil durumlarda ulaşılacak kişinin bilgilerini girin.",
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildFormField(
          label: "Yakın Ad Soyad",
          icon: Icons.person_outline_rounded,
          controller: _yakinAdSoyadController,
          validator: (v) =>
              v == null || v.isEmpty ? "Bu alan zorunludur" : null,
        ),
        const SizedBox(height: 16),
        _buildFormField(
          label: "Yakın Telefon Numarası",
          icon: Icons.phone_android_rounded,
          controller: _yakinTelController,
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v == null || v.isEmpty ? "Bu alan zorunludur" : null,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _sifreController,
      obscureText: _sifreGizli,
      validator: (v) {
        if (v == null || v.isEmpty) return "Bu alan zorunludur";
        if (v.length < 6) return "Şifre en az 6 karakter olmalıdır";
        return null;
      },
      decoration: InputDecoration(
        labelText: "Şifre Oluşturun",
        prefixIcon: const Icon(Icons.lock_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _sifreGizli
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () => setState(() => _sifreGizli = !_sifreGizli),
        ),
      ),
    );
  }

  Widget _buildKanGrubuDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Kan Grubu",
        prefixIcon: Icon(Icons.bloodtype_rounded, color: AppColors.accent),
      ),
      items: _kanGruplari
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (val) => setState(() => _secilenKanGrubu = val),
      validator: (v) => v == null ? "Lütfen kan grubunuzu seçin" : null,
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_aktifAdim > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => setState(() => _aktifAdim = 0),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppColors.secondary),
                ),
              ),
            if (_aktifAdim > 0) const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _aktifAdim == 0
                      ? AppColors.secondary
                      : AppColors.accentGreen,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _yukleniyor
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          if (_aktifAdim == 0) {
                            setState(() => _aktifAdim = 1);
                          } else {
                            setState(() => _yukleniyor = true);
                            await _verileriKaydet();
                            if (mounted) setState(() => _yukleniyor = false);
                          }
                        }
                      },
                child: _yukleniyor
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                      )
                    : Text(
                        _aktifAdim == 0 ? "DEVAM ET" : "KAYDI TAMAMLA",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
