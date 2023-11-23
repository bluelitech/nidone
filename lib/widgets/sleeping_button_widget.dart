import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class SleepingButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  const SleepingButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  _SleepingButtonState createState() => _SleepingButtonState();
}

class _SleepingButtonState extends State<SleepingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          widget.onPressed();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.grey[850],
          textStyle: SleepStyles.sleepingButtonText,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
