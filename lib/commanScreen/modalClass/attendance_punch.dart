import 'package:hive/hive.dart';

 // Code generation के लिए
part 'attendance_punch.g.dart';

@HiveType(typeId: 0)  // हर model का unique typeId होना चाहिए
class AttendancePunch extends HiveObject {
  @HiveField(0)
  String sessionId;

  @HiveField(1)
  String currentDate;

  @HiveField(2)
  String address;

  @HiveField(3)
  String clockingType;

  @HiveField(4)
  String lat;

  @HiveField(5)
  String lng;

  @HiveField(6)
  String firstImei;

  @HiveField(7)
  String secondImei;

  @HiveField(8)
  String macAddress;

  @HiveField(9)
  String deviceId;

  @HiveField(10)
  String battery;

  @HiveField(11)
  String image;

  AttendancePunch({
    required this.sessionId,
    required this.currentDate,
    required this.address,
    required this.clockingType,
    required this.lat,
    required this.lng,
    required this.firstImei,
    required this.secondImei,
    required this.macAddress,
    required this.deviceId,
    required this.battery,
    required this.image,
  });

  // JSON से convert करने के लिए factory
  factory AttendancePunch.fromJson(Map<String, dynamic> json) {
    return AttendancePunch(
      sessionId: json['sessionId'],
      currentDate: json['currentDate'],
      address: json['address'],
      clockingType: json['clockingType'],
      lat: json['lat'],
      lng: json['lng'],
      firstImei: json['firstImei'],
      secondImei: json['secondImei'],
      macAddress: json['macAddress'],
      deviceId: json['deviceId'],
      battery: json['battery'],
      image: json['image'],
    );
  }

  // JSON में वापस बदलने के लिए
  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "currentDate": currentDate,
      "address": address,
      "clockingType": clockingType,
      "lat": lat,
      "lng": lng,
      "firstImei": firstImei,
      "secondImei": secondImei,
      "macAddress": macAddress,
      "deviceId": deviceId,
      "battery": battery,
      "image": image,
    };
  }
}
