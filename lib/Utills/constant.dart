import 'dart:ui';

class StringConstant {
  StringConstant._();
  static const String nammDaivaTitleText = "NAMMA DAIVA";
  static const String userName = "Username";
  static const String password = "Password";
  static const String enterUserName = "Enter your email";
  static const String enterName = "Enter Name";
  static const String enterPassword = "Enter valid password";
  static const String enterConfirmPassword = "Enter Confirm password";
  static const String termsAndCondition =
      "I agree to the Terms & Conditions and Privacy policy";
  static const String login = "Login";
  static const String reset = "Reset";
  static const String resetPassword = "Reset Password";
  static const String resetSubText = "Enter a new password and confirm it.";
  static const String fogotSubtext =
      "Enter your registered email address and we’ll send you an OTP to reset your password.";
  static const String forgotPassword1 = "Forgot Password";
  static const String forgotPassword = "Forgot Password?";
  static const String welcomeBack = "Welcome";
  static const String nammaDaivaSmall = "Namma Daiva";
  static const String templeDetailText = "Temples";
  static const String sevaText = "Seva/Pooja";
  static const String onlineSeva = "Online Seva & Harake Bookings";
  static const String createUser = "CreateUser";
  static const String createEvent = "Create Event";
  static const String event = "Event Name";
  static const String updateEvent = "Update Event";
  static const String events = "Events";
  static const String donationText = "Donation Tracking";
  static const String ritualText = "Ritual & Event Promotion";
  static const String audittext = "Audit & Committee Reports";
  static const String transactionText = "Transaction Reports";
  static const String wowtracker = "Seva & WOW Tracker";
  static const String templeDetail = "Temples Details";
  static const String edit = "Edit";
  static const String phone = "Phone";
  static const String selectDeities =
      "Select the temple first to view deities.";

  static const String email = "Email";
  static const String verificationCode = "Enter Verification code";
  static const String otpSubTitle = "4 digits code was sent to ";
  static const String resend = "Resend Code";
  static const String verify = "Verify";
  static const String createAcc = " Create User";
  static const String addTemple = "Add Temple";
  static const String templeName = "Temple Name";
  static const String pincode = "Pincode";
  static const String status = "Status";

  static const String deities = "Deities";
  static const String images = "Images";
  static const String userDetails = "Users";
  static const String selectedRole = "Select Role";
  static const String role = "Role";
  static const String temples = "Temples";
  static const String selectTemples = "Select Temple";
  static const List<String> roles = ["Temple", "Agent", "Admin"];
  static const String temple = "Temples";
  static const String create = "Create";
  static const String editUser = "Edit User";
  static const String city = "City:";
  static const String state = "State:";
  static const String architecture = "Architecture:";
  static const String address = "Address:";
  static const String cityy = "City";
  static const String statee = "State";
  static const String architecturee = "Architecture";
  static const String addresss = "Address";
  static const String description = "description";
  static const String location = "Location";
  static const String contactName = "ContactName";
  static const String save = "Save";
  static const String templename = "Temple Name";
  static const String templelocation = "Temple Location";
  static const String templedescription = "Temple Description";
  static const String templephonenumber = "Temple Phone Number";
  static const String templeemail = "Temple Email";
  static const String deitiestemple = "Deities";
  static const String templearchitecture = "Temple Architecture";
  static const String editImages = "Edit Images";
  static const String current = "Current";
  static const String requested = "Requested";
  static const String cancel = "Cancel";
  static const String submitAllApprovals = "Submit All Approvals";
  static const String eventDescription = "Description";
  static const String contactInformation = "Contact Information";
  static const String eventLocation = "Location";
  static const String addPuja = "Add Puja / Seva";
  static const String updatePuja = "UpdatePuja";
  static const String search = "Search events...";
  static const String pujaList = "Pujas";
  static const String dashboard = "DashBoard";

  static const String updateRequests = "Requests";
  static const String fee = "Fee: ";
  static const String addSevaAndPuja = "Add Seva / puja name";
  static const String slot = "Slot";
  static const String selectSlot = "Select Slot";
  static const String date = "Date";
  static const String enterPuja = "Enter Puja / Seva duration time";
  static const String duration = "Duration";
  static const String cost = "Enter Cost";
  static const String fees = "Fees";
  static const String maxDevote = "devotees ";
  static const String maxNoDevote = "number of Devotees";
  static const String uploadText = "Upload Image ";
  static const String uploadImageSeva = "Upload Images";
  static const String cutOffText = "Booking Cutoff / Notice";
  static const String priestText = "Priest Dakshina (Optional)";
  static const String fromTime = "From time";
  static const String toTime = "To time";
  static const String fromDate = "From Date";
  static const String toDate = "To Date";
  static const String noPujaAvailable = "No pujas available";
  static const String deitiesText = "Deities: ";
  static const String descriptionText = "Description : ";
  static const String cutOffNoticeText="Select Cut-off Notice";
  static const String from = "From: ";
  static const String to = "To: ";
  static const String active = "Active";
  static const String inActive = "Inactive";
  static const String maxDevotee = "Max Devotees: ";
  static const String availableDays = "Available Days :";
  static const String availableslot = "Available Time Slots :";
  static const String viewImg = "View Images";
  static const String noAvailableSlot = "No available time slots";
  static const String hideDetails = "Hide Details";
  static const String viewAndApprove = "View & Approve";
  static const String approve = "Approve";
  static const String reject = "Reject";
  static const String previousData = "Previous Data";
  static const String changesData = "Changes Data";
  static const String reason = "Add comment for rejection";
  static const String rejectionComment =
      "Rejection Comment (applies to all rejected fields)";
  static const String specialReq =
      "Special Requirements (allow user to add special requirements)";
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
  static TextStyle Regular = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
  );
  static TextStyle Medium = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
  );
  static TextStyle SemiBold = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w600,
  );
  static TextStyle Bold = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w700,
  );
  static TextStyle ExtraBold = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w800,
  );
}
