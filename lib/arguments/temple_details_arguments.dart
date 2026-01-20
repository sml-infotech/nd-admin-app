import 'package:nammadaiva_dashboard/model/login_model/createtemplemodel/create_temple_requestmodel.dart';

class TempleDetailsArguments {
  final String templeId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String architecture;
  final String phoneNumber;
  final String email;
  final String description;
  final List<String> deities;
  final List<String> images; 
  final List<Translation> translations;

  TempleDetailsArguments({
    required this.templeId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.architecture,
    required this.phoneNumber,
    required this.email,
    required this.description,
    required this.deities,
    required this.images,
    required this.translations,
  });
}
