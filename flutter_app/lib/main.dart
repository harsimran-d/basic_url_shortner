import 'package:flutter/material.dart';
import 'package:url_shortner/shorten_form.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: ShortenForm(),
          ),
        ),
      ),
    );
  }
}
