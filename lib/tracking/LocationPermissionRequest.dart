import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionRequest extends StatefulWidget {
  const LocationPermissionRequest({super.key});

  @override
  _LocationPermissionRequestState createState() =>
      _LocationPermissionRequestState();

  static Future<bool> requestLocationPermission(BuildContext context) async {
    final currentStatus = await Permission.location.status;

    if (currentStatus.isGranted || currentStatus.isLimited) {
      return true;
    }

    // The system prompt cannot be shown again after a permanent denial. Only
    // offer Settings when the user comes back to a location-based feature.
    if (currentStatus.isPermanentlyDenied) {
      if (!context.mounted) return false;
      await _showSettingsDialog(context);
      return false;
    }

    if (currentStatus.isRestricted) {
      if (!context.mounted) return false;
      await _showRestrictedDialog(context);
      return false;
    }

    // Explain why location is needed before displaying the iOS/Android system
    // permission prompt. Cancelling keeps the user in the app.
    if (!context.mounted) return false;
    final shouldRequest = await _showExplanationDialog(context);
    if (!shouldRequest || !context.mounted) return false;

    final requestedStatus = await Permission.location.request();

    // Do not open Settings or show another dialog immediately after the user
    // chooses "Don't Allow" in the system prompt.
    return requestedStatus.isGranted || requestedStatus.isLimited;
  }

  static Future<bool> _showExplanationDialog(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await showCupertinoDialog<bool>(
            context: context,
            builder: (dialogContext) => CupertinoAlertDialog(
              title: const Text('Location Permission Required'),
              content: const Text(
                'Location permission is required for attendance punching.',
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Allow Location'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Location permission is required for attendance punching.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Allow Location'),
              ),
            ],
          ),
        ) ??
        false;
  }

  static Future<void> _showSettingsDialog(BuildContext context) async {
    final openSettings = defaultTargetPlatform == TargetPlatform.iOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (dialogContext) => CupertinoAlertDialog(
              title: const Text('Location Unavailable'),
              content: const Text(
                'Location permission is disabled. Please enable it from Settings to use location-based attendance.',
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          )
        : await showDialog<bool>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              title: const Text('Location Unavailable'),
              content: const Text(
                'Location permission is disabled. Please enable it from Settings to use location-based attendance.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );

    if (openSettings == true) {
      await openAppSettings();
    }
  }

  static Future<void> _showRestrictedDialog(BuildContext context) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text('Location Unavailable'),
          content: const Text(
            'Location access is restricted on this device. Attendance punching cannot use your location.',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Location Unavailable'),
        content: const Text(
          'Location access is restricted on this device. Attendance punching cannot use your location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _LocationPermissionRequestState extends State<LocationPermissionRequest> {
  @override
  Widget build(BuildContext context) {
    // Implement build method if needed
    throw UnimplementedError();
  }
}
