enum Server { dev, stage, prod }

var environment = Server.dev;
String baseUrlString() {
  switch (environment) {
    case Server.dev:
      return "https://s7jij3mes9.execute-api.ap-south-1.amazonaws.com/Prod/api/";
    case Server.stage:
      return "https://w83sadhrvk.execute-api.ap-southeast-2.amazonaws.com/Prod/api/";
    // "https://s7jij3mes9.execute-api.ap-south-1.amazonaws.com/Prod/api/";

    case Server.prod:
      return "";
  }
}

class UrlConstant {
  UrlConstant._();
  static String loginUrl = "${baseUrlString()}v2/login-dashboard-user";
  static String create_blog = "${baseUrlString()}v1/create-blog";
  static String otpUrl = "${baseUrlString()}v1/verify-dashboard-user-otp";
  static String createUser = "${baseUrlString()}v1/create-dashboard-user";
  static String postFcmToken = "${baseUrlString()}v1/fcm-token";
  static String logoutUrl = "${baseUrlString()}v1/logout-dashboard-user";
  static String templeUser = "${baseUrlString()}v1/list-temples";
  static String userListUrl = "${baseUrlString()}v1/list-dashboard-users";
  static String userEditUrl = "${baseUrlString()}v1/edit-dashboard-user";
  static String forgotPasswordUrl =
      "${baseUrlString()}v1/forget-dashboard-user-password";
  static String resetPasswordUrl =
      "${baseUrlString()}v1/reset-dashboard-user-password";
  static String addTempleUrl = "${baseUrlString()}v1/create-temple";
  static String presignedUrl = "${baseUrlString()}v1/get-presigned-url/upload";
  static String createPujaUrl = "${baseUrlString()}v1/create-puja";
  static String getPujas = "${baseUrlString()}v1/list-pujas";
  static String updateTempleUrl = "${baseUrlString()}v1/temple-update-requests";
  static String updateTempleRequestUrl =
      "${baseUrlString()}v1/list-temple-update-requests";
  static String updateTempleAdminUrl = "${baseUrlString()}v1/update-temple";
  static String updatePuja = "${baseUrlString()}v1/update-puja";
  static String toggleUrl = "${baseUrlString()}v1/toggle-puja-active";
  static String templeApprovalUrl = "${baseUrlString()}v1/temple-approval";
  static String createEventUrl = "${baseUrlString()}v1/create-event";
  static String getEventsUrl = "${baseUrlString()}v1/list-events";
  static String updateEvent = "${baseUrlString()}v1/update-event";
  static String bookingList = "${baseUrlString()}v2/list-bookings";
  static String contact_us = "${baseUrlString()}v1/list-contact-us-messages";
  static String mark_as_read = "${baseUrlString()}v1/contact-us";
  static String master_temples = "${baseUrlString()}v1/list-master-temples";
  static String create_master_temple =
      "${baseUrlString()}v1/create-master-temple";
  static String update_onboard = "${baseUrlString()}v1/update-master-temple";
  static String create_mantra = "${baseUrlString()}v1/create-mantra";
  static String list_mantras = "${baseUrlString()}v1/list-mantras";
  static String update_mantra = "${baseUrlString()}v1/update-mantra";
  static String create_highlight = "${baseUrlString()}v1/create-highlight";
  static String list_active_highlights =
      "${baseUrlString()}v1/list-active-highlights";
  static String list_inactive_highlights =
      "${baseUrlString()}v1/list-inactive-highlights";
  static String reorderHighlight = "${baseUrlString()}v1/reorder-highlight";
  static String updateHighlight =
      "${baseUrlString()}v1/toggle-highlight-active";
  static String create_festival = "${baseUrlString()}v1/add-festival";
  static String list_festivals = "${baseUrlString()}v1/list-festivals";
  static String update_festival = "${baseUrlString()}v1/edit-festival";
  static String delete_festival = "${baseUrlString()}v1/delete-festival";
  static String editHighlight = "${baseUrlString()}v1/edit-highlight";
  static String getBlogs = "${baseUrlString()}v1/list-blogs";
  static String blogDetails = "${baseUrlString()}v1/blog-details";
  static String updateBlog = "${baseUrlString()}v1/update-blog";
  static String removeS3 = "${baseUrlString()}v1/delete-s3-file";
  static String updateBooking = "${baseUrlString()}v1/update-booking";
  static String notificationList = "${baseUrlString()}v1/list-notifications";
  static String fetchDashboardStats =
      "${baseUrlString()}v1/dashboard-statistics";
  static String markNotificationRead =
      "${baseUrlString()}v1/mark-notifications-read";
  static String togglePrasadAddressUrl(String pujaId) =>
      "${baseUrlString()}v1/puja/$pujaId/toggle-prasad-address";
}
