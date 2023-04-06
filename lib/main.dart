import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_quantum/view/authentication_screen.dart';
import 'package:news_app_quantum/view/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72, 850.90),
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(debugShowCheckedModeBanner: false,
          title: 'News App',
          theme: ThemeData(
            primarySwatch: primarySwatchColor
          ),
          routes: {
            '/': (BuildContext ctx) => AuthenticationScreen(),
            '/home': (BuildContext ctx) => const ScreenHome(),
          },
          initialRoute: '/home',
        );
      },
    );
  }
}
MaterialColor primarySwatchColor = const MaterialColor(
  0xFFFF0000,
  <int, Color>{
    50: Color(0xFFFFEBEE),
    100: Color(0xFFFFCDD2),
    200: Color(0xFFEF9A9A),
    300: Color(0xFFE57373),
    400: Color(0xFFEF5350),
    500: Color(0xFFF44336),
    600: Color(0xFFE53935),
    700: Color(0xFFD32F2F),
    800: Color(0xFFC62828),
    900: Color(0xFFB71C1C),
  },
);