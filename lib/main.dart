import 'package:flutter/material.dart';
import '/features/profile/profile_screen_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Profile(),
    );
  }
}