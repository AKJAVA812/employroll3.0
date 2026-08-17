import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class trackingWorkmanger extends StatefulWidget {
   const trackingWorkmanger({super.key});

  @override
  State<trackingWorkmanger> createState() => _trackingWorkmangerState();
}

class _trackingWorkmangerState extends State<trackingWorkmanger> {
  final Location _location = Location();

  LocationData? _currentLocation;

  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();


  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    await _location.enableBackgroundMode(enable: true);

    _locationSubscription = _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _currentLocation = locationData;
      });
    });
  }
}
