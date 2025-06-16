import 'package:flutter/material.dart';

ValueNotifier<String> selectedProfileNameNotifier = ValueNotifier<String>('');
ValueNotifier<int> selectedProfileIdNotifier = ValueNotifier<int>(0);

class PermissionNotifier extends ValueNotifier<String> {
  PermissionNotifier() : super("0"); // default value

  void updatePermission(String newPermission) {
    value = newPermission;
  }
}

// Global instance (can be moved to a global provider file if needed)
final permissionNotifier = PermissionNotifier();