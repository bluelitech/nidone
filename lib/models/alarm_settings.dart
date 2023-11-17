import 'package:hive/hive.dart';

import 'trigger.dart';

part 'alarm_settings.g.dart';

@HiveType(typeId: 0)
class AlarmSettings extends HiveObject {
  @HiveField(0)
  int wakeupHour;

  @HiveField(1)
  int wakeupMinute;

  @HiveField(2)
  int limitHour;

  @HiveField(3)
  int limitMinute;

  @HiveField(4)
  Trigger trigger;

  @HiveField(5)
  List<bool> weekdays;

  @HiveField(6)
  bool isEnabled;

  AlarmSettings({
    required this.wakeupHour,
    required this.wakeupMinute,
    required this.limitHour,
    required this.limitMinute,
    required this.trigger,
    required this.weekdays,
    this.isEnabled = true,
  });
}
