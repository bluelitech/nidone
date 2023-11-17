import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import '../../constants/constants.dart';

class SnoozeTimePicker extends StatefulWidget {
  final int selectedSnoozeTime;

  SnoozeTimePicker({Key? key, required this.selectedSnoozeTime});

  @override
  _SnoozeTimePickerState createState() => _SnoozeTimePickerState();
}

class _SnoozeTimePickerState extends State<SnoozeTimePicker> {
  late int selectedSnoozeTime;

  @override
  void initState() {
    super.initState();
    selectedSnoozeTime = widget.selectedSnoozeTime;
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
            child: const Text('スヌーズ', style: HomeStyles.dialogTitle),
          ),
          DropdownButton<int>(
            value: selectedSnoozeTime,
            items: List.generate(60, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1} 分'),
              );
            }),
            onChanged: (int? newValue) {
              if (newValue != null) {
                selectedSnoozeTime = newValue;
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedSnoozeTime),
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
