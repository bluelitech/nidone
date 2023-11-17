import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nidone/constants/constants.dart';
import 'package:nidone/models/alarm_settings.dart';
import 'package:nidone/screen/home/add.dart';
import '../../constants/styles.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void checkDelete(BuildContext context, AlarmSettings alarmSettings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('確認'),
          content: const Text('アラームを削除してよろしいですか？'),
          actions: <Widget>[
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('削除'),
              onPressed: () {
                alarmSettings.delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<AlarmSettings> alarmSettingsBox = Hive.box<AlarmSettings>('alarmSettings');
    return Column(children: <Widget>[
      Container(
        margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('アラーム', style: headerTextStyle),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddAlarm(alarmKey: -1)),
                  );
                },
                child: const Text(
                  '追加 ＋',
                  style: headerTextButtonStyle,
                ),
              )
            ],
          ),
        ]),
      ),
      ValueListenableBuilder(
        valueListenable: alarmSettingsBox.listenable(),
        builder: (context, Box<AlarmSettings> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('アラームがありません'));
          }

          return Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                final AlarmSettings alarmSettings = box.getAt(index)!;
                return ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  tileColor: Colors.black,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${alarmSettings.wakeupHour.toString().padLeft(2, '0')}:${alarmSettings.wakeupMinute.toString().padLeft(2, '0')}',
                        style: AlarmStyles.wakeupText,
                      ),
                      Switch(
                        value: alarmSettings.isEnabled,
                        onChanged: (bool newValue) {
                          alarmSettings.isEnabled = newValue;
                          alarmSettings.save();
                        },
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '二度寝保険　${alarmSettings.limitHour.toString().padLeft(2, '0')}:${alarmSettings.limitMinute.toString().padLeft(2, '0')}',
                              style: AlarmStyles.limitText,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => AddAlarm(alarmKey: alarmSettings.key)),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.amber,
                                ),
                                IconButton(
                                  onPressed: () {
                                    checkDelete(context, alarmSettings);
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alarmSettings.trigger.type == 'and' ? 'すべての条件を満たしたときに作動' : 'いずれか1つの条件を満たしたときに作動'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List<Widget>.generate(AlarmConst.triggers.length, (index) {
                                return alarmSettings.trigger.reason[index] ? Text('　・${AlarmConst.triggers[index]}') : Container();
                              }),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Wrap(
                          spacing: 0,
                          children: alarmSettings.weekdays
                              .asMap()
                              .entries
                              .map((entry) => Chip(
                                    label: Text(AlarmConst.days[entry.key]),
                                    backgroundColor: entry.value ? Colors.blue : Colors.grey[800],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
            ),
          );
        },
      ),
    ]);
  }
}
