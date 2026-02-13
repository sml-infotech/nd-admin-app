import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/temple/temple_listmodel.dart';
import 'package:nammadaiva_dashboard/service/temple_servicr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempleViewModel extends ChangeNotifier {
  List<Temple> temples = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  final TextEditingController searchController = TextEditingController();
  final TempleService authService = TempleService();
  Timer? _debounce;

  int page = 1;
  int limit = 10;

  Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'en';
  }

  Future<void> fetchTemples({bool refresh = false}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var language = prefs.getString('language') ?? 'en';
      print("Fetching temples with language: $language");

      if (page == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }
      notifyListeners();

      if (refresh) {
        temples.clear();
        page = 1;
        hasMore = true;
        isLoadingMore = false;
      }

      final response = await authService.getTemples(
        page: page,
        limit: limit,
        search: searchController.text,
        language: "kn",
      );

      if (response.data != null && response.data!.isNotEmpty) {
        if (searchController.text.isNotEmpty) {
          temples = response.data!;
          hasMore = false;
        } else {
          if (response.data!.length < limit) {
            hasMore = false;
          } else {
            page++;
          }
        }

        // for (var temple in response.data!) {
        //   if (temple.translations != null && temple.translations!.isNotEmpty) {
        //     for (var translation in temple.translations!) {
        //       temples.add(
        //         Temple(
        //           id: temple.id,
        //           name: language == "kn" ? translation.name : temple.name,
        //           address: language == "kn" ? translation.address : temple.address,
        //           city: language == "kn" ? translation.city : temple.city,
        //           state: language == "kn" ? translation.state : temple.state,
        //           pincode: temple.pincode,
        //           architecture: language == "kn" ? "": temple.architecture,
        //           phoneNumber: temple.phoneNumber,
        //           email: temple.email,
        //           description: language == "kn" ? translation.description : temple.description,
        //           createdAt: temple.createdAt,
        //           updatedAt: temple.updatedAt,
        //           deities: language == "kn" ? translation.deities : temple.deities,
        //           images: temple.images,
        //           translations: temple.translations,
        //         ),
        //       );
        //       print("Language Code: ${translation.languageCode}");
        //       print("Name: ${translation.name}");
        //       print("Address: ${translation.address}");
        //       print("City: ${translation.city}");
        //       print("State: ${translation.state}");
        //       print("Description: ${translation.description}");
        //     }
        //   } else {
        temples.addAll(response.data ?? []);
        //   }
        // }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching temples: $e");
      hasMore = false;
    }

    isLoading = false;
    isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    temples = [];
    isLoading = true;
    isLoadingMore = false;
    hasMore = true;
    page = 1;
limit = 10;
    notifyListeners();
  }

  Future<void> resetAndFetch() async {
    reset();
    await fetchTemples(refresh: true);
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      resetAndFetch();
    });
  }
}
