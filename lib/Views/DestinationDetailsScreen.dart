import 'package:flutter/material.dart';
import 'AuthScreen.dart';
import 'PurchaseScreen.dart';
class DestinationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> destination;
  final List<Color> gradientColors;

  const DestinationDetailsPage({
    super.key,
    required this.destination,
    required this.gradientColors,
  });

  @override
  State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
}

class _DestinationDetailsPageState extends State<DestinationDetailsPage> {
  int _hoveredStar = 0;
  int _selectedRating = 0;

  // ✅ FIX: moved these out of build()
  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, dynamic>> _reviews = [];
  bool _showAllReviews = false;

  // Mock user authentication status - replace with your actual auth logic
  bool get isUserLoggedIn => false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _handleStarTap(int rating) {
    if (!isUserLoggedIn) {
      _showAuthDialog();
    } else {
      setState(() {
        _selectedRating = rating;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('דירגת $rating כוכבים!'),
          backgroundColor: widget.gradientColors[0],
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: widget.gradientColors[0]),
            const SizedBox(width: 10),
            const Text('נדרשת התחברות'),
          ],
        ),
        content: const Text(
          'על מנת לדרג את היעד, עליך להתחבר או להירשם למערכת',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ביטול'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthPage(isSignUp: false),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.gradientColors[0],
              foregroundColor: Colors.white,
            ),
            child: const Text('התחבר'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthPage(isSignUp: true),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.gradientColors[1],
              foregroundColor: Colors.white,
            ),
            child: const Text('הירשם'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.destination['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.gradientColors,
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
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
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
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
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('נוסף למועדפים!'),
                        backgroundColor: widget.gradientColors[0],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Location
                    Text(
                      widget.destination['name'],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.gradientColors[0],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: widget.gradientColors[0],
                          size: 22,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.destination['location'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const Icon(Icons.star, color: Colors.amber, size: 22),
                        const SizedBox(width: 5),
                        Text(
                          "${widget.destination['rating']}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Divider(thickness: 1),
                    const SizedBox(height: 25),

                    // Description
                    _buildSection(
                      title: 'אודות המקום',
                      icon: Icons.info_outline,
                      content: Text(
                        widget.destination['description'] ??
                            'מקום מדהים לטיול! ${widget.destination['name']} ממוקם ב${widget.destination['location']} ומציע חוויה בלתי נשכחת. אידיאלי למשפחות, זוגות וחובבי טבע.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Route Information
                    _buildSection(
                      title: 'מסלול מומלץ',
                      icon: Icons.map_outlined,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRouteStep(
                            1,
                            'התחל את הטיול בכניסה הראשית',
                            'זמן משוער: 10 דקות',
                          ),
                          _buildRouteStep(
                            2,
                            'עקוב אחר השביל המסומן',
                            'זמן משוער: 30 דקות',
                          ),
                          _buildRouteStep(
                            3,
                            'הגע לנקודת התצפית העיקרית',
                            'זמן משוער: 45 דקות',
                          ),
                          _buildRouteStep(
                            4,
                            'חזור בשביל החלופי לחניה',
                            'זמן משוער: 40 דקות',
                            isLast: true,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: widget.gradientColors[0].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.gradientColors[0]
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: widget.gradientColors[0],
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'סה"כ זמן משוער: 2-3 שעות',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Facilities
                    _buildSection(
                      title: 'מתקנים זמינים',
                      icon: Icons.check_circle_outline,
                      content: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildFeatureChip(Icons.local_parking, 'חניה'),
                          _buildFeatureChip(Icons.restaurant, 'מסעדות'),
                          _buildFeatureChip(Icons.wc, 'שירותים'),
                          _buildFeatureChip(Icons.accessible, 'נגיש'),
                          _buildFeatureChip(Icons.water_drop, 'מים'),
                          _buildFeatureChip(Icons.wifi, 'WiFi'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Tips
                    _buildSection(
                      title: 'טיפים מומלצים',
                      icon: Icons.lightbulb_outline,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTip('הגיעו מוקדם בבוקר למנוע עומס'),
                          _buildTip('הביאו מים ומזון קל'),
                          _buildTip('נעליים נוחות ללא החלקה'),
                          _buildTip('בדקו תחזית מזג אויר לפני היציאה'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ⭐ Rating + Review input (UNCHANGED, now works)
                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.gradientColors[0].withOpacity(0.1),
                            widget.gradientColors[1].withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.gradientColors[0].withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'דרג וכתוב ביקורת',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: widget.gradientColors[0],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'הדירוג שלך עוזר לאחרים לבחור את היעד המושלם!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ⭐ Star Selector
                          // ⭐ Star Selector
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                final starIndex = index + 1;
                                final isSelected = starIndex <= _selectedRating;
                                final isHovered = starIndex <= _hoveredStar;

                                return MouseRegion(
                                  onEnter: (_) => setState(() => _hoveredStar = starIndex),
                                  onExit: (_) => setState(() => _hoveredStar = 0),
                                  child: GestureDetector(
                                    onTap: () => _handleStarTap(starIndex),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4), // smaller padding
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        child: Icon(
                                          isSelected || isHovered ? Icons.star : Icons.star_border,
                                          size: 38, // ✅ reduced from 50 to avoid overflow
                                          color: isSelected || isHovered ? Colors.amber : Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),


                          if (_selectedRating > 0) ...[
                            const SizedBox(height: 15),
                            TextField(
                              controller: _reviewController,
                              maxLines: 3,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                labelText: 'כתוב ביקורת על המקום',
                                hintText: 'איך הייתה החוויה שלך?',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: widget.gradientColors[0]
                                          .withOpacity(0.3)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.gradientColors[0],
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                if (!isUserLoggedIn) {
                                  _showAuthDialog();
                                  return;
                                }
                                if (_selectedRating == 0 ||
                                    _reviewController.text
                                        .trim()
                                        .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'נא לבחור דירוג ולכתוב ביקורת')),
                                  );
                                  return;
                                }
                                setState(() {
                                  _reviews.insert(0, {
                                    'name':
                                    'משתמש ${_reviews.length + 1}', // replace with actual user name
                                    'rating': _selectedRating,
                                    'text': _reviewController.text.trim(),
                                  });
                                  _reviewController.clear();
                                  _selectedRating = 0;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('✅ הביקורת נשמרה בהצלחה!')),
                                );
                              },
                              child: const Text(
                                'שלח ביקורת',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Add this button in your DestinationDetailsPage
                    Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: widget.gradientColors),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                        label: const Text(
                          'רכוש טיול',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchaseTripPage(
                                destination: widget.destination,
                                gradientColors: widget.gradientColors,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 📜 Public Reviews Section
                    if (_reviews.isNotEmpty) ...[
                      Text(
                        'ביקורות של מטיילים',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: widget.gradientColors[0],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          for (var review
                          in (_showAllReviews ? _reviews : _reviews.take(3)))
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: widget.gradientColors[0]
                                        .withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person,
                                          color: widget.gradientColors[0]),
                                      const SizedBox(width: 8),
                                      Text(
                                        review['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: List.generate(5, (i) {
                                          return Icon(
                                            i < review['rating']
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    review['text'],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                        height: 1.5),
                                  ),
                                ],
                              ),
                            ),
                          if (_reviews.length > 3)
                            TextButton(
                              onPressed: () => setState(
                                      () => _showAllReviews = !_showAllReviews),
                              child: Text(
                                _showAllReviews
                                    ? 'הצג פחות ביקורות'
                                    : 'הצג עוד ביקורות',
                                style: TextStyle(
                                    color: widget.gradientColors[0],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 40),

                    // 📍 Get Directions Button (unchanged)
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: widget.gradientColors),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradientColors[0].withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.directions,
                            color: Colors.white, size: 28),
                        label: const Text(
                          'קבל הוראות הגעה',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'פותח ניווט ל${widget.destination['name']}'),
                              backgroundColor: widget.gradientColors[0],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Duplicate Directions Button (kept on purpose)
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradientColors,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color:
                            widget.gradientColors[0].withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.directions,
                            color: Colors.white, size: 28),
                        label: const Text(
                          'קבל הוראות הגעה',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'פותח ניווט ל${widget.destination['name']}',
                              ),
                              backgroundColor: widget.gradientColors[0],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: widget.gradientColors[0], size: 26),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.gradientColors[0],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        content,
      ],
    );
  }

  Widget _buildRouteStep(int step, String title, String time,
      {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradientColors),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$step',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: widget.gradientColors[0].withOpacity(0.3),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
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
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: widget.gradientColors[0]),
      label: Text(label),
      backgroundColor: widget.gradientColors[0].withOpacity(0.1),
      side: BorderSide(color: widget.gradientColors[0].withOpacity(0.3)),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: widget.gradientColors[0],
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
