class DashboardStatsResponse {
  final int code;
  final String message;
  final DashboardStats data;

  DashboardStatsResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory DashboardStatsResponse.fromJson(Map<String, dynamic> json) {
    return DashboardStatsResponse(
      code: json['code'] as int,
      message: json['message'] as String,
      data: DashboardStats.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DashboardStats {
  final int totalTemples;
  final int totalUsers;
  final int totalBookings;
  final int totalTransactionAmount;

  DashboardStats({
    required this.totalTemples,
    required this.totalUsers,
    required this.totalBookings,
    required this.totalTransactionAmount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
  return DashboardStats(
    totalTemples: json['total_temples'] ?? 0,
    totalUsers: json['total_users'] ?? 0,
    totalBookings: json['total_bookings'] ?? 0,
    totalTransactionAmount: json['total_transaction_amount'] ?? 0,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'total_temples': totalTemples,
      'total_users': totalUsers,
      'total_bookings': totalBookings,
      'total_transaction_amount': totalTransactionAmount,
    };
  }
}
