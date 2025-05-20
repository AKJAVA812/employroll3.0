import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RealTimeLocationWithAddress extends StatefulWidget {
  @override
  _RealTimeLocationWithAddressState createState() =>
      _RealTimeLocationWithAddressState();
}

class _RealTimeLocationWithAddressState
    extends State<RealTimeLocationWithAddress> {
  Position? _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndTrackLocation();
  }

  Future<void> _checkPermissionAndTrackLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Trigger updates for every 5 meters
        ),
      ).listen((Position position) async {
        setState(() {
          _currentPosition = position;
        });
        print("Current Position $_currentPosition");

        // Fetch the address for the new position
        await _getAddressFromLatLng(position);
      });
    } else {
      print("Location permission not granted");
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.street}, ${place.name}, ${place.postalCode}, ${place.subAdministrativeArea}, ${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-Time Location with Address"),
      ),
      body: Center(
        child: _currentPosition == null
            ? Text("Fetching location...")
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}"),
            SizedBox(height: 10),
            _currentAddress == null
                ? Text("Fetching address...")
                : Text("Address: $_currentAddress"),
          ],
        ),
      ),
    );
  }
}