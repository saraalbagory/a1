// import 'package:a1/stores/data/models/store_model.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   static Future<Position> getCurrentLocation() async {
//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }

//   static double calculateDistance(Position start, StoreModel store) {
//     return Geolocator.distanceBetween(
//       start.latitude,
//       start.longitude,
//       store.geocodes.main.latitude,
//       store.geocodes.main.longitude,
//     );
//   }
// }

import 'package:geolocator/geolocator.dart';
import 'package:a1/stores/data/models/store_model.dart';

class LocationService {
  static Future<bool> checkLocationServices() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return null;
        }
      }
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      print(Geolocator.getCurrentPosition(locationSettings: locationSettings));
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  static double calculateDistance(Position start, StoreModel store) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      store.geocodes.main.latitude,
      store.geocodes.main.longitude,
    );
  }
}
