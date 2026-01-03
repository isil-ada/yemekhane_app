import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _savePassword() async {
    final oldPass = _oldPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun.")),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yeni şifreler eşleşmiyor.")),
      );
      return;
    }

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Yeni şifre en az 6 karakter olmalı.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.post('/auth/change-password', {
        'currentPassword': oldPass,
        'newPassword': newPass,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Şifreniz başarıyla değiştirildi."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Hata: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Şifre Değiştir",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D326F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Eski Şifre',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _oldPasswordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              isObscure: !_isOldPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isOldPasswordVisible = !_isOldPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Yeni Şifre',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: _newPasswordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              isObscure: !_isNewPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Yeni Şifre Tekrar',
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
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D326F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                  "Kaydet",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
