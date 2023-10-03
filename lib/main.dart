import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './blog_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BlogListScreen(),
    );
  }
}
