import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app_quantum/imports.dart';
class LoginTab extends StatefulWidget {
  const LoginTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizedBox fieldSpace = SizedBox(height: 16.h);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              height: 0.7.sh,
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
                      'Sign into Your\nAccount',
                      style: TextStyle(
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF80001)),
                    ),
                    fieldSpace,
                    BuildAuthTextFields(
                        fieldController: emailController,
                        keyboardType: TextInputType.emailAddress,
                        fieldIcon: Icons.mail,
                        labelText: 'Email'),
                    fieldSpace,
                    BuildAuthTextFields(
                        fieldController: passwordController,
                        keyboardType: TextInputType.text,
                        fieldIcon: Icons.lock,
                        labelText: 'Password'),
                    fieldSpace,
                    const Center(child: Text('Login with')),

                    SizedBox(
                      height: 20.h,
                    ),

                    Center(
                      child: GestureDetector(
                        // Sign-out from google/ clear credentials in shared preference.
                        onTap: logout,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : Image.asset(
                                'assets/icons/google-logo.png',
                                height: 40.0.h,
                              ),
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            widget._tabController.animateTo(1);
                          },
                          child: const Text('Register Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            var isMatched = await canLogIn(
                email: emailController.text, password: passwordController.text);

            if (isMatched) {
              if (context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenHome()));
              }
            } else {
              if (context.mounted) {
                //Shows a snack-bar if credentials didn't matched
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Invalid email or password'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFF0000),
              borderRadius:
                  BorderRadiusDirectional.vertical(top: Radius.circular(30.r)),
            ),
            width: double.infinity,
            height: 80.h,
            child: Center(
                child: Text(
              'LOGIN',
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            )),
          ),
        ),
      ],
    );
  }

  Future<void> logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Failed to sign in with Google.');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Returns true credentials matches from shared preference.
  Future<bool> canLogIn(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    return (email == savedEmail && password == savedPassword);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
