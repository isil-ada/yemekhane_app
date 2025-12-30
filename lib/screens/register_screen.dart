import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _termsAccepted = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _navigateToHome() {
    // Validation
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
      );
      return;
    }

    // Email Validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir e-posta girin.')),
      );
      return;
    }

    // Password Validation
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifre en az 6 karakter olmalıdır.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Şifreler eşleşmiyor.')));
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen kullanım koşullarını kabul edin.'),
        ),
      );
      return;
    }

    // Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Material(
                color: Colors.transparent,
                child: Text(
                  "Kayıt oluşturuldu, giriş yapılıyor...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close dialog
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kullanım Koşulları"),
        content: SingleChildScrollView(
          child: Text(
            "Ankara Üniversitesi Yemekhane Uygulaması Kullanım Koşulları:\\n\\n"
            "1. Bu uygulama sadece üniversite öğrencileri ve personeli içindir.\\n"
            "2. Yemek rezervasyonları kişiye özeldir.\\n"
            "3. Kötüye kullanım tespit edildiğinde hesabınız askıya alınabilir.\\n"
            "4. Menü içerikleri günlük olarak değişebilir.",
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gizlilik Politikası"),
        content: SingleChildScrollView(
          child: Text(
            "Ankara Üniversitesi Yemekhane Uygulaması Gizlilik Politikası:\\n\\n"
            "1. Kişisel verileriniz (Ad, Soyad, E-posta) sadece hizmet sunumu için kullanılır.\\n"
            "2. Verileriniz üçüncü şahıslarla paylaşılmaz.\\n"
            "3. Uygulama çerezleri sadece oturum yönetimi için kullanır.\\n"
            "4. Verileriniz KVKK kapsamında korunmaktadır.",
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Logo
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 24),
            Text(
              'Kayıt Ol',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1D1E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yemekhane hesabınızı oluşturun ve sipariş\nvermeye başlayın',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ad Soyad',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _nameController,
              hintText: 'Adınız ve Soyadınız',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            // Username field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kullanıcı Adı',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _usernameController,
              hintText: 'Kullanıcı Adı',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            // Email field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'E-posta',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _emailController,
              hintText: 'ornek@sirket.com',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),

            // Password field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Şifre',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _passwordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              isObscure: !_isPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 16),

            // Confirm Password field
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Şifre Tekrar',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              isObscure: !_isConfirmPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 24),

            // Terms
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _termsAccepted,
                    activeColor: const Color(0xFF0D326F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _termsAccepted = val ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'Kullanım Koşulları',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0D326F),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _showTermsDialog,
                      children: [
                        TextSpan(
                          text: '\'nı ve ',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1A1D1E),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: 'Gizlilik Politikası',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0D326F),
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _showPrivacyDialog,
                        ),
                        TextSpan(
                          text: '\'nı\nokudum ve kabul ediyorum.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF1A1D1E),
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _navigateToHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D326F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF0D326F).withOpacity(0.4),
                ),
                child: Text(
                  'Hesap Oluştur',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Zaten bir hesabınız var mı?',
                  style: GoogleFonts.inter(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: _navigateToLogin,
                  child: Text(
                    'Giriş Yap',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0D326F),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
