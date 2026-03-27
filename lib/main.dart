import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'exercises/exercise_1_room_card.dart';
import 'exercises/exercise_2_room_list_bloc.dart';
import 'exercises/exercise_3_room_screen_mini.dart';
import 'exercises/exercise_5_performance_analysis.dart';

void main() {
  runApp(DevicePreview(

      enabled: !kReleaseMode,

      builder:(context) =>  const AssessmentApp()));
}

class AssessmentApp extends StatelessWidget {
  const AssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UTD Software — Flutter Assessment',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF32e5ac),
          useMaterial3: true,
        ),
        home: RoomScreenMini(roomId: 1,),
      ),
    );
  }
}

class AssessmentHomePage extends StatelessWidget {
  const AssessmentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Assessment')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.code, size: 64, color: Color(0xFF32e5ac)),
              SizedBox(height: 16),
              Text('UTD Software', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Flutter Developer Assessment', style: TextStyle(fontSize: 18, color: Colors.grey)),
              SizedBox(height: 32),
              Text(
                'See the exercises/ directory for your tasks.\nOpen questionnaire/index.html in a browser\nto complete the questionnaire.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
