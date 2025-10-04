import 'dart:io';
import 'package:flutter/material.dart';

// Assuming Utils class exists in your project
// import '../Models/utils.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with TickerProviderStateMixin {
  String selectedCategory = "הכל";
  String selectedRegion = "הכל";
  late AnimationController _animationController;
  late AnimationController _floatingController;
  int displayedDestinations = 15;

  Future<void> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        debugPrint('Connected to internet');
      }
    } on SocketException catch (_) {
      debugPrint('Not connected to internet');
      if (mounted) {
        _showNoInternetDialog();
      }
    }
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("אין אינטרנט"),
        content: const Text("האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("אישור"),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> categories = [
    {
      "name": "הכל",
      "icon": Icons.explore,
      "gradientColors": [const Color(0xFF26A69A), const Color(0xFF4DD0E1)],
      "shadowColor": const Color(0xFF80CBC4),
      "backgroundColors": [
        const Color(0xFF004D40),
        const Color(0xFF00695C),
        const Color(0xFF00897B),
        const Color(0xFF26A69A)
      ],
      "appBarColors": [const Color(0xFF00796B), const Color(0xFF0097A7)],
      "accentColor": const Color(0xFF80CBC4),
      "cardColor": const Color(0xFFE0F2F1)
    },
    {
      "name": "טיול משפחתי",
      "icon": Icons.family_restroom,
      "gradientColors": [const Color(0xFFFF9800), const Color(0xFFFFB74D)],
      "shadowColor": const Color(0xFFFFCC02),
      "backgroundColors": [
        const Color(0xFFBF360C),
        const Color(0xFFD84315),
        const Color(0xFFFF5722),
        const Color(0xFFFF8A65)
      ],
      "appBarColors": [const Color(0xFFF57C00), const Color(0xFFFFB300)],
      "accentColor": const Color(0xFFFFCC02),
      "cardColor": const Color(0xFFFFF3E0)
    },
    {
      "name": "הרפתקה",
      "icon": Icons.terrain,
      "gradientColors": [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
      "shadowColor": const Color(0xFFA5D6A7),
      "backgroundColors": [
        const Color(0xFF1B5E20),
        const Color(0xFF2E7D32),
        const Color(0xFF388E3C),
        const Color(0xFF66BB6A)
      ],
      "appBarColors": [const Color(0xFF388E3C), const Color(0xFF689F38)],
      "accentColor": const Color(0xFFA5D6A7),
      "cardColor": const Color(0xFFE8F5E8)
    },
    {
      "name": "רומנטי",
      "icon": Icons.favorite,
      "gradientColors": [const Color(0xFFE91E63), const Color(0xFFFF4081)],
      "shadowColor": const Color(0xFFF8BBD9),
      "backgroundColors": [
        const Color(0xFF880E4F),
        const Color(0xFFC2185B),
        const Color(0xFFE91E63),
        const Color(0xFFF48FB1)
      ],
      "appBarColors": [const Color(0xFFC2185B), const Color(0xFFE91E63)],
      "accentColor": const Color(0xFFF8BBD9),
      "cardColor": const Color(0xFFFCE4EC)
    },
    {
      "name": "תרבותי",
      "icon": Icons.account_balance,
      "gradientColors": [const Color(0xFF3F51B5), const Color(0xFF9C27B0)],
      "shadowColor": const Color(0xFFC5CAE9),
      "backgroundColors": [
        const Color(0xFF1A237E),
        const Color(0xFF303F9F),
        const Color(0xFF3F51B5),
        const Color(0xFF7986CB)
      ],
      "appBarColors": [const Color(0xFF303F9F), const Color(0xFF7B1FA2)],
      "accentColor": const Color(0xFFC5CAE9),
      "cardColor": const Color(0xFFE8EAF6)
    },
    {
      "name": "יוקרה",
      "icon": Icons.workspace_premium,
      "gradientColors": [const Color(0xFFFF8F00), const Color(0xFFFFD54F)],
      "shadowColor": const Color(0xFFFFE082),
      "backgroundColors": [
        const Color(0xFFE65100),
        const Color(0xFFF57C00),
        const Color(0xFFFF8F00),
        const Color(0xFFFFB74D)
      ],
      "appBarColors": [const Color(0xFFFF6F00), const Color(0xFFFFC107)],
      "accentColor": const Color(0xFFFFE082),
      "cardColor": const Color(0xFFFFF8E1)
    },
  ];

  final List<Map<String, dynamic>> allDestinations = [
    {
      "name": "ים המלח",
      "location": "דרום",
      "imageUrl": "https://images.pexels.com/photos/3244513/pexels-photo-3244513.jpeg",
      "rating": 4.9,
      "description": "ים המלח הוא אחד המקומות המיוחדים בעולם. הוא נמצא בנקודה הנמוכה ביותר על פני כדור הארץ, כ-430 מטרים מתחת לפני הים. המים במלוחים ביותר בעולם ומאפשרים ציפה ייחודית."
    },
    {
      "name": "עין גדי",
      "location": "דרום",
      "imageUrl": "https://images.pexels.com/photos/326311/pexels-photo-326311.jpeg",
      "rating": 4.8,
      "description": "שמורת טבע עין גדי מציעה נחלים, מפלים ונוף מדברי עוצר נשימה. מקום מושלם לטיולים ורחצה במים קרירים."
    },
    {
      "name": "הכותל המערבי",
      "location": "ירושלים",
      "imageUrl": "https://images.pexels.com/photos/572313/pexels-photo-572313.jpeg",
      "rating": 5.0,
      "description": "הכותל המערבי הוא אחד..."
    },
    {
      "name": "תל אביב",
      "location": "מרכז",
      "imageUrl": "https://images.pexels.com/photos/2193300/pexels-photo-2193300.jpeg",
      "rating": 4.7,
      "description": "עיר תוססת עם חופים יפים..."
    },
    {
      "name": "חיפה",
      "location": "צפון",
      "imageUrl": "https://images.pexels.com/photos/587115/pexels-photo-587115.jpeg",
      "rating": 4.6,
      "description": "עיר נמל ציורית עם גנים הבהאיים..."
    },
    {
      "name": "אילת",
      "location": "דרום",
      "imageUrl": "https://images.pexels.com/photos/21014/pexels-photo.jpg",
      "rating": 4.8,
      "description": "עיר נופש באזור הדרומי ביותר..."
    },
    {
      "name": "מצדה",
      "location": "דרום",
      "imageUrl": "https://images.pexels.com/photos/301428/pexels-photo-301428.jpeg",
      "rating": 4.9,
      "description": "אתר ארכיאולוגי מרשים..."
    },
    {
      "name": "הגליל",
      "location": "צפון",
      "imageUrl": "https://images.pexels.com/photos/462118/pexels-photo-462118.jpeg",
      "rating": 4.7,
      "description": "אזור הררי ירוק עם כפרים ציוריים..."
    },
    {
      "name": "כנרת",
      "location": "צפון",
      "imageUrl": "https://images.pexels.com/photos/338515/pexels-photo-338515.jpeg",
      "rating": 4.8,
      "description": "ים המים היפה בישראל..."
    },
    {
      "name": "גן הבהאים",
      "location": "חיפה",
      "imageUrl": "https://images.pexels.com/photos/346429/pexels-photo-346429.jpeg",
      "rating": 4.9,
      "description": "גנים מדהימים עם טרסות..."
    },
    {
      "name": "העיר העתיקה",
      "location": "ירושלים",
      "imageUrl": "https://images.pexels.com/photos/253828/pexels-photo-253828.jpeg",
      "rating": 5.0,
      "description": "העיר העתיקה של ירושלים היא מקום מרתק..."
    },
    {
      "name": "ראש הנקרה",
      "location": "צפון",
      "imageUrl": "https://images.pexels.com/photos/268431/pexels-photo-268431.jpeg",
      "rating": 4.7,
      "description": "מערות מרהיבות בצוק הים..."
    },
    {
      "name": "קיסריה",
      "location": "מרכז",
      "imageUrl": "https://images.pexels.com/photos/21014/pexels-photo-21014.jpeg",
      "rating": 4.6,
      "description": "עיר עתיקה עם שרידים רומיים מרשימים..."
    },
    {
      "name": "מצפה רמון",
      "location": "דרום",
      "imageUrl": "https://images.pexels.com/photos/65945/pexels-photo-65945.jpeg",
      "rating": 4.9,
      "description": "מכתש ענק ומדהים במדבר הנגב..."
    },
    {
      "name": "טבריה",
      "location": "צפון",
      "imageUrl": "https://images.pexels.com/photos/57481/pexels-photo-57481.jpeg",
      "rating": 4.5,
      "description": "עיר עתיקה על שפת הכנרת..."
    },
  ];

  final Map<String, Map<String, dynamic>> filters = {
    "אזור": {
      "icon": Icons.location_on,
      "gradientColors": [const Color(0xFF2196F3), const Color(0xFF03A9F4)],
      "shadowColor": const Color(0xFF90CAF9)
    },
    "כולל מנגל": {
      "icon": Icons.outdoor_grill,
      "gradientColors": [const Color(0xFFFF5722), const Color(0xFFFF9800)],
      "shadowColor": const Color(0xFFFFAB91)
    },
    "חניה": {
      "icon": Icons.local_parking,
      "gradientColors": [const Color(0xFF3F51B5), const Color(0xFF2196F3)],
      "shadowColor": const Color(0xFFC5CAE9)
    },
    "שירותים": {
      "icon": Icons.wc,
      "gradientColors": [const Color(0xFF795548), const Color(0xFFA1887F)],
      "shadowColor": const Color(0xFFD7CCC8)
    },
    "מים לשתייה": {
      "icon": Icons.water_drop,
      "gradientColors": [const Color(0xFF00BCD4), const Color(0xFF03A9F4)],
      "shadowColor": const Color(0xFF80DEEA)
    },
    "צל": {
      "icon": Icons.park,
      "gradientColors": [const Color(0xFF4CAF50), const Color(0xFF8BC34A)],
      "shadowColor": const Color(0xFFA5D6A7)
    },
    "מדורה": {
      "icon": Icons.local_fire_department,
      "gradientColors": [const Color(0xFFF44336), const Color(0xFFFF9800)],
      "shadowColor": const Color(0xFFEF9A9A)
    },
    "נגישות לנכים": {
      "icon": Icons.accessible,
      "gradientColors": [const Color(0xFF9C27B0), const Color(0xFF673AB7)],
      "shadowColor": const Color(0xFFE1BEE7)
    },
    "מסעדות קרובות": {
      "icon": Icons.restaurant_menu,
      "gradientColors": [const Color(0xFF009688), const Color(0xFF00BCD4)],
      "shadowColor": const Color(0xFF80CBC4)
    },
  };

  final Map<String, bool> selectedFilters = {};
  final List<String> regions = ["הכל", "צפון", "מרכז", "דרום", "ירושלים"];

  Map<String, dynamic> get currentCategoryData {
    return categories.firstWhere(
          (cat) => cat["name"] == selectedCategory,
      orElse: () => categories[0],
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    for (var key in filters.keys) {
      selectedFilters[key] = false;
    }
    _animationController.forward();
    _floatingController.repeat(reverse: true);
    _checkConnectionOnInit();
  }

  Future<void> _checkConnectionOnInit() async {
    await checkConnection();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeFilters = <String>[];
    selectedFilters.forEach((key, value) {
      if (value) {
        if (key == "אזור" && selectedRegion != "הכל") {
          activeFilters.add("אזור: $selectedRegion");
        } else if (key != "אזור") {
          activeFilters.add(key);
        }
      }
    });

    final currentCategory = currentCategoryData;
    final List<Color> backgroundColors =
    List<Color>.from(currentCategory["backgroundColors"]);
    final List<Color> appBarColors =
    List<Color>.from(currentCategory["appBarColors"]);
    final List<Color> gradientColors =
    List<Color>.from(currentCategory["gradientColors"]);
    final Color shadowColor = currentCategory["shadowColor"];
    final Color accentColor = currentCategory["accentColor"];
    final Color cardColor = currentCategory["cardColor"];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: backgroundColors,
          ),
        ),
        child: Stack(
          children: [
            ...List.generate(8, (index) {
              return AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Positioned(
                    left: (index * 80.0) % MediaQuery.of(context).size.width,
                    top: 100 +
                        (index * 60.0) % 400 +
                        (_floatingController.value * 30 * (index % 3 + 1)),
                    child: Opacity(
                      opacity: 0.1 + (_floatingController.value * 0.1),
                      child: Icon(
                        [
                          Icons.cloud,
                          Icons.star,
                          Icons.favorite,
                          Icons.nature,
                          Icons.local_florist,
                          Icons.wb_sunny,
                          Icons.waves,
                          Icons.terrain
                        ][index],
                        size: 40 + (index % 3) * 20,
                        color: accentColor,
                      ),
                    ),
                  );
                },
              );
            }),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(gradientColors, appBarColors, accentColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildCategoriesSection(gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildDestinationsGrid(gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  if (activeFilters.isNotEmpty)
                    _buildActiveFilters(
                        activeFilters, gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildFilterButton(gradientColors, shadowColor, accentColor),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(List<Color> gradientColors, List<Color> appBarColors,
      Color accentColor, Color shadowColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [...appBarColors, accentColor.withOpacity(0.3)],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.travel_explore, color: Colors.white, size: 28),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Map feature coming soon!"),
                        backgroundColor: gradientColors[0],
                      ),
                    );
                  },
                ),
              ),
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PATHY",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      Text(
                        "גלה את ישראל",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 56),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
      List<Color> gradientColors, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cardColor.withOpacity(0.9), Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, color: gradientColors[0], size: 28),
              const SizedBox(width: 10),
              Text(
                "בחר את סוג הטיול שלך",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: gradientColors[0],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = cat["name"] == selectedCategory;
              final List<Color> catColors =
              List<Color>.from(cat["gradientColors"]);
              final Color catShadow = cat["shadowColor"];
              return GestureDetector(
                onTap: () => setState(() => selectedCategory = cat["name"]),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [catColors[1], catColors[0]],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: catShadow.withOpacity(0.6),
                            blurRadius: isSelected ? 25 : 15,
                            offset: const Offset(0, 8),
                          ),
                          if (isSelected)
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(0, -3),
                            ),
                        ],
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 4)
                            : null,
                      ),
                      child: Icon(cat["icon"], size: 45, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: catColors)
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        cat["name"],
                        style: TextStyle(
                          color: isSelected ? Colors.white : catColors[0],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsGrid(
      List<Color> gradientColors, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.95), cardColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, color: gradientColors[0], size: 28),
              const SizedBox(width: 10),
              Text(
                "יעדים מומלצים",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: gradientColors[0],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: displayedDestinations.clamp(0, allDestinations.length),
            itemBuilder: (context, index) {
              final destination = allDestinations[index];
              return GestureDetector(
                onTap: () {
                  _showDestinationDetails(context, destination);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          destination['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    gradientColors[0].withOpacity(0.8),
                                    gradientColors[1].withOpacity(0.6),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.image_not_supported,
                                color: Colors.white,
                                size: 50,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [gradientColors[0], gradientColors[1]],
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  destination['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        destination['location'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "${destination['rating']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          if (displayedDestinations < allDestinations.length) ...[
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.expand_more, color: Colors.white, size: 24),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    displayedDestinations =
                        (displayedDestinations + 15).clamp(0, allDestinations.length);
                  });
                },
                label: Text(
                  "ראה עוד (${allDestinations.length - displayedDestinations} נותרו)",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          if (displayedDestinations >= allDestinations.length &&
              displayedDestinations > 15) ...[
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[400]!, Colors.grey[600]!],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.expand_less, color: Colors.white, size: 24),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    displayedDestinations = 15;
                  });
                },
                label: const Text(
                  "הצג פחות",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showDestinationDetails(
      BuildContext context, Map<String, dynamic> destination) {
    final currentCategory = currentCategoryData;
    final List<Color> gradientColors =
    List<Color>.from(currentCategory["gradientColors"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    destination['imageUrl'],
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [gradientColors[0], gradientColors[1]],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name'],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[0],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: gradientColors[0], size: 20),
                        const SizedBox(width: 5),
                        Text(
                          destination['location'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          "${destination['rating']}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Text(
                      "אודות המקום",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[0],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      destination['description'] ??
                          "מקום מדהים לטיול! ${destination['name']} ממוקם ב${destination['location']} ומציע חוויה בלתי נשכחת. אידיאלי למשפחות, זוגות וחובבי טבע.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "מתקנים זמינים",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[0],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildFeatureChip(
                            Icons.local_parking, "חניה", gradientColors[0]),
                        _buildFeatureChip(
                            Icons.restaurant, "מסעדות", gradientColors[0]),
                        _buildFeatureChip(Icons.wc, "שירותים", gradientColors[0]),
                        _buildFeatureChip(
                            Icons.accessible, "נגיש", gradientColors[0]),
                        _buildFeatureChip(
                            Icons.water_drop, "מים", gradientColors[0]),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.directions, color: Colors.white),
                        label: const Text(
                          "קבל הוראות הגעה",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("פותח ניווט ל${destination['name']}"),
                              backgroundColor: gradientColors[0],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  Widget _buildActiveFilters(List<String> activeFilters,
      List<Color> gradientColors, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.9), cardColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "פילטרים פעילים",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: gradientColors[0],
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: activeFilters.map((f) {
              final filterKey = f.startsWith("אזור") ? "אזור" : f;
              final filterMeta = filters[filterKey];
              return Chip(
                avatar: Icon(filterMeta?["icon"], size: 18, color: Colors.white),
                label: Text(f, style: const TextStyle(color: Colors.white)),
                backgroundColor: gradientColors[0],
                deleteIcon: const Icon(Icons.close_rounded, size: 20, color: Colors.white),
                onDeleted: () {
                  setState(() {
                    if (f.startsWith("אזור")) {
                      selectedFilters["אזור"] = false;
                      selectedRegion = "הכל";
                    } else {
                      selectedFilters[f] = false;
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
      List<Color> gradientColors, Color shadowColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [...gradientColors, accentColor]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.6),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.tune, color: Colors.white, size: 24),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () => _showFilterDialog(context),
        label: const Text(
          "סינון מתקדם",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final tempFilters = Map<String, bool>.from(selectedFilters);
    String tempRegion = selectedRegion;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("בחר אפשרויות סינון"),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView(
              children: filters.entries.map((entry) {
                return CheckboxListTile(
                  value: tempFilters[entry.key] ?? false,
                  onChanged: (val) {
                    setStateDialog(() {
                      tempFilters[entry.key] = val ?? false;
                      if (entry.key == "אזור" && val == true) {
                        _showRegionDialog(context, (region) {
                          setStateDialog(() {
                            tempRegion = region;
                            if (region == "הכל") tempFilters["אזור"] = false;
                          });
                        });
                      }
                    });
                  },
                  title: Text(entry.key),
                  secondary: Icon(entry.value["icon"]),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ביטול"),
            ),
            TextButton(
              onPressed: () {
                setStateDialog(() {
                  tempFilters.updateAll((key, value) => false);
                  tempRegion = "הכל";
                });
              },
              child: const Text("נקה הכל"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedFilters
                    ..clear()
                    ..addAll(tempFilters);
                  selectedRegion = tempRegion;
                });
                Navigator.pop(context);
              },
              child: const Text("אישור"),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionDialog(BuildContext context, Function(String) onRegionSelected) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("בחר אזור"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: regions
              .map(
                (region) => ListTile(
              title: Text(region),
              onTap: () {
                onRegionSelected(region);
                Navigator.pop(context);
              },
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
