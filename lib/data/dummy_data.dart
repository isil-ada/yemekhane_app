class MenuItem {
  final String id;
  final String name;
  final String category;
  final int calories;
  final bool isLiked;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    this.calories = 0,
    this.isLiked = false,
  });
}

class Menu {
  final String date;
  final String dayName;
  final List<MenuItem> items;
  final int totalCalories;

  const Menu({
    required this.date,
    required this.dayName,
    required this.items,
    required this.totalCalories,
  });
}

class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String timeAgo;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timeAgo,
  });
}

class DummyData {
  static const List<Menu> lunchMenus = [
    Menu(
      date: '14 Ekim 2023',
      dayName: 'Çarşamba',
      totalCalories: 450,
      items: [
        MenuItem(
          id: '1',
          name: 'Izgara Tavuk',
          category: 'Ana Yemek',
          calories: 200,
        ),
        MenuItem(
          id: '2',
          name: 'Pirinç Pilavı',
          category: 'Yardımcı Yemek',
          calories: 150,
        ),
        MenuItem(
          id: '3',
          name: 'Mercimek Çorbası',
          category: 'Başlangıç',
          calories: 80,
        ),
        MenuItem(
          id: '4',
          name: 'Mevsim Salatası',
          category: 'Salata',
          calories: 20,
        ),
      ],
    ),
    Menu(
      date: '15 Ekim 2023',
      dayName: 'Perşembe',
      totalCalories: 420,
      items: [
        MenuItem(
          id: '5',
          name: 'Sebzeli Köfte',
          category: 'Ana Yemek',
          calories: 220,
        ),
        MenuItem(
          id: '6',
          name: 'Bulgur Pilavı',
          category: 'Yardımcı Yemek',
          calories: 140,
        ),
        MenuItem(id: '7', name: 'Cacık', category: 'Salata', calories: 60),
        MenuItem(
          id: '8',
          name: 'İrmik Helvası',
          category: 'Tatlı',
          calories: 0,
        ), // Calories not shown in UI sometimes
      ],
    ),
    Menu(
      date: '16 Ekim 2023',
      dayName: 'Cuma',
      totalCalories: 580,
      items: [
        MenuItem(
          id: '9',
          name: 'Kremalı Mantar',
          category: 'Başlangıç',
          calories: 100,
        ),
        MenuItem(
          id: '10',
          name: 'Domates Soslu Makarna',
          category: 'Ana Yemek',
          calories: 300,
        ),
        MenuItem(id: '11', name: 'Yoğurt', category: 'Yan Ürün', calories: 100),
        MenuItem(id: '12', name: 'Meyve', category: 'Tatlı', calories: 80),
      ],
    ),
    Menu(
      date: '17 Ekim 2023',
      dayName: 'Cumartesi',
      totalCalories: 600,
      items: [
        MenuItem(
          id: '13',
          name: 'Ezogelin Çorbası',
          category: 'Başlangıç',
          calories: 90,
        ),
        MenuItem(
          id: '14',
          name: 'Karnıyarık',
          category: 'Ana Yemek',
          calories: 250,
        ),
        MenuItem(
          id: '15',
          name: 'Pirinç Pilavı',
          category: 'Yardımcı Yemek',
          calories: 150,
        ),
        MenuItem(id: '16', name: 'Cacık', category: 'Salata', calories: 50),
      ],
    ),
    Menu(
      date: '18 Ekim 2023',
      dayName: 'Pazar',
      totalCalories: 550,
      items: [
        MenuItem(
          id: '17',
          name: 'Yayla Çorbası',
          category: 'Başlangıç',
          calories: 85,
        ),
        MenuItem(
          id: '18',
          name: 'Tavuk Sote',
          category: 'Ana Yemek',
          calories: 220,
        ),
        MenuItem(
          id: '19',
          name: 'Bulgur Pilavı',
          category: 'Yardımcı Yemek',
          calories: 140,
        ),
        MenuItem(id: '20', name: 'Revani', category: 'Tatlı', calories: 100),
      ],
    ),
    Menu(
      date: '19 Ekim 2023',
      dayName: 'Pazartesi',
      totalCalories: 500,
      items: [
        MenuItem(
          id: '21',
          name: 'Domates Çorbası',
          category: 'Başlangıç',
          calories: 70,
        ),
        MenuItem(
          id: '22',
          name: 'Etli Nohut',
          category: 'Ana Yemek',
          calories: 280,
        ),
        MenuItem(
          id: '23',
          name: 'Pirinç Pilavı',
          category: 'Yardımcı Yemek',
          calories: 150,
        ),
        MenuItem(id: '24', name: 'Turşu', category: 'Salata', calories: 10),
      ],
    ),
  ];

  static const List<Review> reviews = [
    Review(
      id: 'r1',
      userName: 'Ali K.',
      rating: 5,
      comment:
          'Çok lezzetliydi, özellikle tavuk tam kıvamında pişmişti. Tavsiye ederim.',
      timeAgo: '2 saat önce',
    ),
    Review(
      id: 'r2',
      userName: 'Ayşe M.',
      rating: 3,
      comment: 'Biraz kuruydu ama idare eder. Çorba güzeldi.',
      timeAgo: '5 saat önce',
    ),
  ];

  static List<MenuItem> getSortedItems(List<MenuItem> items) {
    // Order: Çorba (Başlangıç) -> Ana Yemek -> Yardımcı Yemek -> Others
    int getWeight(String category) {
      if (category.contains('Başlangıç') || category.contains('Çorba'))
        return 1;
      if (category.contains('Ana Yemek')) return 2;
      if (category.contains('Yardımcı')) return 3;
      return 4; // Tatlı, Salata, etc.
    }

    final sorted = List<MenuItem>.from(items);
    sorted.sort(
      (a, b) => getWeight(a.category).compareTo(getWeight(b.category)),
    );
    return sorted;
  }
}
