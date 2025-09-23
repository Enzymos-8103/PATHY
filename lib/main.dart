import 'package:flutter/material.dart';
// import 'map_page.dart'; // Uncomment when you have the map page

void main() {
  runApp(const TripsApp());
}

class TripsApp extends StatelessWidget {
  const TripsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PATHY',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ).copyWith(
          primary: Colors.green[700],
          secondary: Colors.teal[400],
        ),
      ),
      home: const TripsPage(),
    );
  }
}

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> with TickerProviderStateMixin {
  String selectedCategory = "הכל";
  String selectedRegion = "הכל";
  late AnimationController _animationController;

  // 🌟 Enhanced categories with beautiful gradient colors and custom icons
  final List<Map<String, dynamic>> categories = [
    {
      "name": "הכל",
      "icon": Icons.explore,
      "gradientColors": [Colors.teal[400]!, Colors.cyan[300]!],
      "shadowColor": Colors.teal[200]!
    },
    {
      "name": "טיול משפחתי",
      "icon": Icons.family_restroom,
      "gradientColors": [Colors.orange[400]!, Colors.amber[300]!],
      "shadowColor": Colors.orange[200]!
    },
    {
      "name": "הרפתקה",
      "icon": Icons.terrain,
      "gradientColors": [Colors.green[500]!, Colors.lightGreen[400]!],
      "shadowColor": Colors.green[200]!
    },
    {
      "name": "רומנטי",
      "icon": Icons.favorite,
      "gradientColors": [Colors.pink[400]!, Colors.pinkAccent[200]!],
      "shadowColor": Colors.pink[200]!
    },
    {
      "name": "תרבותי",
      "icon": Icons.account_balance,
      "gradientColors": [Colors.indigo[500]!, Colors.purple[400]!],
      "shadowColor": Colors.indigo[200]!
    },
    {
      "name": "יוקרה",
      "icon": Icons.diamond,
      "gradientColors": [Colors.amber[600]!, Colors.yellow[400]!],
      "shadowColor": Colors.amber[200]!
    },
  ];

  // 🌟 Enhanced filters with better icons and colors
  final Map<String, Map<String, dynamic>> filters = {
    "אזור": {
      "icon": Icons.location_on,
      "gradientColors": [Colors.blue[500]!, Colors.lightBlue[400]!],
      "shadowColor": Colors.blue[200]!
    },
    "כולל מנגל": {
      "icon": Icons.outdoor_grill,
      "gradientColors": [Colors.deepOrange[500]!, Colors.orange[400]!],
      "shadowColor": Colors.deepOrange[200]!
    },
    "חניה": {
      "icon": Icons.local_parking,
      "gradientColors": [Colors.indigo[500]!, Colors.blue[400]!],
      "shadowColor": Colors.indigo[200]!
    },
    "שירותים": {
      "icon": Icons.wc,
      "gradientColors": [Colors.brown[500]!, Colors.brown[400]!],
      "shadowColor": Colors.brown[200]!
    },
    "מים לשתייה": {
      "icon": Icons.water_drop,
      "gradientColors": [Colors.cyan[500]!, Colors.lightBlue[400]!],
      "shadowColor": Colors.cyan[200]!
    },
    "צל": {
      "icon": Icons.forest,
      "gradientColors": [Colors.green[600]!, Colors.lightGreen[500]!],
      "shadowColor": Colors.green[200]!
    },
    "מדורה": {
      "icon": Icons.local_fire_department,
      "gradientColors": [Colors.red[500]!, Colors.orange[400]!],
      "shadowColor": Colors.red[200]!
    },
    "נגישות לנכים": {
      "icon": Icons.accessible,
      "gradientColors": [Colors.purple[500]!, Colors.deepPurple[400]!],
      "shadowColor": Colors.purple[200]!
    },
    "מסעדות קרובות": {
      "icon": Icons.restaurant_menu,
      "gradientColors": [Colors.teal[500]!, Colors.cyan[400]!],
      "shadowColor": Colors.teal[200]!
    },
  };

  final Map<String, bool> selectedFilters = {};
  final List<String> regions = ["צפון", "מרכז", "דרום", "ירושלים"];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    for (var key in filters.keys) {
      selectedFilters[key] = false;
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeFilters = <String>[];
    selectedFilters.forEach((key, value) {
      if (value) {
        if (key == "אזור") {
          activeFilters.add("אזור: $selectedRegion");
        } else {
          activeFilters.add(key);
        }
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green[50]!,
              Colors.white,
              Colors.green[50]!,
            ],
          ),
        ),
        child: Column(
          children: [
            // 🎨 Enhanced App Bar with gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[700]!, Colors.teal[500]!],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[300]!.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // 🌍 Enhanced Search Nearby button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.lightBlue[400]!, Colors.blue[500]!],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[200]!.withOpacity(0.6),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.travel_explore,
                              color: Colors.white, size: 28),
                          tooltip: "Search Nearby",
                          onPressed: () {
                            // Navigate to map page when available
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (_) => const MapPage()),
                            // );
                          },
                        ),
                      ),
                    ),
                    // 🏷️ Enhanced App Title
                    Expanded(
                      child: Center(
                        child: Text(
                          "PATHY",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 3,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 64), // Balance the layout
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🌟 Enhanced Categories with beautiful animations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "בחר סוג טיול",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.center,
                        children: categories.asMap().entries.map((entry) {
                          final index = entry.key;
                          final cat = entry.value;
                          final isSelected = cat["name"] == selectedCategory;

                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            curve: Curves.elasticOut,
                            transform: Matrix4.identity()
                              ..scale(_animationController.value),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = cat["name"];
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: isSelected
                                          ? LinearGradient(
                                        colors: cat["gradientColors"],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                          : LinearGradient(
                                        colors: [
                                          Colors.grey[200]!,
                                          Colors.grey[100]!
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isSelected
                                              ? cat["shadowColor"].withOpacity(0.6)
                                              : Colors.grey[300]!.withOpacity(0.5),
                                          blurRadius: isSelected ? 15 : 8,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      cat["icon"],
                                      size: 40,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cat["name"],
                                    style: TextStyle(
                                      color: isSelected
                                          ? cat["gradientColors"][0]
                                          : Colors.grey[700],
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🟢 Enhanced Body content
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "בחר סינונים כדי להתחיל",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "גלה את המקומות הכי יפים בישראל",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🟢 Enhanced Active filter chips
            if (activeFilters.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      "פילטרים פעילים:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: activeFilters.map((f) {
                        final filterMeta = f.startsWith("אזור")
                            ? filters["אזור"]
                            : filters[f];
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: filterMeta?["gradientColors"] ??
                                  [Colors.green[300]!, Colors.green[400]!],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: (filterMeta?["shadowColor"] ??
                                    Colors.green[200]!)
                                    .withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Chip(
                            avatar: Icon(
                              filterMeta?["icon"],
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              f,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            deleteIcon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
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
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

            // 🔘 Enhanced Filter button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[400]!, Colors.teal[400]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green[300]!.withOpacity(0.6),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.tune, color: Colors.white, size: 24),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    _showFilterDialog(context);
                  },
                  label: const Text(
                    "סינון מתקדם",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ⚙️ Enhanced Filter dialog
  void _showFilterDialog(BuildContext context) {
    final tempFilters = Map<String, bool>.from(selectedFilters);
    String tempRegion = selectedRegion;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.filter_alt, color: Colors.green[600]),
                  const SizedBox(width: 8),
                  const Text(
                    "בחר אפשרויות סינון",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: filters.entries.map((entry) {
                      final filter = entry.key;
                      final icon = entry.value["icon"] as IconData;
                      final gradientColors =
                      entry.value["gradientColors"] as List<Color>;
                      final isSelected = tempFilters[filter] ?? false;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: isSelected
                              ? LinearGradient(
                            colors: [
                              gradientColors[0].withOpacity(0.1),
                              gradientColors[1].withOpacity(0.1),
                            ],
                          )
                              : null,
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (val) {
                            setStateDialog(() {
                              if (filter == "אזור" && val == true) {
                                _showRegionDialog(context, (region) {
                                  tempRegion = region;
                                  tempFilters["אזור"] = true;
                                });
                              } else {
                                tempFilters[filter] = val ?? false;
                              }
                            });
                          },
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: gradientColors),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: Colors.white, size: 20),
                          ),
                          title: Text(
                            filter,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          activeColor: gradientColors[0],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("ביטול", style: TextStyle(color: Colors.grey[600])),
                ),
                TextButton(
                  onPressed: () {
                    setStateDialog(() {
                      for (var key in tempFilters.keys) {
                        tempFilters[key] = false;
                      }
                      tempRegion = "הכל";
                    });
                  },
                  child: Text("נקה הכל", style: TextStyle(color: Colors.red[600])),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[400]!, Colors.teal[400]!],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFilters
                          ..clear()
                          ..addAll(tempFilters);
                        selectedRegion = tempRegion;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "אישור",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ⚙️ Enhanced Region selection dialog
  void _showRegionDialog(
      BuildContext context, Function(String) onRegionSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text(
                "בחר אזור",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: regions.map((region) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.lightBlue[50]!],
                  ),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.lightBlue[300]!],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.map, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    region,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    onRegionSelected(region);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}