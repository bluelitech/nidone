import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nidone/models/alarm_settings.dart';
import 'package:nidone/models/trigger.dart';
import 'package:nidone/widgets/dialog/trigger.dart';

import '../../constants/styles.dart';
import '../../constants/constants.dart';
import '../../widgets/picker/weekday.dart';
import '../../widgets/picker/snooze.dart';

// ignore: must_be_immutable
class AddAlarm extends StatefulWidget {
  final int alarmKey;

  AddAlarm({Key? key, required this.alarmKey});

  @override
  _AddAlarmState createState() => _AddAlarmState(alarmKey);
}

class _AddAlarmState extends State<AddAlarm> {
  final int alarmKey;
  final Box<AlarmSettings> alarmSettingsBox = Hive.box<AlarmSettings>('alarmSettings');
  TimeOfDay? _wakeupTime;
  TimeOfDay? _limitTime;
  late List<bool> selectedWeekdays;
  late List<bool> selectedTriggers;
  int selectedSnoozeTime = 5;

  _AddAlarmState(this.alarmKey);

  @override
  void initState() {
    super.initState();
    if (alarmKey == -1) {
      selectedWeekdays = List.generate(AlarmConst.days.length, (index) => false);
      selectedTriggers = List.generate(AlarmConst.triggers.length, (index) => false);
    } else {
      final beforeAlarmSetting = alarmSettingsBox.get(alarmKey);
      _wakeupTime = TimeOfDay(
        hour: beforeAlarmSetting!.wakeupHour,
        minute: beforeAlarmSetting.wakeupMinute,
      );
      _limitTime = TimeOfDay(
        hour: beforeAlarmSetting.limitHour,
        minute: beforeAlarmSetting.limitMinute,
      );
      selectedWeekdays = [...beforeAlarmSetting.weekdays];
      selectedTriggers = [...beforeAlarmSetting.trigger.reason];
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, target) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (target == 'wakeup' ? _wakeupTime : _limitTime) ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _wakeupTime) {
      setState(() {
        switch (target) {
          case 'wakeup':
            _wakeupTime = picked;
            break;
          case 'limit':
            _limitTime = picked;
            break;
        }
      });
    }
  }

  void handleWeekdaySelection(List<bool> selections) {
    setState(() {
      selectedWeekdays = selections;
    });
  }

  void handleTriggerSelection(List<bool> selections) {
    setState(() {
      selectedTriggers = selections;
    });
  }

  void handleSnoozeTimeSelection(int selection) {
    setState(() {
      selectedSnoozeTime = selection;
    });
  }

  void saveAlarm(BuildContext context) {
    if (alarmKey == -1) {
      final alarmSettings = AlarmSettings(
        wakeupHour: _wakeupTime!.hour,
        wakeupMinute: _wakeupTime!.minute,
        limitHour: _limitTime!.hour,
        limitMinute: _limitTime!.minute,
        trigger: Trigger(
          type: 'and',
          reason: selectedTriggers,
        ),
        weekdays: selectedWeekdays,
        isEnabled: true,
      );
      alarmSettingsBox.add(alarmSettings);
    } else {
      final alarmSetting = alarmSettingsBox.get(alarmKey);
      alarmSetting?.wakeupHour = _wakeupTime!.hour;
      alarmSetting?.wakeupMinute = _wakeupTime!.minute;
      alarmSetting?.limitHour = _limitTime!.hour;
      alarmSetting?.limitMinute = _limitTime!.minute;
      alarmSetting?.trigger = Trigger(
        type: 'and',
        reason: selectedTriggers,
      );
      alarmSetting?.weekdays = selectedWeekdays;
      alarmSetting?.save();
    }
    Navigator.of(context).pop();
  }

  void cancelAlarm(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
          child: const Center(
            child: Text('アラームを追加', style: HomeStyles.title),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
          child: Column(children: <Widget>[
            // ------------------------------------------------------
            // 時刻
            // ------------------------------------------------------
            InkWell(
              onTap: () => _selectTime(context, 'wakeup'),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('時刻', style: HomeStyles.rowText),
                    Row(children: [
                      Text(
                        _wakeupTime != null ? _wakeupTime!.format(context) : '--:--',
                        style: HomeStyles.rowValue,
                      ),
                    ])
                  ],
                ),
              ),
            ),
            const Divider(height: 0, color: Colors.white),
            // ------------------------------------------------------
            // 二度寝保険の作動時刻
            // ------------------------------------------------------
            InkWell(
              onTap: () => _selectTime(context, 'limit'),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('二度寝保険', style: HomeStyles.rowText),
                    Row(children: [
                      Text(
                        _limitTime != null ? _limitTime!.format(context) : '--:--',
                        style: HomeStyles.rowValue,
                      ),
                    ])
                  ],
                ),
              ),
            ),
            // ------------------------------------------------------
            // 二度寝保険の作動条件
            // ------------------------------------------------------
            InkWell(
              onTap: () async {
                final result = await showTriggerDialog(context, selectedTriggers);
                if (result != null) {
                  handleTriggerSelection(result);
                }
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 5.0, 10.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    selectedTriggers.every((isSelected) => !isSelected)
                        ? const Text('無効', style: HomeStyles.rowTextSmall)
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List<Widget>.generate(AlarmConst.triggers.length, (index) {
                              return selectedTriggers[index] ? Text('・${AlarmConst.triggers[index]}', style: HomeStyles.rowTextSmall) : Container();
                            }),
                          )
                  ],
                ),
              ),
            ),
            const Divider(height: 0, color: Colors.white),
            // ------------------------------------------------------
            // 繰り返し（曜日）
            // ------------------------------------------------------
            InkWell(
              onTap: () async {
                final result = await showWeekdayPickerDialog(context, selectedWeekdays);
                if (result != null) {
                  handleWeekdaySelection(result);
                }
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('繰り返し', style: HomeStyles.rowText),
                    selectedWeekdays.every((isSelected) => !isSelected)
                        ? const Text('なし', style: HomeStyles.rowValue)
                        : Row(
                            children: List<Widget>.generate(AlarmConst.days.length, (index) {
                              return selectedWeekdays[index] ? Text(AlarmConst.days[index], style: HomeStyles.rowValue) : Container();
                            }),
                          ),
                  ],
                ),
              ),
            ),
            // const Divider(height: 0, color: Colors.white),
            // ------------------------------------------------------
            // スヌーズ
            // ------------------------------------------------------
            // InkWell(
            //   onTap: () async {
            //     final result = await showSnoozeTimePickerDialog(context, selectedSnoozeTime);
            //     if (result != null) {
            //       handleSnoozeTimeSelection(result);
            //     }
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         const Text('スヌーズ', style: HomeStyles.rowText),
            //         _snooze == 0 ? const Text('なし', style: HomeStyles.rowValue) : Text('$_snooze分', style: HomeStyles.rowValue),
            //       ],
            //     ),
            //   ),
            // ),
          ]),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  cancelAlarm(context);
                },
                child: const Text('キャンセル', style: HomeStyles.appBarText),
              ),
              TextButton(
                onPressed: () {
                  saveAlarm(context);
                },
                child: const Text('保存', style: HomeStyles.appBarText),
              ),
            ],
          ),
        ),
      ])),
    );
  }
}

Future<List<bool>?> showWeekdayPickerDialog(BuildContext context, List<bool> selectedWeekdays) async {
  return showDialog<List<bool>>(
    context: context,
    builder: (context) {
      return Dialog(
        child: WeekdayPicker(selectedWeekdays: selectedWeekdays),
      );
    },
  );
}

Future<List<bool>?> showTriggerDialog(BuildContext context, List<bool> selectedTriggers) async {
  return showDialog<List<bool>>(
    context: context,
    builder: (context) {
      return Dialog(
        child: TriggerDialog(selectedTriggers: selectedTriggers),
      );
    },
  );
}

Future<int?> showSnoozeTimePickerDialog(BuildContext context, int selectedSnoozeTime) async {
  return showDialog<int>(
    context: context,
    builder: (context) {
      return Dialog(
        child: SnoozeTimePicker(selectedSnoozeTime: selectedSnoozeTime),
      );
    },
  );
}
