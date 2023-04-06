import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LoginTab extends StatelessWidget {
  const LoginTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(30.r),
                color: Colors.white),
            child: Padding(
              padding:
              EdgeInsets.symmetric(vertical: 16.h, horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign into Your\nAccount',
                    style: TextStyle(
                        fontSize: 24.0.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF80001)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.mail,
                          color: Colors.red,
                        ),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.lock, color: Colors.red),
                        labelText: 'Password',
                        counter: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ),
                    ),
                  ),
                  Center(child: Text('Login with')),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/icons/google-logo.png',
                      height: 40.0.h,
                    ),
                  ),
                  SizedBox(height: 10.0.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          _tabController.animateTo(1);
                        },
                        child: Text('Register Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(onTap: (){},
          child: Container(    margin: EdgeInsets.symmetric( horizontal: 1.w),
            decoration: BoxDecoration(
            color:  const Color(0xFFFF0000),
            borderRadius:BorderRadiusDirectional.vertical(top:
            Radius.circular(30.r)),
          ),
            width: double.infinity,

            height: 80.h,
            child: Center(
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white,fontSize: 18.sp),
                )),
          ),
        ),
      ],
    );
  }
}
