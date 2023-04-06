import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterTab extends StatefulWidget {
  const RegisterTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  String? _countryCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(30.r),
                color: Colors.white),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create an\nAccount',
                    style: TextStyle(
                        fontSize: 24.0.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF80001)),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.red,
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      CountryCodePicker(
                        showDropDownButton: true,
                        onChanged: _onCountryChange,
                        initialSelection: 'IN',
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        alignLeft: false,
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.phone,
                                color: Colors.red,
                              ),
                              labelText: 'Contact No',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          side: BorderSide(color: Colors.red, width: 2.w),
                          value: false,
                          onChanged: (value) {}
                          // Handle checkbox changes
                          ),
                      Text('I agree with'),
                      TextButton(
                        onPressed: () {},
                        child: Text(' terms and conditions',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2.w,
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an Account ?"),
                      TextButton(
                        onPressed: () {
                          widget._tabController.animateTo(0);
                        },
                        child: Text('Sign In!'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000),
              borderRadius:
                  BorderRadiusDirectional.vertical(top: Radius.circular(30.r)),
            ),
            width: double.infinity,
            height: 80.h,
            child: Center(
                child: Text(
              'REGISTER',
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            )),
          ),
        ),
      ],
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.toString();
    });
    //TODO : manipulate the selected country code here
    print("New Country selected: " + countryCode.toString());
  }

  Future<void> saveUserData(
      {required String username,
      required String email,
      required String phone,
      required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);
  }
}

// Handle
