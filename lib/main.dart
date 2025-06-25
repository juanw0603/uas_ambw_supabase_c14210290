import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pmrmpkismzisvkgqnaso.supabase.co', // Ganti
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtcm1wa2lzbXppc3ZrZ3FuYXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA4MzczNjIsImV4cCI6MjA2NjQxMzM2Mn0.4xLodZb4budqK6Zu3iYksV_v6MLIjrnweD3tEOiBZr0', // Ganti
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstOpen = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkFirstInstallAndSession();
  }

  Future<void> checkFirstInstallAndSession() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstOpen = prefs.getBool('first_open') ?? true;
      _isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Recipe Keeper',
      debugShowCheckedModeBanner: false,
      home: _isFirstOpen
          ? GetStartedScreen()
          : _isLoggedIn
              ? HomeScreen()
              : LoginScreen(),
    );
  }
}
