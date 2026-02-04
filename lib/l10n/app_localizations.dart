import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kn')
  ];

  /// No description provided for @nammDaivaTitleText.
  ///
  /// In en, this message translates to:
  /// **'NAMMA DAIVA'**
  String get nammDaivaTitleText;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userName;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterUserName.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterUserName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter New password'**
  String get enterPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @termsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions and Privacy policy'**
  String get termsAndCondition;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @masterTemples.
  ///
  /// In en, this message translates to:
  /// **'Master Temples'**
  String get masterTemples;

  /// No description provided for @addHighlights.
  ///
  /// In en, this message translates to:
  /// **'Add Highlights'**
  String get addHighlights;

  /// No description provided for @enterblogName.
  ///
  /// In en, this message translates to:
  /// **'Enter Blog Name '**
  String get enterblogName;

  /// No description provided for @enterblogDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter Blog Description'**
  String get enterblogDescription;

  /// No description provided for @mantra.
  ///
  /// In en, this message translates to:
  /// **'Mantra'**
  String get mantra;

  /// No description provided for @mantraName.
  ///
  /// In en, this message translates to:
  /// **'Mantra Name'**
  String get mantraName;

  /// No description provided for @enterMantraName.
  ///
  /// In en, this message translates to:
  /// **'Enter Mantra Name'**
  String get enterMantraName;

  /// No description provided for @enterMantra.
  ///
  /// In en, this message translates to:
  /// **'Enter Mantra'**
  String get enterMantra;

  /// No description provided for @resetSubText.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password and confirm it.'**
  String get resetSubText;

  /// No description provided for @fogotSubtext.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address and we’ll send you an OTP to reset your password.'**
  String get fogotSubtext;

  /// No description provided for @forgotPassword1.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword1;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @nammaDaivaSmall.
  ///
  /// In en, this message translates to:
  /// **'Namma Daiva'**
  String get nammaDaivaSmall;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeBack;

  /// No description provided for @templeDetailText.
  ///
  /// In en, this message translates to:
  /// **'Temples'**
  String get templeDetailText;

  /// No description provided for @sevaText.
  ///
  /// In en, this message translates to:
  /// **'Seva/Pooja'**
  String get sevaText;

  /// No description provided for @onlineSeva.
  ///
  /// In en, this message translates to:
  /// **'Online Seva & Harake Bookings'**
  String get onlineSeva;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @createMantra.
  ///
  /// In en, this message translates to:
  /// **'Create Mantra'**
  String get createMantra;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event Name'**
  String get event;

  /// No description provided for @updateEvent.
  ///
  /// In en, this message translates to:
  /// **'Update Event'**
  String get updateEvent;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @bookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookings;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @donationText.
  ///
  /// In en, this message translates to:
  /// **'Donation Tracking'**
  String get donationText;

  /// No description provided for @ritualText.
  ///
  /// In en, this message translates to:
  /// **'Ritual & Event Promotion'**
  String get ritualText;

  /// No description provided for @audittext.
  ///
  /// In en, this message translates to:
  /// **'Audit & Committee Reports'**
  String get audittext;

  /// No description provided for @transactionText.
  ///
  /// In en, this message translates to:
  /// **'Transaction Reports'**
  String get transactionText;

  /// No description provided for @wowtracker.
  ///
  /// In en, this message translates to:
  /// **'Seva & WOW Tracker'**
  String get wowtracker;

  /// No description provided for @templeDetail.
  ///
  /// In en, this message translates to:
  /// **'Temple Details'**
  String get templeDetail;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @addDeities.
  ///
  /// In en, this message translates to:
  /// **'Add Deities'**
  String get addDeities;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @searchUser.
  ///
  /// In en, this message translates to:
  /// **'Search User..'**
  String get searchUser;

  /// No description provided for @selectDeities.
  ///
  /// In en, this message translates to:
  /// **'Select the temple first to view deities.'**
  String get selectDeities;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification code'**
  String get verificationCode;

  /// No description provided for @otpSubTitle.
  ///
  /// In en, this message translates to:
  /// **'4 digits code was sent to '**
  String get otpSubTitle;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @createAcc.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createAcc;

  /// No description provided for @addMasterTemple.
  ///
  /// In en, this message translates to:
  /// **'Add Master Temple'**
  String get addMasterTemple;

  /// No description provided for @addTemple.
  ///
  /// In en, this message translates to:
  /// **'Add Temple'**
  String get addTemple;

  /// No description provided for @sectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Section Title'**
  String get sectionTitle;

  /// No description provided for @blogs.
  ///
  /// In en, this message translates to:
  /// **'Blogs'**
  String get blogs;

  /// No description provided for @no_blogs_found.
  ///
  /// In en, this message translates to:
  /// **'No Blogs Found'**
  String get no_blogs_found;

  /// No description provided for @blogs_details.
  ///
  /// In en, this message translates to:
  /// **'Blog Details'**
  String get blogs_details;

  /// No description provided for @addTempleinkannadam.
  ///
  /// In en, this message translates to:
  /// **'Add Temple In Kannadam'**
  String get addTempleinkannadam;

  /// No description provided for @templeName.
  ///
  /// In en, this message translates to:
  /// **'Temple Name'**
  String get templeName;

  /// No description provided for @noTemplesFound.
  ///
  /// In en, this message translates to:
  /// **'No Temples Found'**
  String get noTemplesFound;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @addfestival.
  ///
  /// In en, this message translates to:
  /// **'Add Festival'**
  String get addfestival;

  /// No description provided for @festivalname.
  ///
  /// In en, this message translates to:
  /// **'Festival Name'**
  String get festivalname;

  /// No description provided for @festivals.
  ///
  /// In en, this message translates to:
  /// **'Festivals'**
  String get festivals;

  /// No description provided for @festivalDetails.
  ///
  /// In en, this message translates to:
  /// **'Festival Details'**
  String get festivalDetails;

  /// No description provided for @updateFestival.
  ///
  /// In en, this message translates to:
  /// **'Update Festival'**
  String get updateFestival;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @deities.
  ///
  /// In en, this message translates to:
  /// **'Deities'**
  String get deities;

  /// No description provided for @create_blog.
  ///
  /// In en, this message translates to:
  /// **'Create Blog'**
  String get create_blog;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @userDetails.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get userDetails;

  /// No description provided for @selectedRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectedRole;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @temples.
  ///
  /// In en, this message translates to:
  /// **'Temples'**
  String get temples;

  /// No description provided for @selectTemples.
  ///
  /// In en, this message translates to:
  /// **'Select Temple'**
  String get selectTemples;

  /// No description provided for @temple.
  ///
  /// In en, this message translates to:
  /// **'Temple'**
  String get temple;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @uploadFromExcel.
  ///
  /// In en, this message translates to:
  /// **'Upload Temples From Excel'**
  String get uploadFromExcel;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @architecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get architecture;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @templelocation.
  ///
  /// In en, this message translates to:
  /// **'Temple Location'**
  String get templelocation;

  /// No description provided for @templedescription.
  ///
  /// In en, this message translates to:
  /// **'Temple Description'**
  String get templedescription;

  /// No description provided for @templephonenumber.
  ///
  /// In en, this message translates to:
  /// **'Temple Phone Number'**
  String get templephonenumber;

  /// No description provided for @templeemail.
  ///
  /// In en, this message translates to:
  /// **'Temple Email'**
  String get templeemail;

  /// No description provided for @deitiestemple.
  ///
  /// In en, this message translates to:
  /// **'Deities'**
  String get deitiestemple;

  /// No description provided for @templearchitecture.
  ///
  /// In en, this message translates to:
  /// **'Temple Architecture'**
  String get templearchitecture;

  /// No description provided for @editImages.
  ///
  /// In en, this message translates to:
  /// **'Edit Images'**
  String get editImages;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentStatus;

  /// No description provided for @requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get requested;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @submitAllApprovals.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submitAllApprovals;

  /// No description provided for @eventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get eventDescription;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocation;

  /// No description provided for @addPuja.
  ///
  /// In en, this message translates to:
  /// **'Add Pooja / Seva'**
  String get addPuja;

  /// No description provided for @updatePuja.
  ///
  /// In en, this message translates to:
  /// **'Update Pooja'**
  String get updatePuja;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search events...'**
  String get search;

  /// No description provided for @searchTemples.
  ///
  /// In en, this message translates to:
  /// **'Search Temples...'**
  String get searchTemples;

  /// No description provided for @pujaList.
  ///
  /// In en, this message translates to:
  /// **'Poojas'**
  String get pujaList;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @updateRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get updateRequests;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee: '**
  String get fee;

  /// No description provided for @addSevaAndPuja.
  ///
  /// In en, this message translates to:
  /// **'Add Seva / Pooja name'**
  String get addSevaAndPuja;

  /// No description provided for @slot.
  ///
  /// In en, this message translates to:
  /// **'Slot'**
  String get slot;

  /// No description provided for @selectSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Slot'**
  String get selectSlot;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @enterPuja.
  ///
  /// In en, this message translates to:
  /// **'Enter Pooja / Seva duration time'**
  String get enterPuja;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Enter Cost'**
  String get cost;

  /// No description provided for @fees.
  ///
  /// In en, this message translates to:
  /// **'Fees'**
  String get fees;

  /// No description provided for @maxDevote.
  ///
  /// In en, this message translates to:
  /// **'Devotees '**
  String get maxDevote;

  /// No description provided for @maxNoDevote.
  ///
  /// In en, this message translates to:
  /// **'Number of Devotees'**
  String get maxNoDevote;

  /// No description provided for @uploadText.
  ///
  /// In en, this message translates to:
  /// **'Upload Image '**
  String get uploadText;

  /// No description provided for @uploadImageSeva.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadImageSeva;

  /// No description provided for @cutOffText.
  ///
  /// In en, this message translates to:
  /// **'Booking Cutoff / Notice'**
  String get cutOffText;

  /// No description provided for @priestText.
  ///
  /// In en, this message translates to:
  /// **'Priest Dakshina (Optional)'**
  String get priestText;

  /// No description provided for @fromTime.
  ///
  /// In en, this message translates to:
  /// **'From Time'**
  String get fromTime;

  /// No description provided for @toTime.
  ///
  /// In en, this message translates to:
  /// **'To Time'**
  String get toTime;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @noPujaAvailable.
  ///
  /// In en, this message translates to:
  /// **'No pujas available'**
  String get noPujaAvailable;

  /// No description provided for @deitiesText.
  ///
  /// In en, this message translates to:
  /// **'Deities: '**
  String get deitiesText;

  /// No description provided for @descriptionText.
  ///
  /// In en, this message translates to:
  /// **'Description : '**
  String get descriptionText;

  /// No description provided for @cutOffNoticeText.
  ///
  /// In en, this message translates to:
  /// **'Select Cut-off Notice'**
  String get cutOffNoticeText;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From: '**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To: '**
  String get to;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inActive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inActive;

  /// No description provided for @maxDevotee.
  ///
  /// In en, this message translates to:
  /// **'Max Devotees: '**
  String get maxDevotee;

  /// No description provided for @availableDays.
  ///
  /// In en, this message translates to:
  /// **'Available Days :'**
  String get availableDays;

  /// No description provided for @availableslot.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots :'**
  String get availableslot;

  /// No description provided for @viewImg.
  ///
  /// In en, this message translates to:
  /// **'View Images'**
  String get viewImg;

  /// No description provided for @noAvailableSlot.
  ///
  /// In en, this message translates to:
  /// **'No available time slots'**
  String get noAvailableSlot;

  /// No description provided for @hideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hideDetails;

  /// No description provided for @viewAndApprove.
  ///
  /// In en, this message translates to:
  /// **'View & Approve'**
  String get viewAndApprove;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @previousData.
  ///
  /// In en, this message translates to:
  /// **'Previous Data'**
  String get previousData;

  /// No description provided for @changesData.
  ///
  /// In en, this message translates to:
  /// **'Changes Data'**
  String get changesData;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Add comment for rejection'**
  String get reason;

  /// No description provided for @rejectionComment.
  ///
  /// In en, this message translates to:
  /// **'Rejection Comment (applies to all rejected fields)'**
  String get rejectionComment;

  /// No description provided for @specialReq.
  ///
  /// In en, this message translates to:
  /// **'Special Requirements (allow user to add special requirements)'**
  String get specialReq;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'kn'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'kn': return AppLocalizationsKn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
