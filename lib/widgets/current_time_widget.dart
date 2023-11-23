import 'package:flutter/material.dart';
import 'dart:async';

class CurrentTimeWidget extends StatefulWidget {
  final TextStyle textStyle;

  const CurrentTimeWidget({super.key, this.textStyle = const TextStyle(fontSize: 24)});

  @override
  _CurrentTimeWidgetState createState() => _CurrentTimeWidgetState();
}

class _CurrentTimeWidgetState extends State<CurrentTimeWidget> {
  late DateTime _currentTime;
  late Timer _timer;

  @override
  void initState() {
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _getTime() {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  Widget _buidTimePart(String part, TextStyle style) {
    return Baseline(
      baseline: part == ':' ? style.fontSize! * 0.8 : style.fontSize!,
      baselineType: TextBaseline.alphabetic,
      child: Text(part, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    String hour = _currentTime.hour.toString().padLeft(2, '0');
    String minute = _currentTime.minute.toString().padLeft(2, '0');
    String second = _currentTime.second.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        _buidTimePart(hour, widget.textStyle),
        _buidTimePart(':', widget.textStyle),
        _buidTimePart(minute, widget.textStyle),
        _buidTimePart(':', widget.textStyle),
        _buidTimePart(second, widget.textStyle),
      ],
    );
  }
}
