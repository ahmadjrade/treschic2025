// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [Text('search')],
        ),
      )),
    );
  }
}
