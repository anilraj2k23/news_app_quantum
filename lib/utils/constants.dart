import 'package:flutter/material.dart';

class ApiConstants{
  static const String apiEndPoint = 'https://newsapi.org/v2/everything?q=apple&from=2023-04-05&to=2023-04-05&sortBy=popularity&apiKey=';
  static const String apiKey = '7418a1716d4341979eb30c37478e175a';
}
class AppColors{
  static MaterialColor primarySwatchColor = const MaterialColor(
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
}
