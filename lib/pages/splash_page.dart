import 'dart:async';

import 'package:expense_tracker/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static const String route = '/splash';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () { 
      Navigator.pushReplacementNamed(context, TabsPage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calculate, size: 64,),
            SizedBox(height: 8,),
            Text("Getting your data optimized...", style: TextStyle(
              fontSize: 14
            ),),
            SizedBox(height: 24,),
            CircularProgressIndicator(),
          ],
        ), 
      ),
    );
  }
}