import 'package:a1/common/location_service.dart';
import 'package:a1/stores/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StoreDistanceScreen extends StatefulWidget {
  final StoreModel store;

  const StoreDistanceScreen({super.key, required this.store});

  @override
  State<StoreDistanceScreen> createState() => _StoreDistanceScreenState();
}

class _StoreDistanceScreenState extends State<StoreDistanceScreen> {
  double? distance;
  String? errorMessage;
  bool loading = true;
  Position? userPosition;
  final MapController mapController = MapController();

  Future<void> _calculateDistance() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final serviceEnabled = await LocationService.checkLocationServices();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location services are disabled.';
          loading = false;
        });
        return;
      }

      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        setState(() {
          errorMessage = 'Location permission denied.';
          loading = false;
        });
        return;
      }

      final dist = LocationService.calculateDistance(position, widget.store);
      setState(() {
        userPosition = position;
        distance = dist / 1000;
        loading = false;
      });

      // Zoom map to fit both points
      final storeLatLng = LatLng(
        widget.store.geocodes.main.latitude,
        widget.store.geocodes.main.longitude,
      );
      final userLatLng = LatLng(position.latitude, position.longitude);

      final bounds = LatLngBounds.fromPoints([storeLatLng, userLatLng]);
      print('Store: ${storeLatLng.latitude}, ${storeLatLng.longitude}');
      print('User: ${userLatLng.latitude}, ${userLatLng.longitude}');

      mapController.fitBounds(
        bounds,
        options: const FitBoundsOptions(padding: EdgeInsets.all(50)),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to get location: $e';
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  @override
  Widget build(BuildContext context) {
    final storeLatLng = LatLng(
      widget.store.geocodes.main.latitude,
      widget.store.geocodes.main.longitude,
    );

    final userLatLng =
        userPosition != null
            ? LatLng(userPosition!.latitude, userPosition!.longitude)
            : null;

    return Scaffold(
      appBar: AppBar(title: Text('Distance to ${widget.store.name}')),
      body: Column(
        children: [
          SizedBox(
            height: 60.h,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(center: storeLatLng, zoom: 14.0),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40,
                        height: 40,
                        point: storeLatLng,
                        child: const Icon(
                          Icons.store,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                      if (userLatLng != null)
                        Marker(
                          width: 40,
                          height: 40,
                          point: userLatLng,
                          child: const Icon(
                            Icons.person_pin_circle,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child:
                  loading
                      ? const CircularProgressIndicator()
                      : errorMessage != null
                      ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _calculateDistance,
                            child: const Text("Try Again"),
                          ),
                        ],
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.directions_walk, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Distance: ${distance!.toStringAsFixed(2)} km',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'From your location to:\n${widget.store.location.address ?? "Store address not available"}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
