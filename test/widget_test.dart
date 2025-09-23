import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 On tests or web → show placeholder instead of crashing
    if (kIsWeb ||
        ![TargetPlatform.android, TargetPlatform.iOS]
            .contains(defaultTargetPlatform)) {
      return Scaffold(
        appBar: AppBar(title: const Text("Search Nearby")),
        body: const Center(
          child: Text(
            "Map not available in this environment",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    // 🔹 On Android/iOS → show real Google Map
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Nearby"),
        backgroundColor: Colors.green,
      ),
      body: const GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(32.0853, 34.7818), // Tel Aviv
          zoom: 12,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
