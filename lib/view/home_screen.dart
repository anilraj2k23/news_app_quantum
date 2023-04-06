import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app_quantum/models/news_model.dart';
import 'package:news_app_quantum/services/news_service.dart';
import 'package:news_app_quantum/utils/date_calculate_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  late SharedPreferences prefs;
  late ConnectivityResult connectivityResult;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    initPrefs();
    initConnectivity();
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
      appBar: AppBar(
        title: Text('News Highlights'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.blueAccent,
              height: 50.h,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search news...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) => setState(() => searchQuery = value),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<NewsModel?>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'An unexpected error occurred. Please try again later.'),
                    );
                  } else if (snapshot.data == null) {
                    return Center(
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
                                          style: TextStyle(
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
                                Positioned(top: 20.h,right: 15.w,
                                    child: Image.network(
                                  filteredNews[index].urlToImage ?? '',
                                  width: 100.w,
                                  height: 100.h,
                                  errorBuilder:(ctx, obj, trace)=>const SizedBox(),
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
