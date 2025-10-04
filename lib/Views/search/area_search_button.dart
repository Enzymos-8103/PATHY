import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../DestinationDetailsScreen.dart';

class AreaSearchButton extends StatefulWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const AreaSearchButton({
    Key? key,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<AreaSearchButton> createState() => _AreaSearchButtonState();
}

class _AreaSearchButtonState extends State<AreaSearchButton>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showResults = false;
  bool _isExpanded = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _suggestions = [];

  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = Tween<double>(begin: 48, end: 320).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  /// חיפוש ב-Firestore תוך תמיכה בעברית
  Future<void> _onSearchChanged() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _showResults = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showResults = true;
    });

    try {
      // נשלוף את כל היעדים
      final snapshot =
      await FirebaseFirestore.instance.collection('destinations').get();

      // חיפוש לוקאלי (חכם בעברית)
      final List<Map<String, dynamic>> matches = snapshot.docs
          .map((d) => d.data() as Map<String, dynamic>)
          .where((d) {
        final name = (d['name'] ?? '').toString();
        final location = (d['location'] ?? '').toString();

        // משווה גם בהתחלה וגם בתווך (case-insensitive)
        return name.contains(query) ||
            name.startsWith(query) ||
            location.contains(query) ||
            location.startsWith(query);
      })
          .toList();

      setState(() {
        _suggestions = matches.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('שגיאה בחיפוש: $e');
      setState(() => _isLoading = false);
    }
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        _focusNode.requestFocus();
      } else {
        _animationController.reverse();
        _searchController.clear();
        _suggestions = [];
        _showResults = false;
        _focusNode.unfocus();
      }
    });
  }

  void _onSuggestionTap(Map<String, dynamic> data) {
    print("_onSuggestionTap");
    final name = data['name'] ?? '';
    _searchController.text = name;
    setState(() {
      _showResults = false;
      _isExpanded = false;
    });
    _animationController.reverse();
    _focusNode.unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailsPage(
          destination: data,
          gradientColors: const [Color(0xFF26A69A), Color(0xFF4DD0E1)],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? Colors.white;
    final icColor = widget.iconColor ?? Colors.teal[700]!;
    final txtColor = widget.textColor ?? Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _widthAnimation,
          builder: (context, child) {
            return Container(
              width: _widthAnimation.value,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _toggleSearch,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        _isExpanded ? Icons.close : Icons.search,
                        color: icColor,
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: txtColor, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'חפש יעד, עיר או אזור...',
                          hintStyle: TextStyle(
                            color: txtColor.withOpacity(0.5),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (_showResults)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 320,
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _isLoading
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
                : _suggestions.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text('לא נמצאו תוצאות',
                  textAlign: TextAlign.center),
            )
                : ListView.separated(
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                final name = suggestion['name'] ?? 'ללא שם';
                final location = suggestion['location'] ?? '';
                final image = suggestion['imageUrl'] ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    image.isNotEmpty ? NetworkImage(image) : null,
                    backgroundColor: Colors.grey[300],
                  ),
                  title: Text(name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(location,
                      textDirection: TextDirection.rtl),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: Colors.grey),
                  onTap: () => _onSuggestionTap(suggestion),
                );
              },
            ),
          ),
      ],
    );
  }
}
