import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final uuid = Uuid();

Map<String, dynamic> createOfflinePunch({
  required String sessionId,
  required String address,
  required String clockingType,
  required double lat,
  required double lng,
  required String deviceId,
  required String imagePath,
}) {
  final now = DateTime.now();
  final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

  return {
    'id': uuid.v4(),
    'sessionId': sessionId,
    'currentDate': formattedDate,
    'address': address,
    'clockingType': clockingType,
    'lat': lat,
    'lng': lng,
    'deviceId': deviceId,
    'imagePath': imagePath,
    'synced': false,
  };
}
