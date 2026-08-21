
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../LocationPermissionRequest.dart';

class Geolocatortracking extends StatefulWidget {
  const Geolocatortracking({super.key});


  @override
  State<Geolocatortracking> createState() => _GeolocatortrackingState();
}


class _GeolocatortrackingState extends State<Geolocatortracking> {

  @override
  void initState() {
    startLocationListner();
    // TODO: implement initState
    super.initState();
  }

  Position? currentLocation;
  StreamSubscription? streamSubscription;

  locationPermission({VoidCallback? inSuccess}) async
  {
    final permissionGranted =
        await LocationPermissionRequest.requestLocationPermission(context);
    if (!permissionGranted || !mounted) return;

    // Test if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return;
    }

    inSuccess?.call();

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //return await Geolocator.getCurrentPosition();
  }

  void startLocationListner()
  {
    locationPermission(inSuccess: () async {
      streamSubscription = Geolocator.getPositionStream(
        locationSettings: Platform.isAndroid?AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 1),
          foregroundNotificationConfig: const
          ForegroundNotificationConfig(notificationTitle: "location Fetch in Background",
            notificationText: "Your current location is listened in backgroud",
            enableWakeLock: true,
          ),
        ) :AppleSettings(
            accuracy: LocationAccuracy.high,
            activityType: ActivityType.fitness,
            pauseLocationUpdatesAutomatically: true,
            showBackgroundLocationIndicator: true
        ),
      ).listen((event) async {
        currentLocation = event;
        //log(currentLocation.toString() as num);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
