import 'package:flutter/material.dart';

import '../../constants/styles.dart';
import '../../widgets/current_time_widget.dart';
import '../../widgets/sleeping_button_widget.dart';

class Sleep extends StatefulWidget {
  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  void onPressedSleepingButton(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CurrentTimeWidget(
                      textStyle: SleepStyles.currentTimeText,
                    ),
                    Text('電源を切らないでください'),
                  ],
                ),
              ),
              SleepingButton(
                text: '起きる',
                onPressed: () {
                  onPressedSleepingButton(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
