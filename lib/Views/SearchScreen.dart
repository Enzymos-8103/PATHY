import 'package:flutter/material.dart';
import 'package:pathy/Views/search/area_search_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF26A69A),
              Color(0xFF00796B),
              Color(0xFF004D40),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 🔙 Back button and title
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "חיפוש יעדים",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              // 🔍 Default expanded search bar with results
              // Expanded(
              //   child: Container(
              //     padding:
              //     const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              //     decoration: const BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(40),
              //         topRight: Radius.circular(40),
              //       ),
              //     ),
              //     child: AreaSearchBarExpanded(), // 👈 We'll use a modified widget
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
