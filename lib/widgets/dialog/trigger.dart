import 'package:flutter/material.dart';
import '../../constants/styles.dart';
import '../../constants/constants.dart';

class TriggerDialog extends StatefulWidget {
  final List<bool> selectedTriggers;

  TriggerDialog({Key? key, required this.selectedTriggers});

  @override
  _TriggerDialogState createState() => _TriggerDialogState();
}

class _TriggerDialogState extends State<TriggerDialog> {
  late List<bool> selectedTriggers;

  @override
  void initState() {
    super.initState();
    selectedTriggers = widget.selectedTriggers;
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
            child: const Text('二度寝保険の作動条件を選択してください', style: HomeStyles.dialogTitle),
          ),
          SingleChildScrollView(
            child: ListBody(
              children: AlarmConst.triggers.asMap().entries.map((entry) {
                int index = entry.key;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: selectedTriggers[index],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedTriggers[index] = value!;
                        });
                      },
                    ),
                    Text(AlarmConst.triggers[index]),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(selectedTriggers),
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
