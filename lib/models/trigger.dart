import 'package:hive/hive.dart';

part 'trigger.g.dart';

@HiveType(typeId: 1)
class Trigger extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  List<bool> reason;

  Trigger({
    required this.type,
    required this.reason,
  });
}
