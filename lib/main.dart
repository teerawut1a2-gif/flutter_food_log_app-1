import 'package:flutter/material.dart';
import 'package:flutter_food_log_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main()
//----------------Setting Config Supabase----------------
async{
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mwqmzzblyxsbyguwmgok.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im13cW16emJseXhzYnlndXdtZ29rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM3ODc5MjIsImV4cCI6MjA4OTM2MzkyMn0.PLs08YSZ7fzgyBJtF_dUii16dk63luUMUs_uOKAi5GY',
  );
//-------------------------------------------------------
  runApp(
    FlutterFoodLogApp()
    );
}
 
class FlutterFoodLogApp extends StatefulWidget {
  const FlutterFoodLogApp({super.key});
 
  @override
  State<FlutterFoodLogApp> createState() => _FlutterFoodLogAppState();
}
 
class _FlutterFoodLogAppState extends State<FlutterFoodLogApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme
        )
      ),
    );
  }
}