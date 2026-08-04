import 'dart:async';
import 'package:location/location.dart';

const String backgroundTask = "backgroundLocationTask";

class LocationService {
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> initLocationService() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    await location.enableBackgroundMode(enable: true);
  }

  Future<void> startLocationTracking() async {
    await initLocationService();

    _locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      print("Location: Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}");
    });
  }

  void stopLocationTracking() {
    _locationSubscription?.cancel();
  }

 /* static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      Location location = Location();
      LocationData? currentLocation = await location.getLocation();
      print("Background Location: Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}");
      return Future.value(true);
    });
  }*/

  // void registerBackgroundTask() {
  //   Workmanager().registerPeriodicTask(
  //     "1",
  //     backgroundTask,
  //     frequency: Duration(minutes: 15),
  //   );
  // }
}
