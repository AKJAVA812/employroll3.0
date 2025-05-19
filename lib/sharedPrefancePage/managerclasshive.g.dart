// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managerclasshive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManagerClassHiveAdapter extends TypeAdapter<ManagerClassHive> {
  @override
  final int typeId = 0;

  @override
  ManagerClassHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ManagerClassHive()
      ..userHive = fields[0] as String
      ..passwordHive = fields[1] as String
      ..sessionidHive = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, ManagerClassHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userHive)
      ..writeByte(1)
      ..write(obj.passwordHive)
      ..writeByte(3)
      ..write(obj.sessionidHive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManagerClassHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
