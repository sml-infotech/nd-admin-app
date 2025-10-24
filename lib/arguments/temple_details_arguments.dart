class TempleDetailsArguments {
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

  TempleDetailsArguments({
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
  });
}
