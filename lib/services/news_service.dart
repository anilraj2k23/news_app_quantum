import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_quantum/models/news_model.dart';
import 'package:news_app_quantum/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiManagement {
  static Future<NewsModel> fetchNews(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('news_data');

      if (cachedData != null) {
        // if there is cached data, parse and return it
        return newsModelFromJson(cachedData);
      }

      // if there is no cached data or the cached data is outdated,
      // fetch new data from the News API
      var url = Uri.parse(ApiConstants.apiEndPoint + ApiConstants.apiKey);
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = response.body;
        final model = newsModelFromJson(responseData);

        // save the new data to shared preferences
        prefs.setString('news_data', responseData);

        return model;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to retrieve data. Please try again later.'),
            ),
          );
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Network connection error. Please check your internet connection and try again.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
    return NewsModel(status: 'error', totalResults: 0, articles: []);
  }
}
