import 'package:flutter/widgets.dart';

const String defaultProfileAsset = 'assets/images/avtar7.png';

ImageProvider profileImageProvider(String? imagePath) {
  final value = imagePath?.trim() ?? '';
  if (value.isEmpty) {
    return const AssetImage(defaultProfileAsset);
  }

  final uri = Uri.tryParse(value);
  if (uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty) {
    return NetworkImage(value);
  }

  if (value.startsWith('assets/')) {
    return AssetImage(value);
  }

  return const AssetImage(defaultProfileAsset);
}
