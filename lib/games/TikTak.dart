import 'package:flutter/material.dart';

class TikTak extends StatefulWidget {
  const TikTak({Key? key}) : super(key: key);

  @override
  _TikTakState createState() => _TikTakState();
}

class _TikTakState extends State<TikTak> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TickTak"),
      ),
    );
  }
}
