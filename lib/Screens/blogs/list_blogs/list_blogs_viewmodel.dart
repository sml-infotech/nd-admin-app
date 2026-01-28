import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/blog_model/blog_list_response.dart';
import 'package:nammadaiva_dashboard/service/blog_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBlogsViewmodel extends ChangeNotifier {
  BlogService blogService = BlogService();
  int page = 1;
  final int limit = 10;
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  List<Blog> blogs = [];

  Future<void> fetchBlogs({bool refresh = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString('language') ?? 'en';

      if (refresh) {
        page = 1;
        blogs.clear();
        hasMore = true;
      }

      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      final response = await blogService.getBlogs(
        page: page,
        limit: limit,
        search: searchController.text,
        language: language,
      );

      final List<Blog> newData = response.blogs;

      if (newData.isNotEmpty) {
        if (page == 1) {
          blogs = newData;
        } else {
          blogs.addAll(newData);
        }

        if (newData.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching blogs: $e");
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }
}
