import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionRequest extends StatefulWidget {
  const LocationPermissionRequest({super.key});

  @override
  _LocationPermissionRequestState createState() =>
      _LocationPermissionRequestState();

  static Future<void> requestLocationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      try {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogTheme: DialogThemeData(backgroundColor: Colors.white)),
              child: CupertinoAlertDialog(
                title: Text(
                  "Location Permission Required",
                  style: TextStyle(color: Color(0xFF33196B), fontSize: 16),
                ),
                content: Text(
                  "EmployRoll app needs location access to provide its features. Please grant permission.",
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "Allow",
                      style: TextStyle(color: Color(0xFF33196B), fontSize: 14),
                    ),
                    onPressed: () async {
                      bool isOpened = await openAppSettings();
                      Navigator.pop(context); // Close the current dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      } catch (e) {
      }
    }
  }
}

class _LocationPermissionRequestState extends State<LocationPermissionRequest> {
  @override
  Widget build(BuildContext context) {
    // Implement build method if needed
    throw UnimplementedError();
  }
}
