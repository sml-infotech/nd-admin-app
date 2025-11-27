
class MasterTempleModelResPonse {
  final int code;
  final String message;

  MasterTempleModelResPonse({
    required this.code,
    required this.message,
  });

  factory MasterTempleModelResPonse.fromJson(Map<String, dynamic> json) {
    return MasterTempleModelResPonse(
      code: json['code'],
      message: json['message'],
    );
  }
}

