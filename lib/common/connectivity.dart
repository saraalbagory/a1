import 'package:connectivity_plus/connectivity_plus.dart';

class CustomConnectivity {
  // Future<bool> isConnected() async {

  // final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   return connectivityResult != ConnectivityResult.none;
  // }
  // Future<void> checkInternet() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();

  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     print("Connected to Mobile Data");
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     print("Connected to WiFi");
  //   } else if (connectivityResult == ConnectivityResult.none) {
  //     print("No Internet Connection");
  //   }
  // }

  Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return false;
    //     print("Connected to Mobile Data");
    //   } else if (connectivityResult == ConnectivityResult.wifi) {
    //     print("Connected to WiFi");
    //   } else if (connectivityResult == ConnectivityResult.none) {
    //     print("No Internet Connection");
    //   }
  }
}
