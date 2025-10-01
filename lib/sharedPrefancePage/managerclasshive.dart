import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'managerclasshive.g.dart';

@HiveType(typeId: 0)
class ManagerClassHive extends HiveObject {
  @HiveField(0)
  late String userHive;
  @HiveField(1)
  late String passwordHive;
  @HiveField(3)
  late String sessionidHive;
}
