import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'home_screen.dart';
import 'complaint_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';

class MainTabScreen extends StatefulWidget {
  final bool isGuest;

  const MainTabScreen({super.key, this.isGuest = false});

  static Route<dynamic> createRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  Set<String> _likedItems = {};

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _fetchLikedItems();
    }
  }

  Future<void> _fetchLikedItems() async {
    try {
      final favorites = await ApiService.get('/favorites');
      if (favorites is List) {
        setState(() {
          _likedItems = favorites.map<String>((e) => e['dish_id'].toString()).toSet();
        });
      }
    } catch (e) {
      print('Error fetching initial favorites: $e');
    }
  }

  void _toggleLike(String itemId) {
    setState(() {
      final newSet = Set<String>.from(_likedItems);
      if (newSet.contains(itemId)) {
        newSet.remove(itemId);
      } else {
        newSet.add(itemId);
      }
      _likedItems = newSet;
    });
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(
        isGuest: widget.isGuest,
        likedItems: _likedItems,
        onToggleLike: _toggleLike,
      ),
      FavoritesScreen(likedItems: _likedItems, onToggleLike: _toggleLike),
      ComplaintScreen(
        onGoHome: () {
          _switchTab(0);
        },
      ),
      ProfileScreen(
        onFavoritesTap: () {
          _switchTab(1);
        },
      ),
    ];
  }

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _showLoginRequiredDialog() {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _buildScreens()),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (widget.isGuest && index != 0) {
              _showLoginRequiredDialog();
              return;
            }
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0D326F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showUnselectedLabels: true,
          selectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.feedback,
              ), // Should ideally be chat/message icon as per UI
              label: 'Şikayet',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
