
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

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
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openAppSettings();
      //return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        //return Future.error('Location permissions are denied');
        await Geolocator.openAppSettings();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    {
      inSuccess?.call();
    }

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
        print("Geolocator Latlng $currentLocation");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
