import 'package:account_app/pages/book_detail.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '家計簿',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookDetail(),
    );
  }
}
