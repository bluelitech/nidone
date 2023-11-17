import 'package:flutter/material.dart';
import '../../constants/styles.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const Column(children: [Text('History Tab')]),
    );
  }
}
