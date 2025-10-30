import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class MException implements Exception {
  String message;

  MException(this.message);
}

class HttpApiService {
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = 
   prefs.getString('authToken');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(data),
    );
    print(response.body);
    print(response.statusCode);
    print(response.headers);
    print("request ${response.request}");
    print(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('200 good State');
      return json.decode(response.body);
    } else if (response.statusCode >= 400) {
      Map value = json.decode(response.body);
      print(value['message']);
      String msg = value['message'];
      throw MException(msg);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> get(
    String url,
  ) async {
    print(url);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token =    prefs.getString('authToken');

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    print(response.statusCode);
    print('Bearer $token');
    if (response.statusCode <= 200) {
      print('200 good State getMethod');
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }



  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> data,
  ) async {
    print(data);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token =    prefs.getString('authToken');

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(data),
    );
    print("put api --> ");
    print(response.body);
    print(response.statusCode);
    print(response.request);
    print(response);

    if (response.statusCode == 200) {
      print('200 good State');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> delete(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("SharedPreferenceConstant.jwtToken");
    final response = await http.delete(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print('200 good State');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }
}
