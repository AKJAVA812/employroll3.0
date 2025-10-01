// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_punch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendancePunchAdapter extends TypeAdapter<AttendancePunch> {
  @override
  final int typeId = 0;

  @override
  AttendancePunch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendancePunch(
      sessionId: fields[0] as String,
      currentDate: fields[1] as String,
      address: fields[2] as String,
      clockingType: fields[3] as String,
      lat: fields[4] as String,
      lng: fields[5] as String,
      firstImei: fields[6] as String,
      secondImei: fields[7] as String,
      macAddress: fields[8] as String,
      deviceId: fields[9] as String,
      battery: fields[10] as String,
      image: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendancePunch obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.currentDate)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.clockingType)
      ..writeByte(4)
      ..write(obj.lat)
      ..writeByte(5)
      ..write(obj.lng)
      ..writeByte(6)
      ..write(obj.firstImei)
      ..writeByte(7)
      ..write(obj.secondImei)
      ..writeByte(8)
      ..write(obj.macAddress)
      ..writeByte(9)
      ..write(obj.deviceId)
      ..writeByte(10)
      ..write(obj.battery)
      ..writeByte(11)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendancePunchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
