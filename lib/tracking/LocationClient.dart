import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class LocationClient {
  final Location _location = Location();
  final String channelName = "Location Updates";

  Stream<LatLng> get locationStream =>
      _location.onLocationChanged.map((event) => LatLng(event.latitude!, event.longitude!));


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> setupNotificationChannel() async {
     AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelName, // Channel ID (must be unique)
      channelName, // Channel Name
      description: 'Used for  tracking location in background', // Description
      importance: Importance.high, // Importance level
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

  }

  void init() async {
    //_requestPermissions();
    //await setupNotificationChannel();

    final serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      await _location.requestService();
    }
    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
    }
    if (permissionStatus == PermissionStatus.granted) {
      print("permission Granted");
      //await _location.enableBackgroundMode(enable: true);
      /*bool backgroundEnabled = await _location.enableBackgroundMode(enable: true);
      print("Background mode enabled: $backgroundEnabled");
*/
      enableBackgroundMode();
      print("permission Granted 2");
      Stream<LocationData> getLocationStream() {
        _location.changeSettings(
          accuracy: LocationAccuracy.high,
          interval: 5000, // Get location every 5 seconds
          distanceFilter: 5, // Update only if moved 5 meters
        );
        return _location.onLocationChanged;
      }

      await _location.changeSettings(accuracy: LocationAccuracy.high,interval: 10000,distanceFilter: 0);
      await _location.changeNotificationOptions(
        channelName: "Location Updates",
        title: 'Employroll',
        subtitle: 'Geolocation detection',
        onTapBringToFront: true,
      );

      //AndroidNotificationChannel androidNotificationChannel
      /*const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
        'high_importance_channel', // Channel ID (Should match the created one)
        'High Importance Notifications',
        channelDescription: 'This is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
      );*/
    }
  }
  Future<bool> enableBackgroundMode() async {
    bool _bgModeEnabled = await _location.isBackgroundModeEnabled();
    if (_bgModeEnabled) {
      return true;
    } else {
      try {
        await _location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        _bgModeEnabled = await _location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      print(_bgModeEnabled); //True!
      return _bgModeEnabled;
    }
  }
  Future<bool> isServiceEnabled() async {
    return _location.serviceEnabled();
  }
  void stopLocationService() async {
    await _location.enableBackgroundMode(enable: false); // Stops background tracking
    await _location.changeSettings(accuracy: LocationAccuracy.low, interval: 0);
  }

  Future<void> _requestPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // Use this utility only if you provide services that require long-term survival,
      // such as exact alarm service, healthcare service, or Bluetooth communication.
      //
      // This utility requires the "android.permission.SCHEDULE_EXACT_ALARM" permission.
      // Using this permission may make app distribution difficult due to Google policy.
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        // When you call this function, will be gone to the settings page.
        // So you need to explain to the user why set it.
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }
}