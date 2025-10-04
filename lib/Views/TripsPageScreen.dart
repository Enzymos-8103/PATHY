import 'dart:io';
import 'package:flutter/material.dart';

import '../Models/utils.dart';




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
        // Connected to internet
        debugPrint('Connected to internet');
      }
    } on SocketException catch (_) {
      // Not connected to internet
      debugPrint('Not connected to internet');
      if (mounted) {
        final utils = Utils();
        utils.showMyDialog2(
            context,
            "אין אינטרנט",
            "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה"
        );
      }
    }
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

  // Real image URLs for Israeli destinations
  final List<Map<String, dynamic>> allDestinations = [
    {
      "name": "ים המלח",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1580237334042-fabc5c3f32f0?w=800",
      "rating": 4.9
    },
    {
      "name": "עין גדי",
      "location": "ים המלח",
      "imageUrl": "https://images.unsplash.com/photo-1613486881163-a7f6b5e4c498?w=800",
      "rating": 4.8
    },
    {
      "name": "הכותל המערבי",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1564868109020-7c2db6901900?w=800",
      "rating": 5.0
    },
    {
      "name": "תל אביב",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?w=800",
      "rating": 4.7
    },
    {
      "name": "חיפה",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1551636898-47668aa61de2?w=800",
      "rating": 4.6
    },
    {
      "name": "אילת",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
      "rating": 4.8
    },
    {
      "name": "מצדה",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1569468859797-0c087b2a8c8f?w=800",
      "rating": 4.9
    },
    {
      "name": "הגליל",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1590759668628-05b0fc34acb7?w=800",
      "rating": 4.7
    },
    {
      "name": "כנרת",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      "rating": 4.8
    },
    {
      "name": "גן הבהאים",
      "location": "חיפה",
      "imageUrl": "https://images.unsplash.com/photo-1587974928442-77dc3e0dba72?w=800",
      "rating": 4.9
    },
    {
      "name": "העיר העתיקה",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 5.0
    },
    {
      "name": "ראש הנקרה",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800",
      "rating": 4.7
    },
    {
      "name": "קיסריה",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1571847028143-c63f0b6a0c8c?w=800",
      "rating": 4.6
    },
    {
      "name": "מצפה רמון",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800",
      "rating": 4.9
    },
    {
      "name": "טבריה",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1558442074-02da9e41b499?w=800",
      "rating": 4.5
    },
    {
      "name": "חוף תל אביב",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=800",
      "rating": 4.8
    },
    {
      "name": "נמל יפו",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800",
      "rating": 4.7
    },
    {
      "name": "הר הזיתים",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?w=800",
      "rating": 4.8
    },
    {
      "name": "בניאס",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.9
    },
    {
      "name": "צפת",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 4.6
    },
    {
      "name": "עכו העתיקה",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1571847028143-c63f0b6a0c8c?w=800",
      "rating": 4.8
    },
    {
      "name": "שוק מחנה יהודה",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.7
    },
    {
      "name": "הר מירון",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל דולב",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "חוף אכזיב",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800",
      "rating": 4.7
    },
    {
      "name": "בית שאן",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1571847028143-c63f0b6a0c8c?w=800",
      "rating": 4.6
    },
    {
      "name": "הר תבור",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      "rating": 4.8
    },
    {
      "name": "חוף דור",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל שניר",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.9
    },
    {
      "name": "פארק הירקון",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "רמת הגולן",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל עמוד",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "חוף הרצליה",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.6
    },
    {
      "name": "מדבר יהודה",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל יהודיה",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.9
    },
    {
      "name": "חוף נתניה",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.5
    },
    {
      "name": "שמורת נחל חרמון",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.8
    },
    {
      "name": "מוזיאון ישראל",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1595433707802-6b2626ef1c91?w=800",
      "rating": 4.9
    },
    {
      "name": "שדרות רוטשילד",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל דוד",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.8
    },
    {
      "name": "חוף פלמחים",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.7
    },
    {
      "name": "נחל תנינים",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "יער ירושלים",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "חוף גורדון",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל קדום",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "שוק הכרמל",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.6
    },
    {
      "name": "גן החיות התנכי",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=800",
      "rating": 4.7
    },
    {
      "name": "נחל זויתן",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "מתחם התחנה",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.6
    },
    {
      "name": "חוף חדרה",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.4
    },
    {
      "name": "נחל חרוד",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "טיילת חיפה",
      "location": "חיפה",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל עובדיה",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "שוק לוינסקי",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.5
    },
    {
      "name": "פארק נאות קדומים",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל משושים",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.8
    },
    {
      "name": "חוף בת ים",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.5
    },
    {
      "name": "נחל איילון",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.4
    },
    {
      "name": "שער יפו",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 4.9
    },
    {
      "name": "נחל צפית",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "שער שכם",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 4.8
    },
    {
      "name": "נחל דישון",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "מרכז עזריאלי",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.5
    },
    {
      "name": "נחל סוכר",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "שוק הפשפשים",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.4
    },
    {
      "name": "נחל חצבני",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.8
    },
    {
      "name": "פארק צ'רלס קלור",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל ערוגות",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "שוק הנמל",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.5
    },
    {
      "name": "נחל פרת",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "כיכר ציון",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.7
    },
    {
      "name": "נחל גילבון",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "נמל חיפה",
      "location": "חיפה",
      "imageUrl": "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל תבור",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "יער בן שמן",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.4
    },
    {
      "name": "פארק הגלבוע",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.8
    },
    {
      "name": "שער האריות",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 4.9
    },
    {
      "name": "נחל קישון",
      "location": "חיפה",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "מבצר עתלית",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1571847028143-c63f0b6a0c8c?w=800",
      "rating": 4.7
    },
    {
      "name": "שדרות ארלוזורוב",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.4
    },
    {
      "name": "נחל כזיב",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "שוני",
      "location": "דרום",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.5
    },
    {
      "name": "נחל אורן",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "כיכר רבין",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800",
      "rating": 4.5
    },
    {
      "name": "נחל עין גב",
      "location": "צפון",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "גן הבירה",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
    },
    {
      "name": "הרובע היהודי",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=800",
      "rating": 4.9
    },
    {
      "name": "שוק בצלאל",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800",
      "rating": 4.6
    },
    {
      "name": "נחל שורק",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.5
    },
    {
      "name": "פארק מיני ישראל",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=800",
      "rating": 4.4
    },
    {
      "name": "יער הקדושים",
      "location": "ירושלים",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.6
    },
    {
      "name": "חוף הדולפינריום",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800",
      "rating": 4.5
    },
    {
      "name": "פארק תל אפק",
      "location": "מרכז",
      "imageUrl": "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800",
      "rating": 4.7
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
    return categories
        .firstWhere((cat) => cat["name"] == selectedCategory,
        orElse: () => categories[0]);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _floatingController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    for (var key in filters.keys) {
      selectedFilters[key] = false;
    }
    _animationController.forward();
    _floatingController.repeat(reverse: true);

    _checkConnectionOnInit();
  }

  // Check connection when page initializes
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
    final List<Color> appBarColors = List<Color>.from(
        currentCategory["appBarColors"]);
    final List<Color> gradientColors = List<Color>.from(
        currentCategory["gradientColors"]);
    final Color shadowColor = currentCategory["shadowColor"];
    final Color accentColor = currentCategory["accentColor"];
    final Color cardColor = currentCategory["cardColor"];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: RadialGradient(
              center: Alignment.topLeft, radius: 1.5, colors: backgroundColors),
        ),
        child: Stack(
          children: [
            ...List.generate(8, (index) {
              return AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Positioned(
                    left: (index * 80.0) % MediaQuery
                        .of(context)
                        .size
                        .width,
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
                  AnimatedContainer(
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
                          bottomRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                            color: shadowColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8))
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1)
                                ]),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.travel_explore,
                                    color: Colors.white, size: 28),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                      const Text("Map feature coming soon!"),
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
                                    Text("PATHY",
                                        style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 3)),
                                    Text("גלה את ישראל",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                            letterSpacing: 2)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 56),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildCategoriesSection(
                      gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildDestinationsGrid(
                      gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  if (activeFilters.isNotEmpty)
                    _buildActiveFilters(
                        activeFilters, gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  _buildFilterButton(gradientColors, shadowColor, accentColor),
                  const SizedBox(height: 40),
                  // _buildFeaturesSection(gradientColors, cardColor, shadowColor),
                  const SizedBox(height: 40),
                  // _buildTestimonials(gradientColors, cardColor, shadowColor, accentColor),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(List<Color> gradientColors, Color cardColor,
      Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient:
        LinearGradient(colors: [
          cardColor.withOpacity(0.9),
          Colors.white.withOpacity(0.9)
        ]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: shadowColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore, color: gradientColors[0], size: 28),
              const SizedBox(width: 10),
              Text("בחר את סוג הטיול שלך",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: gradientColors[0])),
            ],
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 25,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final isSelected = cat["name"] == selectedCategory;
              final List<Color> catColors = List<Color>.from(
                  cat["gradientColors"]);
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
                            colors: [catColors[1], catColors[0]]),
                        boxShadow: [
                          BoxShadow(
                              color: catShadow.withOpacity(0.6),
                              blurRadius: isSelected ? 25 : 15,
                              offset: const Offset(0, 8)),
                          if (isSelected)
                            const BoxShadow(color: Colors.white,
                                blurRadius: 10,
                                offset: Offset(0, -3)),
                        ],
                        border: isSelected ? Border.all(
                            color: Colors.white, width: 4) : null,
                      ),
                      child: Icon(cat["icon"], size: 45, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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

  Widget _buildDestinationsGrid(List<Color> gradientColors, Color cardColor,
      Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient:
        LinearGradient(colors: [
          Colors.white.withOpacity(0.95),
          cardColor.withOpacity(0.8)
        ]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: shadowColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.place, color: gradientColors[0], size: 28),
              const SizedBox(width: 10),
              Text("יעדים מומלצים",
                  style: TextStyle(fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: gradientColors[0])),
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
            itemCount: displayedDestinations,
            itemBuilder: (context, index) {
              final destination = allDestinations[index];
              return GestureDetector(
                onTap: () {
                  // _showDestinationDetails(context, destination);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5)),
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
                              child: const Icon(Icons.image_not_supported,
                                  color: Colors.white, size: 50),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    gradientColors[0],
                                    gradientColors[1]
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
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
                                    const Icon(Icons.location_on,
                                        color: Colors.white, size: 14),
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
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 14),
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
                      offset: const Offset(0, 6))
                ],
              ),
              child: ElevatedButton.icon(
                icon: const Icon(
                    Icons.expand_more, color: Colors.white, size: 24),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  setState(() {
                    displayedDestinations = (displayedDestinations + 15).clamp(
                        0, allDestinations.length);
                  });
                },
                label: Text(
                  "ראה עוד (${allDestinations.length -
                      displayedDestinations} נותרו)",
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
                    colors: [Colors.grey[400]!, Colors.grey[600]!]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(
                    Icons.expand_less, color: Colors.white, size: 24),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
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

  // show destination details bottom sheet
  void _showDestinationDetails(BuildContext context,
      Map<String, dynamic> destination) {
    final currentCategory = currentCategoryData;
    final List<Color> gradientColors = List<Color>.from(
        currentCategory["gradientColors"]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    destination['imageUrl'],
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(destination['name'],
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: gradientColors[0])),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: gradientColors[0], size: 18),
                            const SizedBox(width: 5),
                            Text(destination['location']),
                            const Spacer(),
                            const Icon(
                                Icons.star, color: Colors.amber, size: 18),
                            Text("${destination['rating']}"),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "תיאור המקום כאן... ניתן להוסיף מידע נוסף לפי הצורך.",
                          style: TextStyle(
                              color: Colors.grey[800], height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFeatureChip(
                                Icons.local_parking, "חניה", gradientColors[0]),
                            _buildFeatureChip(
                                Icons.restaurant, "מסעדות", gradientColors[0]),
                            _buildFeatureChip(
                                Icons.wc, "שירותים", gradientColors[0]),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // helper for feature chips
  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  // active filters bar
  Widget _buildActiveFilters(List<String> activeFilters,
      List<Color> gradientColors, Color cardColor, Color shadowColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: shadowColor.withOpacity(0.25), blurRadius: 12),
        ],
      ),
      child: Wrap(
        spacing: 8,
        children: activeFilters
            .map((f) =>
            Chip(
              label: Text(f, style: const TextStyle(color: Colors.white)),
              backgroundColor: gradientColors[0],
            ))
            .toList(),
      ),
    );
  }


  Widget _buildFilterButton(List<Color> gradientColors, Color shadowColor, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.filter_list),
        style: ElevatedButton.styleFrom(
          backgroundColor: gradientColors[0],
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {
          // open filter bottom sheet here
        },
        label: const Text("סינון", style: TextStyle(color: Colors.white)),
      ),
    );
  }



    // testimonials section
    Widget _buildTestimonials(List<Color> gradientColors, Color cardColor, Color shadowColor, Color accentColor) {
      final testimonials = [
        {"name": "נועה", "text": "חוויה מדהימה!"},
        {"name": "דני", "text": "מסלול מהמם, שירות מעולה"},
      ];
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: shadowColor.withOpacity(0.3), blurRadius: 12),
          ],
        ),
        child: Column(
          children: testimonials
              .map((t) =>
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: gradientColors[0],
                  child: Text(t["name"]![0],
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text(t["name"]!),
                subtitle: Text(t["text"]!),
              ))
              .toList(),
        ),
      );
    }

  }
