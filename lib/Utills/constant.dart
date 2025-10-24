import 'dart:ui';

class StringConstant {
  StringConstant._();
  static const String nammDaivaTitleText = "NAMMA DAIVA";
  static const String userName = "Username";
  static const String password = "Password";
  static const String enterUserName = "Enter your email";
  static const String enterName ="Enter Name";
  static const String enterPassword = "Enter valid password";
  static const String enterConfirmPassword = "Enter Confirm password";

  static const String termsAndCondition = "I agree to the Terms & Conditions and Privacy policy";
  static const String login = "Login";
  static const String reset = "Reset";
    static const String resetPassword = "Reset Password";

  static const String resetSubText = "Enter a new password and confirm it.";
  static const String fogotSubtext="Enter your registered email address and we’ll send you an OTP to reset your password.";
  static const String forgotPassword1 = "Forgot Password";

  static const String forgotPassword = "Forgot Password?";
  static const String welcomeBack = "Welcome";
  static const String nammaDaivaSmall = "Namma Daiva";
  static const String templeDetailText = "Temple Details & History";
  static const String sevaText = "Seva/Pooja Calendar";
  static const String onlineSeva = "Online Seva & Harake Bookings";
  static const String donationText = "Donation Tracking";
  static const String ritualText = "Ritual & Event Promotion";
  static const String audittext = "Audit & Committee Reports";
  static const String transactionText = "Transaction Reports";
  static const String wowtracker = "Seva & WOW Tracker";
  static const String templeDetail = "Temples Details";
  static const String edit = "edit";
  static const String phone = "Phone";
  static const String email = "Email";
  static const String verificationCode = "Enter Verification code";
  static const String otpSubTitle = "4 digits code was sent to ";
  static const String resend = "Resend Code";
  static const String verify = "Verify";
  static const String createAcc = " Create User";
  static const String userDetails = "User Details";
  static const String selectedRole = "Select Role";
  static const String role = "Role";
  static const String temples = "Temples";
  static const String selectTemples = "Select Temple";
  static const List<String> roles=["Temple", "Agent", "Admin"];
  static const String temple = "Temples";
  static const String create = "Create";
  static const String editUser = "Edit User";
  static const String city = "City:";
  static const String state = "State:";
  static const String architecture = "Architecture:";
  static const String address = "Address:";




}

class ColorConstant {
  ColorConstant._();
    static const Color primaryColor = Color(0xff770425);
    static const Color eyeColor = Color(0xffcdcdcd);
    static const Color buttonColor = Color(0xff770425);

}



String font = 'Nunito';
class Fonts {
  Fonts._();
  static TextStyle Regular =
      TextStyle(fontFamily: font, fontWeight: FontWeight.w400,);
  static TextStyle Medium =
      TextStyle(fontFamily: font, fontWeight: FontWeight.w500);
  static TextStyle SemiBold =
      TextStyle(fontFamily: font, fontWeight: FontWeight.w600);
  static TextStyle Bold =
      TextStyle(fontFamily: font, fontWeight: FontWeight.w700);
  static TextStyle ExtraBold =
      TextStyle(fontFamily: font, fontWeight: FontWeight.w800);
}