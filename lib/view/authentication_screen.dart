import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_quantum/widgets/buil_register_tab.dart';
import 'package:news_app_quantum/widgets/build_login_tab.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);

  Decoration tabBarDecoration = const BoxDecoration(
      borderRadius:
          BorderRadiusDirectional.only(bottomEnd: Radius.circular(30)),
      color: Colors.white);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r))),
        title: Row(
          children: [
            Text('Social', style: TextStyle(fontSize: 25.sp)),
            SizedBox(
              width: 2.w,
            ),
            Text(
              'X',
              style: TextStyle(fontSize: 40.sp),
            )
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size(50.w, 60.h),
          child: TabBar(
            indicator: tabBarDecoration,
            indicatorPadding: EdgeInsets.all(1.w),
            labelColor: Colors.black54,
            unselectedLabelColor: Colors.white,
            controller: _tabController,
            tabs: const [
              Tab(text: 'LOGIN'),
              Tab(text: 'SIGN UP'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Login Tab
          LoginTab(tabController: _tabController),
          // Sign Up Tab
          RegisterTab(tabController: _tabController)
        ],
      ),
    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
