import 'package:flutter/material.dart';

ValueNotifier<String> selectedProfileNameNotifier = ValueNotifier<String>('');
ValueNotifier<int> selectedProfileIdNotifier = ValueNotifier<int>(0);

// Global notifiers for requisition counts
ValueNotifier<int> attReqCountNotifier = ValueNotifier<int>(0);
ValueNotifier<int> leaveReqCountNotifier = ValueNotifier<int>(0);
ValueNotifier<int> odReqCountNotifier = ValueNotifier<int>(0);

class PermissionNotifier extends ValueNotifier<String> {
  PermissionNotifier() : super("0"); // default value

  void updatePermission(String newPermission) {
    value = newPermission;
  }
}

// Global instance (can be moved to a global provider file if needed)
final permissionNotifier = PermissionNotifier();