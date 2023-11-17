import 'package:flutter/material.dart';
import '../../constants/styles.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: const Column(children: [Text('Setting tab')]),
    );
  }
}
