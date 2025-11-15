import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pathy/Views/SearchScreen.dart';
import 'package:pathy/Views/search/area_search_button.dart';
import 'DestinationDetailsScreen.dart';
import 'AuthScreen.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _showBottomButtons = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;
  String _userName = '';

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

  final List<Map<String, dynamic>> allDestinations = [];

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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (!_showBottomButtons) {
          setState(() => _showBottomButtons = true);
        }
      } else {
        if (_showBottomButtons) {
          setState(() => _showBottomButtons = false);
        }
      }
    });

    _checkConnectionOnInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _auth.authStateChanges().listen((User? user) async {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });

        if (user != null) {
          // Fetch user name from Firestore
          try {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            if (userDoc.exists && mounted) {
              setState(() {
                _userName = userDoc['name'] ?? user.displayName ?? 'משתמש';
              });
            }
          } catch (e) {
            setState(() {
              _userName = user.displayName ?? 'משתמש';
            });
          }
        }
      }
    });
  }

  Future<void> _checkConnectionOnInit() async {
    await checkConnection();
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
                          Icons.terrain,
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
              controller: _scrollController,
              child: Column(
                children: [
                  _buildAppBar(gradientColors, appBarColors, accentColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildCategoriesSection(gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 25),  // <-- CHANGED from 40 to 25
                  _buildSearchButton(gradientColors, shadowColor),  // <-- ADD THIS NEW LINE
                  const SizedBox(height: 25),  // <-- ADD THIS NEW LINE
                  _buildDestinationsGrid(gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  if (activeFilters.isNotEmpty)
                    _buildActiveFilters(
                      activeFilters,
                      gradientColors,
                      cardColor,
                      shadowColor,
                    ),
                  const SizedBox(height: 40),
                  _buildFilterButton(gradientColors, shadowColor, accentColor),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            if (_showBottomButtons)
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_showBottomButtons,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: _showBottomButtons ? 1.0 : 0.0,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child:FloatingActionButton(
                            heroTag: "pointsButton",
                            backgroundColor: gradientColors[1],
                            child: const Icon(Icons.emoji_events, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  title: const Text(
                                    "דירוג המטיילים ותוכנית הנקודות של PATHY",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: const [
                                        SizedBox(height: 8),
                                        Text(
                                          "צאו לטייל, שתפו חוויות ודרגו מסלולים – וכל פעולה שלכם מזכה אתכם בנקודות ומקדמת אתכם בדרגות המטיילים של PATHY.",
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 16),
                                        Divider(),
                                        Text(
                                          "איך צוברים נקודות:",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          "• דירוג טיול שביצעתם – 1 נקודה\n"
                                              "• פרסום תמונה או חוות דעת – 5 נקודות\n"
                                              "• הצעת מסלול חדש – 15 נקודות\n"
                                              "• הזמנת חבר שמצטרף – 30 נקודות\n",
                                          textAlign: TextAlign.right,
                                        ),
                                        Divider(),
                                        SizedBox(height: 8),
                                        Text(
                                          "דרגות המטיילים:",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 8),
                                        ListTile(
                                          leading: Icon(Icons.landscape, color: Colors.brown),
                                          title: Text("מטייל חדש", textAlign: TextAlign.right),
                                          subtitle: Text("0–100 נקודות", textAlign: TextAlign.right),
                                          trailing: Icon(Icons.star_border, color: Colors.brown),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.hiking, color: Colors.grey),
                                          title: Text("מטייל פעיל", textAlign: TextAlign.right),
                                          subtitle: Text("101–300 נקודות", textAlign: TextAlign.right),
                                          trailing: Icon(Icons.star_half, color: Colors.grey),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.terrain, color: Colors.amber),
                                          title: Text("מגלה ארצות", textAlign: TextAlign.right),
                                          subtitle: Text("301–600 נקודות", textAlign: TextAlign.right),
                                          trailing: Icon(Icons.star, color: Colors.amber),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.explore, color: Colors.blueAccent),
                                          title: Text("מטייל בכיר", textAlign: TextAlign.right),
                                          subtitle: Text("601–1000 נקודות", textAlign: TextAlign.right),
                                          trailing: Icon(Icons.diamond, color: Colors.blueAccent),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.public, color: Colors.deepPurple),
                                          title: Text("שגריר PATHY", textAlign: TextAlign.right),
                                          subtitle: Text("1001 נקודות ומעלה", textAlign: TextAlign.right),
                                          trailing: Icon(Icons.workspace_premium, color: Colors.deepPurple),
                                        ),
                                        Divider(),
                                        SizedBox(height: 8),
                                        Text(
                                          "הנקודות ניתנות למימוש כהנחות, הטבות ותגי הישגים אישיים.\n"
                                              "הדירוג שלכם מוצג בטבלת המטיילים העולמית של PATHY, המתעדכנת מדי שבוע.",
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "צאו לגלות, לשתף ולהתקדם – העולם מחכה לכם.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("סגור"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAuthCircle(List<Color> gradientColors, Color shadowColor) {
    return GestureDetector(
      onTap: () {
        if (_currentUser == null) {
          // Navigate to auth page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AuthPage()),
          );
        } else {
          // Show user menu
          _showUserMenu();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _currentUser != null
                ? [Colors.green.shade400, Colors.green.shade600]
                : [gradientColors[0], gradientColors[1]],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          children: [
            // Circle Avatar
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  _currentUser != null ? '👤' : '🔐',
                  style: const TextStyle(fontSize: 35),
                ),
              ),
            ),
            const SizedBox(width: 20),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUser != null ? 'מחובר ✓' : 'התחבר / הירשם',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _currentUser != null
                        ? 'שלום, $_userName! 👋'
                        : 'גלה את כל האפשרויות',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              _currentUser != null ? Icons.menu : Icons.arrow_forward,
              color: Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  void _showUserMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            // User Info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                    ),
                  ),
                  child: const Center(
                    child: Text('👤', style: TextStyle(fontSize: 30)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _currentUser?.email ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            // Menu Options
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF00796B)),
              title: const Text('הפרופיל שלי'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('פרופיל - בקרוב')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF00796B)),
              title: const Text('הגדרות'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('הגדרות - בקרוב')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('התנתק'),
              onTap: () async {
                await _auth.signOut();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('התנתקת בהצלחה')),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
  Widget _buildAppBar(
      List<Color> gradientColors,
      List<Color> appBarColors,
      Color accentColor,
      Color shadowColor,
      ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [...appBarColors, accentColor.withOpacity(0.3)],
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_currentUser == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  } else {
                    _showUserMenu();
                  }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: _currentUser != null
                          ? [Colors.green.shade300, Colors.green.shade500]
                          : [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _currentUser != null
                        ? Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : '👤',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const Icon(Icons.person_outline, color: Colors.white, size: 26),
                  ),
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
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        "גלה את ישראל",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
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
  } // <-- _buildAppBar ENDS HERE

// NOW ADD _buildSearchButton as a SEPARATE method:
  Widget _buildSearchButton(List<Color> gradientColors, Color shadowColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.85)],
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradientColors),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                "חפש יעד, אזור או קטגוריה...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Icon(Icons.arrow_forward, color: gradientColors[0]),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(

      List<Color> gradientColors, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.explore, color: gradientColors[0], size: 24),
              const SizedBox(width: 8),
              Text(
                "בחר את סוג הטיול שלך",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: gradientColors[0],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 15,
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
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [catColors[1], catColors[0]],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: catShadow.withOpacity(0.6),
                            blurRadius: isSelected ? 20 : 12,
                            offset: const Offset(0, 6),
                          ),
                          if (isSelected)
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            ),
                        ],
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                      child:
                      Icon(cat["icon"], size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(colors: catColors)
                            : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cat["name"],
                        style: TextStyle(
                          fontSize: 12,
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
          SizedBox(
            height: 400,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('destinations')
                  .orderBy('rating', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No destinations found.'));
                }
                final destinations = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final data =
                    destinations[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(data['imageUrl'] ?? ''),
                      ),
                      title: Text(data['name'] ?? 'No name'),
                      subtitle: Text(data['location'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${data['rating'] ?? ''}'),
                        ],
                      ),
                      onTap: () {
                        _showDestinationDetails(context, data);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDestinationDetails(
      BuildContext context, Map<String, dynamic> destination) {
    final currentCategory = currentCategoryData;
    final List<Color> gradientColors =
    List<Color>.from(currentCategory["gradientColors"]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailsPage(
          destination: destination,
          gradientColors: gradientColors,
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
          ).toList(),
        ),
      ),
    );
  }
}