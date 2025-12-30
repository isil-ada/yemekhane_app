import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/dummy_data.dart';
import 'rate_menu_screen.dart';

class MenuDetailScreen extends StatefulWidget {
  final bool isGuest;
  const MenuDetailScreen({super.key, this.isGuest = false});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // In a real app, we would pass arguments via ModalRoute. For now, using the first menu as dummy.
    final Menu menu = DummyData.lunchMenus[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Günün Menüsü Detay',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF0D326F), // Dark blue from header
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    menu.date,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D326F),
                    ),
                  ),
                  Text(
                    menu.dayName,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Menü İçeriği'),
            const SizedBox(height: 16),
            ...menu.items.map((item) => _buildMenuItem(item)),

            const SizedBox(height: 24),
            _buildSectionHeader('Değerlendirmeler'),
            const SizedBox(height: 16),
            _buildRatingSummary(),
            const SizedBox(height: 16),
            ...DummyData.reviews.map((review) => _buildReviewItem(review)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (widget.isGuest) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Giriş Yapın"),
                        content: const Text(
                          "Bu işlemi yapmak için giriş yapmanız gerekmektedir.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tamam"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: const Text("Giriş Yap"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RateMenuScreen()),
                  );
                },
                icon: const Icon(Icons.star, color: Color(0xFFFFC107)),
                label: Text(
                  'Puan Ver',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D326F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF0D326F),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1D1E),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.category == 'Başlangıç'
                  ? const Color(0xFFFFF3E0)
                  : item.category == 'Ana Yemek'
                  ? const Color(0xFFE3F2FD)
                  : item.category == 'Yardımcı Yemek'
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.category == 'Başlangıç'
                  ? Icons.soup_kitchen
                  : item.category == 'Ana Yemek'
                  ? Icons.dinner_dining
                  : item.category == 'Yardımcı Yemek'
                  ? Icons.rice_bowl
                  : Icons.emoji_food_beverage,
              color: item.category == 'Başlangıç'
                  ? Colors.orange
                  : item.category == 'Ana Yemek'
                  ? Colors.blue
                  : item.category == 'Yardımcı Yemek'
                  ? Colors.green
                  : Colors.red,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1D1E),
                  ),
                ),
                Text(
                  item.category,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '4.5',
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1D1E),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < 4 ? Icons.star : Icons.star_half,
                    color: const Color(0xFFFFC107),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '128 Oy',
                style: GoogleFonts.inter(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildProgressBar(5, 0.8),
                _buildProgressBar(4, 0.2),
                _buildProgressBar(3, 0.05),
                _buildProgressBar(2, 0.02),
                _buildProgressBar(1, 0.01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF0D326F),
                ),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: review.rating > 4
                    ? const Color(0xFFFFCCBC)
                    : const Color(0xFFCFD8DC),
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1D1E),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFFC107),
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: GoogleFonts.inter(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: GoogleFonts.inter(color: Colors.grey.shade700, height: 1.4),
          ),
        ],
      ),
    );
  }
}
