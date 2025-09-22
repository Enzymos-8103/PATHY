import 'package:flutter/material.dart';

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
        fontFamily: 'Arial',
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

class _TripsPageState extends State<TripsPage> {
  String selectedCategory = "הכל";
  String selectedRegion = "הכל";

  final List<Map<String, dynamic>> categories = [
    {"name": "הכל", "icon": Icons.all_inclusive},
    {"name": "טיול משפחתי", "icon": Icons.family_restroom},
    {"name": "הרפתקה", "icon": Icons.hiking},
    {"name": "רומנטי", "icon": Icons.favorite},
    {"name": "תרבותי", "icon": Icons.museum},
    {"name": "יוקרה", "icon": Icons.star},
  ];

  final Map<String, IconData> filters = {
    "אזור": Icons.map,
    "כולל מנגל": Icons.outdoor_grill,
    "חניה": Icons.local_parking,
    "שירותים": Icons.wc,
    "מים לשתייה": Icons.local_drink,
    "צל": Icons.nature,
    "מדורה": Icons.fireplace,
    "נגישות לנכים": Icons.accessible,
    "מסעדות קרובות": Icons.restaurant,
  };

  final Map<String, bool> selectedFilters = {};
  final List<String> regions = ["צפון", "מרכז", "דרום", "ירושלים"];

  @override
  void initState() {
    super.initState();
    for (var key in filters.keys) {
      selectedFilters[key] = false;
    }
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
      appBar: AppBar(
        title: const Text("PATHY - טיולים בישראל"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔵 קטגוריות
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = cat["name"] == selectedCategory;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = cat["name"];
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                        isSelected ? Colors.greenAccent : Colors.grey[200],
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        cat["icon"],
                        size: 35,
                        color: isSelected ? Colors.black : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(cat["name"]),
                  ],
                ),
              );
            }).toList(),
          ),

          // 🟢 תוכן
          const Expanded(
            child: Center(
              child: Text(
                "בחר סינונים כדי להתחיל",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),

          // 🟢 צ'יפים באמצע־תחתון
          if (activeFilters.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: activeFilters.map((f) {
                  IconData? icon =
                  f.startsWith("אזור") ? Icons.map : filters[f];
                  return Chip(
                    avatar: Icon(icon, size: 18, color: Colors.black54),
                    label: Text(f),
                    backgroundColor: Colors.lightGreen[200],
                    deleteIcon: const Icon(Icons.close, size: 18),
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
            ),

          // 🔘 כפתור סינון
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                _showFilterDialog(context);
              },
              label: const Text("סינון"),
            ),
          ),
        ],
      ),
    );
  }

  // ⚙️ חלון סינון – ריבוי בחירה עם עותק זמני
  void _showFilterDialog(BuildContext context) {
    final tempFilters = Map<String, bool>.from(selectedFilters);
    String tempRegion = selectedRegion;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("בחר אפשרויות סינון"),
              content: SingleChildScrollView(
                child: Column(
                  children: filters.entries.map((entry) {
                    final filter = entry.key;
                    final icon = entry.value;
                    final isSelected = tempFilters[filter] ?? false;
                    return CheckboxListTile(
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
                      secondary: Icon(icon, color: Colors.green),
                      title: Text(filter),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // ❌ ביטול – לא משנה כלום
                  },
                  child: const Text("ביטול"),
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
                    Navigator.pop(context); // ✅ אישור – שומר
                  },
                  child: const Text("אישור"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ⚙️ חלון בחירת אזור
  void _showRegionDialog(
      BuildContext context, Function(String) onRegionSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("בחר אזור"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: regions.map((region) {
              return ListTile(
                leading: const Icon(Icons.map, color: Colors.blue),
                title: Text(region),
                onTap: () {
                  onRegionSelected(region); // עידכון זמני
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
