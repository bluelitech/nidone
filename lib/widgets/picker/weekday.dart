import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import '../../constants/constants.dart';

class WeekdayPicker extends StatefulWidget {
  final List<bool> selectedWeekdays;

  WeekdayPicker({Key? key, required this.selectedWeekdays});

  @override
  _WeekdayPickerState createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  late List<bool> selectedWeekdays;

  @override
  void initState() {
    super.initState();
    selectedWeekdays = widget.selectedWeekdays;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 30.0),
            child: const Text('曜日を選択してください', style: HomeStyles.dialogTitle),
          ),
          Wrap(
            children: List<Widget>.generate(AlarmConst.days.length, (index) {
              return FilterChip(
                label: Text(AlarmConst.days[index]),
                selected: selectedWeekdays[index],
                selectedColor: Colors.blue,
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    selectedWeekdays[index] = selected;
                  });
                },
              );
            }),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedWeekdays),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
