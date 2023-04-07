import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_quantum/widgets/build_auth_text_fields.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _countryCode = '';

  bool _isChecked = false;

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
                      'Create an\nAccount',
                      style: TextStyle(
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF80001)),
                    ),
                    fieldSpace,
                    BuildAuthTextFields(
                      fieldController: nameController,
                      keyboardType: TextInputType.name,
                      labelText: 'Name',
                      fieldIcon: Icons.person,
                    ),
                    fieldSpace,
                    BuildAuthTextFields(
                        fieldController: emailController,
                        keyboardType: TextInputType.emailAddress,
                        fieldIcon: Icons.mail,
                        labelText: 'Email'),
                    fieldSpace,
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
                            child: BuildAuthTextFields(
                                fieldController: phoneController,
                                keyboardType: TextInputType.phone,
                                fieldIcon: Icons.phone,
                                labelText: 'Contact No')),
                      ],
                    ),
                    fieldSpace,
                    BuildAuthTextFields(fieldController: passwordController,
                        keyboardType: TextInputType.text,
                        fieldIcon: Icons.lock,
                        labelText: 'Password',
                    obscureField: true,),

                    fieldSpace,
                    Row(
                      children: [
                        Checkbox(
                            side: BorderSide(color: Colors.red, width: 2.w),
                            value: _isChecked,
                            onChanged: (value) {
                              setState(() {
                                _isChecked = !_isChecked;
                              });
                            }),
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
                    fieldSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an Account ?"),
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
        ),
        GestureDetector(
          onTap: () async {
            await saveUserData(
                username: nameController.text,
                email: emailController.text,
                phone: _countryCode + phoneController.text,
                password: passwordController.text);

            if (context.mounted) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: const Text('Status'),
                        content: const Text('User registration successful'),
                        actions: [
                          Center(
                            child: FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget._tabController.animateTo(0);
                                },
                                child: const Text('OK')),
                          )
                        ],
                      ));
            }
          },
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
    print("New Country selected: $countryCode");
  }

  Future<void> saveUserData({required String username,
    required String email,
    required String phone,
    required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('password', password);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }
}
