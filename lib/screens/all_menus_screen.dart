import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/dummy_data.dart';
import '../services/api_service.dart';

class AllMenusScreen extends StatefulWidget {
  const AllMenusScreen({super.key});

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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch Lunch
      try {
        final lunchData = await ApiService.get('/lunch/month');
        if (lunchData != null && lunchData is List) {
          _lunchMenus = lunchData.map((e) => Menu.fromJson(e)).toList();
        }
      } catch (e) {
        print('Error fetching lunch monthly: $e');
      }

      // Fetch Dinner
      try {
        final dinnerData = await ApiService.get('/dinner/month');
        if (dinnerData != null && dinnerData is List) {
          _dinnerMenus = dinnerData.map((e) => Menu.fromJson(e)).toList();
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
      // Determine which list to update
      List<Menu> targetList = _lunchMenus.contains(menu) ? _lunchMenus : _dinnerMenus;
      if (!targetList.contains(menu)) return; // Should not happen

      // Optimistic Update
      setState(() {
          // Find menu index
          final menuIndex = targetList.indexOf(menu);
          if (menuIndex == -1) return;

          // Find item index
          final itemIndex = menu.items.indexOf(item);
          if (itemIndex == -1) return;

          // Create new MenuItem
          final newItem = MenuItem(
              id: item.id,
              name: item.name,
              category: item.category,
              calories: item.calories,
              isLiked: !item.isLiked,
          );

          // Create new items list
          final newItems = List<MenuItem>.from(menu.items);
          newItems[itemIndex] = newItem;

          // Create new Menu
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

          // Update list
          targetList[menuIndex] = newMenu;
      });

      // API Call
      try {
          if (!item.isLiked) { // Note: item is old state (unliked), so we are Liking it
               await ApiService.post('/favorites', {'dish_id': item.id});
          } else {
               await ApiService.delete('/favorites/${item.id}');
          }
      } catch (e) {
          print('Fav toggle error in AllMenus: $e');
          // Revert on error?
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
                        style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                        ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              ...DummyData.getSortedItems(
                menu.items,
              ).map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                        Expanded(child: Text("• ${e.name}", style: GoogleFonts.inter(fontSize: 14))),
                        InkWell(
                            onTap: () => _toggleLike(menu, e),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                              child: Icon(
                                  e.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: e.isLiked ? Colors.red : Colors.grey.withOpacity(0.5),
                                  size: 18,
                              ),
                            ),
                        ),
                    ],
                  ),
              )),
              const SizedBox(height: 8),
              Text(
                  'Kalori: ${menu.totalCalories} kcal',
                   style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              )
            ],
          ),
        );
      },
    );
  }
}
