import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_quantum/imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392.72, 850.90),
      minTextAdapt: true,
      builder: (BuildContext context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'News App',
            theme: ThemeData(primarySwatch: AppColors.primarySwatchColor),

            home: user != null ? const ScreenHome() : AuthenticationScreen());
      },
    );
  }
  // Check the Firebase user authentication status.
  void checkAuthStatus() async {
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
      setState(() {
        user = currentUser;
      });
    });
  }
}


