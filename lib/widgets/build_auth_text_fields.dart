import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class BuildAuthTextFields extends StatelessWidget {
  BuildAuthTextFields({
    super.key,
    required this.fieldController,
    required this.keyboardType,
    required this.fieldIcon,
    required this.labelText,
    this.obscureField=false


  });

  final TextEditingController fieldController;
  final TextInputType keyboardType;
  final IconData fieldIcon;
  final String labelText;
  bool obscureField;

  @override
  Widget build(BuildContext context) {
    return TextField(obscureText: obscureField,
      controller: fieldController,
      decoration: InputDecoration(
          suffixIcon: Icon(
            fieldIcon,
            color: Colors.red,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold)),
    );
  }
}

// Handle
