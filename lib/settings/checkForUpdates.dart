import 'dart:io';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker extends StatefulWidget {
  @override
  _UpdateCheckerState createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  String? _currentVersion;
  String? _storeVersion;
  bool _updateAvailable = false;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final upgrader = Upgrader(
      debugLogging: true,
    );

    await upgrader.initialize(); // fetches store version internally

    final storeVersion = upgrader.currentAppStoreVersion;

    if (storeVersion != null &&
        storeVersion != currentVersion) {
      setState(() {
        _updateAvailable = true;
        _currentVersion = currentVersion;
        _storeVersion = storeVersion;
      });
    }
  }

  void redirectToStore() async {
    final androidUrl =
        'https://play.google.com/store/apps/details?id=com.employroll.employroll'; // ✅ change package name
    final iosUrl = 'https://apps.apple.com/in/app/employroll-2-0/id1664350846'; // ✅ change App Store ID

    final url = Platform.isAndroid ? androidUrl : iosUrl;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open store link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check for Updates"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: checkForUpdate,
              child: Text('Check for Update'),
            ),
            SizedBox(height: 10),
            if (_updateAvailable)
              Column(
                children: [
                  Text(
                    "Update available!\nStore: $_storeVersion | Current: $_currentVersion",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: redirectToStore,
                    icon: Icon(Icons.system_update_alt),
                    label: Text('Update Now'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  )
                ],
              )
            else
              Text("Your app is up to date."),
          ],
        ),
      ),
    );
  }
}