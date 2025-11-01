enum Server { dev, stage, prod }

var environment = Server.stage;
String baseUrlString() {
  switch (environment) {
    case Server.dev:
      return "";
    case Server.stage:
      return "https://w83sadhrvk.execute-api.ap-southeast-2.amazonaws.com/Prod/api/v1/";
    case Server.prod:
      return "";
  }
}

class UrlConstant {
  UrlConstant._();
  static String loginUrl = "${baseUrlString()}login-dashboard-user";
  static  String otpUrl = "${baseUrlString()}verify-dashboard-user-otp";
  static String createUser = "${baseUrlString()}create-dashboard-user";
  static String templeUser ="${baseUrlString()}list-temples";
  static String userListUrl ="${baseUrlString()}list-dashboard-users";
  static String userEditUrl ="${baseUrlString()}edit-dashboard-user";
  static String forgotPasswordUrl ="${baseUrlString()}forget-dashboard-user-password";
  static String resetPasswordUrl ="${baseUrlString()}reset-dashboard-user-password";
  static String addTempleUrl ="${baseUrlString()}create-temple";
  static String presignedUrl ="${baseUrlString()}get-presigned-url/upload";
  static String createPujaUrl ="${baseUrlString()}create-puja";
  static String getPujas ="${baseUrlString()}list-pujas";
  static String updateTempleUrl ="${baseUrlString()}temple-update-requests";
  static String updateTempleRequestUrl ="${baseUrlString()}list-temple-update-requests";
  static String updateTempleAdminUrl ="${baseUrlString()}update-temple";
  static String updatePuja ="${baseUrlString()}update-puja";
  static String toggleUrl ="${baseUrlString()}toggle-puja-active";
      

}
