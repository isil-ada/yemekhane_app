import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/dummy_data.dart';
import '../services/api_service.dart';

class AllMenusScreen extends StatefulWidget {
  final Set<String> likedItems;
  final Function(String) onToggleLike;
  final bool isGuest;

  const AllMenusScreen({
    super.key,
    required this.likedItems,
    required this.onToggleLike,
    this.isGuest = false,
  });

  @override
  State<AllMenusScreen> createState() => _AllMenusScreenState();
}

class _AllMenusScreenState extends State<AllMenusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Menu> _lunchMenus = [];
  List<Menu> _dinnerMenus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchMenus();
  }

  @override
  void didUpdateWidget(covariant AllMenusScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent updates likes, we might need to rebuild our lists?
    // Actually we just read from widget.likedItems in build, but our lists have `isLiked` locally.
    // We should probably rely on widget.likedItems for the UI icon state, OR sync our local lists.
    // Easiest is to check widget.likedItems in the list builder.
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenus() async {
    // ... same content ...
    // Note: The previous replaces block needs the full content if I replace large chunks.
    // I will try to keep this focused.

    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch Lunch
      try {
        final lunchData = await ApiService.get(
          '/lunch/month?year=2025&month=12',
        );
        if (lunchData != null && lunchData is List) {
          _lunchMenus = lunchData.map((e) => Menu.fromJson(e)).where((m) {
            try {
              return m.date.contains('Aralık') ||
                  m.date.contains('December') ||
                  m.date.contains('-12-');
            } catch (e) {
              return true;
            }
          }).toList();
        }
      } catch (e) {
        print('Error fetching lunch monthly: $e');
      }

      // Fetch Dinner
      try {
        final dinnerData = await ApiService.get(
          '/dinner/month?year=2025&month=12',
        );
        if (dinnerData != null && dinnerData is List) {
          _dinnerMenus = dinnerData.map((e) => Menu.fromJson(e)).where((m) {
            try {
              return m.date.contains('Aralık') ||
                  m.date.contains('December') ||
                  m.date.contains('-12-');
            } catch (e) {
              return true;
            }
          }).toList();
        }
      } catch (e) {
        print('Error fetching dinner monthly: $e');
      }
    } catch (e) {
      print('General Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _toggleLike(Menu menu, MenuItem item) async {
    if (widget.isGuest) {
      // Show login dialog (can copy from HomeScreen)
      return;
    }

    // Call parent toggle
    widget.onToggleLike(item.id);

    // We also update local list state to avoid flicker?
    // Actually if we use widget.likedItems in build, we just need to ensure parent updates and we rebuild.
    // Parent `onToggleLike` does setState, so Parent rebuilds its children.
    // But AllMenusScreen is PUSHED. It is NOT a child of HomeScreen in the widget tree sense (it's in Overlay).
    // So Parent setState does NOT rebuild AllMenusScreen automatically unless we are using a state management solution.
    // HOWEVER, we called `widget.onToggleLike`.
    // We should ALSO update our local UI state here to reflect change immediately.

    // Update local API (Optimistic) -> actually parent might do it?
    // No, parent `MainTabScreen` just updates local Set. It DOES NOT call API.
    // API calls are done in buttons.
    // Wait, let's check HomeScreen. HomeScreen calls API inside `_toggleFavorite`.
    // `MainTabScreen` `_toggleLike` ONLY updates Set.

    // So WE need to call API here, AND update Parent Set.

    // 1. Update Parent Set (via callback)
    // 2. Call API
    // 3. Update local button state (via setState)

    setState(() {
      // Just force rebuild to reflect widget.likedItems?
      // No, widget.likedItems won't change because parent setState doesn't rebuild pushed route.
      // So we must rely on our LOCAL check against "what we think is the new state".
      // OR we update our local `isLiked` in the list.

      List<Menu> targetList = _lunchMenus.contains(menu)
          ? _lunchMenus
          : _dinnerMenus;
      final menuIndex = targetList.indexOf(menu);
      if (menuIndex == -1) return;
      final itemIndex = menu.items.indexOf(item);
      if (itemIndex == -1) return;

      // Copy and update item
      final newItem = MenuItem(
        id: item.id,
        name: item.name,
        category: item.category,
        calories: item.calories,
        isLiked: !item.isLiked, // Toggle local state
      );

      final newItems = List<MenuItem>.from(menu.items);
      newItems[itemIndex] = newItem;

      final newMenu = Menu(
        date: menu.date,
        dayName: menu.dayName,
        items: newItems,
        totalCalories: menu.totalCalories,
        avgRating: menu.avgRating,
        ratingCount: menu.ratingCount,
        userRating: menu.userRating,
        originalDate: menu.originalDate,
        id: menu.id,
      );

      targetList[menuIndex] = newMenu;
    });

    // API Call
    try {
      if (!item.isLiked) {
        // Was not liked, so we liked it
        await ApiService.post('/favorites', {'dish_id': item.id});
      } else {
        await ApiService.delete('/favorites/${item.id}');
      }
    } catch (e) {
      print('Fav toggle error in AllMenus: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aylık Yemek Listesi",
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D326F),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0D326F),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0D326F),
          tabs: const [
            Tab(text: 'Öğle Yemeği'),
            Tab(text: 'Akşam Yemeği'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMenuList(_lunchMenus, "Öğle yemeği bulunamadı."),
                _buildMenuList(_dinnerMenus, "Akşam yemeği bulunamadı."),
              ],
            ),
    );
  }

  Widget _buildMenuList(List<Menu> menus, String emptyMessage) {
    if (menus.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: menus.length,
      itemBuilder: (context, index) {
        final menu = menus[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    menu.date,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1D1E),
                    ),
                  ),
                  Text(
                    menu.dayName,
                    style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              ...DummyData.getSortedItems(menu.items).map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "• ${e.name}",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                      InkWell(
                        onTap: () => _toggleLike(menu, e),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Icon(
                            e.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: e.isLiked
                                ? Colors.red
                                : Colors.grey.withOpacity(0.5),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Calorie text removed as per request
            ],
          ),
        );
      },
    );
  }
}
