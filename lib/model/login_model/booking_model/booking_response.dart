// booking_response.dart (add/update these classes)

import 'package:nammadaiva_dashboard/generated/l10n.dart';

String _formatIsoDate(String? iso) {
  if (iso == null || iso.isEmpty) return "-";
  try {
    final dt = DateTime.parse(iso).toLocal();
    // Format as dd/MM/yyyy — you can change to any format you like
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    return "$day/$month/$year";
  } catch (e) {
    // fallback: try to return first 10 chars (YYYY-MM-DD)
    return iso.length >= 10 ? iso.substring(0, 10) : iso;
  }
}

class BookingResponse {
  final int code;
  final String message;
  final List<BookingModel> data;
  final int totalCount;
  final int totalPages;
  final int page;
  final int limit;

  BookingResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.totalPages,
    required this.page,
    required this.limit,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    return BookingResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? "",
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <BookingModel>[],
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}

class BookingModel {
  final String bookingId;
  final String userName;
  final String userPhone;
  final String userEmail;
  final String pujaName;
  final String pujaDate; // ISO string
  final String totalAmount;
  final String bookingStatus;
  final String createdAt; // ISO string
  final String? priestDakshina;
  final List<SankalpaDetail> sankalpaDetails;
  final List<PaymentDetail> paymentDetails;
final PrasadAddress? prasadAddress;  
final List<String>images;
final int? puja_fee;
final int? prasad_delivery_charges; 
final String? convenience_fee;
final String? priest_dakshina; // alias for bookingId


  BookingModel({
    required this.bookingId,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.pujaName,
    required this.pujaDate,
    required this.totalAmount,
    required this.bookingStatus,
    required this.createdAt,
    required this.priestDakshina,
    required this.sankalpaDetails,
    required this.paymentDetails,
     this.prasadAddress,
    this.images = const [],
      this.puja_fee,
        this.prasad_delivery_charges,
        this.convenience_fee,
        this.priest_dakshina,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['booking_id'] ?? "",
      userName: json['user_name'] ?? "",
      userPhone: json['user_phone'] ?? "",
      userEmail: json['user_email'] ?? "",
      pujaName: json['puja_name'] ?? "",
      pujaDate: json['puja_date'] ?? "",
      totalAmount: json['total_amount'] ?? "0",
      bookingStatus: json['booking_status'] ?? "",
      createdAt: json['created_at'] ?? "",
      priestDakshina: json['priest_dakshina'],
      sankalpaDetails: (json['sankalpa_details'] as List<dynamic>?)
              ?.map((e) => SankalpaDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <SankalpaDetail>[],
      paymentDetails: (json['payment_details'] as List<dynamic>?)
              ?.map((e) => PaymentDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          <PaymentDetail>[],
          images: json['images'] != null
          ? List<String>.from(json['images'])
          : [],
          prasadAddress: json['prasad_address'] != null
          ? PrasadAddress.fromJson(json['prasad_address'])
          : null,
          puja_fee: json['puja_fee'],
          prasad_delivery_charges: json['prasad_delivery_charges'],
          convenience_fee: json['convenience_fee'],
          priest_dakshina: json['priest_dakshina'],
    );
  }

  // ---------- Helpful getters for UI ----------
  String get pujaDateFormatted => _formatIsoDate(pujaDate);
  String get createdAtFormatted => _formatIsoDate(createdAt);
  String get totalAmountDisplay => totalAmount.isEmpty ? "-" : totalAmount;
  String get bookingStatusDisplay => bookingStatus.isEmpty ? "-" : bookingStatus;
  int get pujaFeeDisplay => puja_fee ?? 0;
  int get prasadDeliveryChargesDisplay => prasad_delivery_charges ?? 0;
  String get convenienceFeeDisplay => convenience_fee?.isEmpty ?? true ? "-" : convenience_fee!;
  // alias names your UI might call
  String get bookingIdDisplay => bookingId;
  String get userPhoneDisplay => userPhone;
  String get userEmailDisplay => userEmail;
  // convenience: if you used different property names earlier
  String get pujaDateShort => pujaDateFormatted;
  String get priestDakshinaDisplay => priest_dakshina?.isEmpty ?? true ? "-" : priest_dakshina!;
  // (you can add more helpers as needed)
}

class SankalpaDetail {
  final String id;
  final String name;
  final String rashi;
  final String gothra;
  final String nakshatra;

  SankalpaDetail({
    required this.id,
    required this.name,
    required this.rashi,
    required this.gothra,
    required this.nakshatra,
  });

  factory SankalpaDetail.fromJson(Map<String, dynamic> json) {
    return SankalpaDetail(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      rashi: json['rashi'] ?? "",
      gothra: json['gothra'] ?? "",
      nakshatra: json['nakshatra'] ?? "",
    );
  }
}

class PaymentDetail {
  final int amount;
  final String paymentId;
final String paymentStatus;
  final String transactionDate; // ISO string
  final String razorpayOrderId;
  final String? razorpayPaymentId;

  PaymentDetail({
    required this.amount,
    required this.paymentId,
    required this.paymentStatus,
    required this.transactionDate,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      amount: json['amount'] is int ? json['amount'] : (json['amount'] ?? 0),
      paymentId: json['payment_id'] ?? "",
      paymentStatus: json['payment_status'] ?? "",
      transactionDate: json['transaction_date'] ?? "",
      razorpayOrderId: json['razorpay_order_id'] ?? "",
      razorpayPaymentId: json['razorpay_payment_id'],
    );
  }

  // ---------- Getter for formatted transaction date ----------
  String get transactionDateFormatted => _formatIsoDate(transactionDate);
}
class PrasadAddress {
  final String city;
  final String state;
  final String pincode;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;

  PrasadAddress({
    required this.city,
    required this.state,
    required this.pincode,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
  });

  factory PrasadAddress.fromJson(Map<String, dynamic> json) {
    return PrasadAddress(
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      pincode: json['pincode'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      addressLine1: json['address_line1'] ?? "",
      addressLine2: json['address_line2'],
    );
  }

  // 🔥 Helper for UI
  String get fullAddress {
    return [
      addressLine1,
      addressLine2,
      city,
      state,
      pincode
    ].where((e) => e != null && e.toString().trim().isNotEmpty).join(", ");
  }
}