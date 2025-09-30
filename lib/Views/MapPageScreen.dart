import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  // Example center point (Tel Aviv)
  final LatLng _center = const LatLng(32.0853, 34.7818);

  // Example markers
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId("tel_aviv"),
      position: LatLng(32.0853, 34.7818),
      infoWindow: InfoWindow(title: "Tel Aviv", snippet: "Center of Israel"),
    ),
    const Marker(
      markerId: MarkerId("jerusalem"),
      position: LatLng(31.7683, 35.2137),
      infoWindow: InfoWindow(title: "Jerusalem", snippet: "Capital City"),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    // Show placeholder in web/tests (no plugin support there)
    if (kIsWeb ||
        ![TargetPlatform.android, TargetPlatform.iOS]
            .contains(defaultTargetPlatform)) {
      return Scaffold(
        appBar: AppBar(title: const Text("Search Nearby")),
        body: const Center(
          child: Text("Google Maps not available in this environment"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Nearby"),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: "Go to Tel Aviv",
            onPressed: () {
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(_center, 14),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 12,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
        markers: _markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId("marker_${_markers.length}"),
                position: LatLng(
                  _center.latitude + (_markers.length * 0.01),
                  _center.longitude + (_markers.length * 0.01),
                ),
                infoWindow: const InfoWindow(title: "New Marker"),
              ),
            );
          });
        },
        label: const Text("Add Marker"),
        icon: const Icon(Icons.add_location),
        backgroundColor: Colors.green,
      ),
    );
  }
}
