// search/area_search_button.dart
import 'package:flutter/material.dart';

class AreaSearchButton extends StatefulWidget {
  final List<String> areas;
  final Function(String) onAreaSelected;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const AreaSearchButton({
    Key? key,
    required this.areas,
    required this.onAreaSelected,
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
  List<String> _filteredAreas = [];
  bool _showResults = false;
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _filteredAreas = widget.areas;
    _searchController.addListener(_filterAreas);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _widthAnimation = Tween<double>(begin: 48, end: 320).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _filterAreas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredAreas = widget.areas;
        _showResults = false;
      } else {
        _filteredAreas = widget.areas
            .where((area) => area.toLowerCase().contains(query))
            .toList();
        _showResults = true;
      }
    });
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
        _showResults = false;
        _focusNode.unfocus();
      }
    });
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
    final icColor = widget.iconColor ?? Colors.green[700]!;
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
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: _toggleSearch,
                      child: Container(
                        width: 48,
                        height: 48,
                        child: Icon(
                          _isExpanded ? Icons.close : Icons.search,
                          color: icColor,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  if (_isExpanded)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        style: TextStyle(color: txtColor, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'חפש אזור...',
                          hintStyle: TextStyle(
                            color: txtColor.withOpacity(0.5),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  if (_isExpanded && _searchController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, color: icColor, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _showResults = false;
                        });
                      },
                    ),
                ],
              ),
            );
          },
        ),
        if (_showResults && _filteredAreas.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 280),
            width: 320,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _filteredAreas.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Colors.grey.shade300,
                ),
                itemBuilder: (context, index) {
                  final area = _filteredAreas[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        widget.onAreaSelected(area);
                        _searchController.text = area;
                        setState(() {
                          _showResults = false;
                          _isExpanded = false;
                        });
                        _animationController.reverse();
                        _focusNode.unfocus();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: icColor,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                area,
                                style: TextStyle(
                                  color: txtColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey.shade400,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        if (_showResults && _filteredAreas.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 320,
            padding: const EdgeInsets.all(20),
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
            child: Row(
              children: [
                Icon(Icons.search_off, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Text(
                  'לא נמצאו תוצאות',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
