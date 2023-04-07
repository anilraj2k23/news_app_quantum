import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app_quantum/imports.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  User? _user;
  late SharedPreferences prefs;
  late ConnectivityResult connectivityResult;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    initPrefs();
    initConnectivity();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => connectivityResult = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('News Highlights'),
        bottom: PreferredSize(
            preferredSize: Size(double.infinity, 0.06.sh),
            child: Container(
              color: Colors.white,
              height: 55.h,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                      size: 25.r,
                      shadows: [
                        Shadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            offset: Offset(-1.w, 3.h))
                      ],
                    ),
                    hintText: 'Search in feed',
                    hintStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp),
                    border: InputBorder.none,
                  ),

                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ),
            )),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<NewsModel?>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          'An unexpected error occurred. Please try again later.'),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: Text('No data available.'),
                    );
                  } else {
                    final news = snapshot.data!;
                    final filteredNews = searchQuery.isEmpty
                        ? news.articles
                        : news.articles
                            .where((article) => article.title
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                            .toList();
                    return ListView.builder(
                      itemCount: filteredNews.length,
                      itemBuilder: (BuildContext context, int index) {
                        final timeDifference =
                            timeAgo(filteredNews[index].publishedAt);
                        return Container(
                          width: 0.6.sw,
                          height: 0.18.sh,
                          margin: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 10.h),
                          child: Card(
                            elevation: 5,
                            child: Stack(
                              children: [
                                Positioned(
                                    top: 10.h,
                                    left: 20.w,
                                    child: Row(
                                      children: [
                                        Text(
                                          timeDifference,
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.black54),
                                        ),
                                        SizedBox(
                                          width: 6.w,
                                        ),
                                        Text(
                                          filteredNews[index].source.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )),
                                Positioned(
                                    top: 30.h,
                                    left: 20.w,
                                    child: SizedBox(
                                      width: 0.5.sw,
                                      child: Text(
                                        maxLines: 3,
                                        softWrap: true,
                                        filteredNews[index].title,
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                Positioned(
                                    top: 80.h,
                                    left: 20.w,
                                    child: SizedBox(
                                      width: 0.5.sw,
                                      child: Text(
                                        maxLines: 3,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        filteredNews[index].description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: 20.h,
                                    right: 15.w,
                                    child: Image.network(
                                      filteredNews[index].urlToImage ?? '',
                                      width: 100.w,
                                      height: 100.h,
                                      errorBuilder: (ctx, obj, trace) =>
                                          const SizedBox(),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.brown])),
              currentAccountPicture: CircleAvatar(
                  foregroundImage: NetworkImage(_user?.photoURL ??
                      'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png')),
              accountName: Text(_user?.displayName ?? ''),
              accountEmail: Text('ID: ${_user?.uid.substring(0, 3)}')),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: 29.r,
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 18.sp),
                ),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  try {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                      }
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthenticationScreen()));
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e.toString());
                    }
                  }
                },
              )),
        ],
      ),
    );
  }

  Future<NewsModel?> fetchData() async {
    if (connectivityResult == ConnectivityResult.none) {
      final cachedData = prefs.getString('news_data');

      if (cachedData != null) {
        return NewsModel.fromJson(jsonDecode(cachedData));
      } else {
        return null;
      }
    } else {
      final data = await ApiManagement.fetchNews(context);

      if (data != null) {
        prefs.setString('news_data', jsonEncode(data.toJson()));
        return data;
      } else {
        final cachedData = prefs.getString('news_data');

        if (cachedData != null) {
          return NewsModel.fromJson(jsonDecode(cachedData));
        } else {
          return null;
        }
      }
    }
  }
}
