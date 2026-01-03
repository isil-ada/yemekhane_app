import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../data/dummy_data.dart'; // For MenuItem model if needed, or use dynamic

class FavoritesScreen extends StatefulWidget {
  final Set<String> likedItems;
  final Function(String) onToggleLike;

  const FavoritesScreen({
    super.key,
    required this.likedItems,
    required this.onToggleLike,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<MenuItem> _favorites = []; // Using MenuItem model
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  @override
  void didUpdateWidget(covariant FavoritesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Check if the new likedItems set matches our current local data
    final currentIds = _favorites.map((e) => e.id).toSet();
    final newIds = widget.likedItems;

    bool isSame = currentIds.length == newIds.length && currentIds.containsAll(newIds);

    if (!isSame) {
      // Only fetch if there is a discrepancy (e.g. item added from Home)
      _fetchFavorites();
    }
  }

  Future<void> _fetchFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.get('/favorites');
      if (data is List) {
        setState(() {
          _favorites = data.map((e) => MenuItem.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print('Fetch favorites error: $e');
    } finally {
        if (mounted) {
            setState(() {
                _isLoading = false;
            });
        }
    }
  }

  Future<void> _removeFavorite(String dishId) async {
    // Optimistic UI update
    setState(() {
      _favorites.removeWhere((item) => item.id == dishId);
    });
    widget.onToggleLike(dishId); // Notify parent to update its state too

    try {
      await ApiService.delete('/favorites/$dishId');
    } catch (e) {
      print('Remove favorite error: $e');
      // Revert if needed? For now just print.
      _fetchFavorites(); // Refresh to be safe
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : _favorites.isEmpty
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
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final item = _favorites[index];
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
                        child: Icon(
                           item.category == 'Başlangıç'
                              ? Icons.soup_kitchen
                              : item.category == 'Ana Yemek'
                              ? Icons.dinner_dining
                              : item.category == 'Yardımcı Yemek'
                              ? Icons.rice_bowl
                              : Icons.emoji_food_beverage,
                          color: const Color(0xFF0D326F),
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
                        onPressed: () => _removeFavorite(item.id),
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
