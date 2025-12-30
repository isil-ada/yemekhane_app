import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/dummy_data.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> likedItems;
  final Function(String) onToggleLike;

  const FavoritesScreen({
    super.key,
    required this.likedItems,
    required this.onToggleLike,
  });

  @override
  Widget build(BuildContext context) {
    // Find all items that are in the likedItems set
    final allItems = [
      ...DummyData.lunchMenus.expand((menu) => menu.items),
      // ...DummyData.dinnerMenus.expand((menu) => menu.items), // Dinner menus not implemented yet
    ];
    // Remove duplicates if any (though IDs should be unique)
    final uniqueItems = {
      for (var item in allItems) item.id: item,
    }.values.toList();

    final favoriteItems = uniqueItems
        .where((item) => likedItems.contains(item.id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Favorilerim',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF0D326F),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: favoriteItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz favori eklemediniz',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: Color(0xFF0D326F),
                          size: 20,
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
                              '${item.calories} kcal',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => onToggleLike(item.id),
                        icon: const Icon(Icons.favorite, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
