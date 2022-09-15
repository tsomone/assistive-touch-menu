import 'package:flutter/material.dart';

class TestPageTwo extends StatelessWidget {
  const TestPageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Second Page Screen'),
      ),
    );
  }
}
