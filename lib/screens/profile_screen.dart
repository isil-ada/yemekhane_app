import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onFavoritesTap;

  const ProfileScreen({super.key, this.onFavoritesTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D326F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Header Background
                Container(
                  height: 220, // Increased height to ensure visibility
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xFF0D326F)),
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Profilim",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Main Content Card
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  padding: const EdgeInsets.only(
                    top: 90,
                    bottom: 20,
                  ), // Increased top padding to avoid overlap
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        100 -
                        80, // rough height calc
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Ahmet Yılmaz",
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1D1E),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Menu Items
                      _buildProfileMenuItem(
                        icon: Icons.favorite_border,
                        text: "Favoriler",
                        onTap: () {
                          if (onFavoritesTap != null) {
                            onFavoritesTap!();
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Divider(height: 1),
                      ),
                      _buildProfileMenuItem(
                        icon: Icons.edit_outlined,
                        text: "Profili Düzenle",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Divider(height: 1),
                      ),
                      _buildProfileMenuItem(
                        icon: Icons.logout,
                        text: "Çıkış Yap",
                        isDestructive: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      "Çıkış yapılıyor...",
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );

                          Future.delayed(const Duration(seconds: 1), () {
                            if (context.mounted) {
                              Navigator.pop(context); // Close dialog
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Avatar
                Positioned(
                  top: 60, // 100 - 40 (half radius)
                  child: Stack(
                    children: [
                      Container(
                        width: 120, // Increased size slightly
                        height: 120, // Increased size slightly
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300, // Reverted to grey
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey.shade600, // Reverted icon color
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Profil Fotoğrafını Düzenle',
                                      style: GoogleFonts.inter(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1A1D1E),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.camera_alt_outlined,
                                      ),
                                      title: Text(
                                        'Fotoğraf Çek',
                                        style: GoogleFonts.inter(),
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.photo_library_outlined,
                                      ),
                                      title: Text(
                                        'Galeriden Seç',
                                        style: GoogleFonts.inter(),
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(
                              8,
                            ), // Increased padding
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D326F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18, // Increased size
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String text,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFFF0F0)
                    : const Color(0xFFF5F9FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFE53935)
                    : const Color(0xFF0D326F),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDestructive
                      ? const Color(0xFFE53935)
                      : const Color(0xFF1A1D1E),
                ),
              ),
            ),
            if (!isDestructive)
              Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          ],
        ),
      ),
    );
  }
}
