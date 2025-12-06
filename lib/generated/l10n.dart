// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `NAMMA DAIVA`
  String get nammDaivaTitleText {
    return Intl.message(
      'NAMMA DAIVA',
      name: 'nammDaivaTitleText',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message('Username', name: 'userName', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Enter your email`
  String get enterUserName {
    return Intl.message(
      'Enter your email',
      name: 'enterUserName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Name`
  String get enterName {
    return Intl.message('Enter Name', name: 'enterName', desc: '', args: []);
  }

  /// `Enter New password`
  String get enterPassword {
    return Intl.message(
      'Enter New password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Confirm password`
  String get enterConfirmPassword {
    return Intl.message(
      'Enter Confirm password',
      name: 'enterConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the Terms & Conditions and Privacy policy`
  String get termsAndCondition {
    return Intl.message(
      'I agree to the Terms & Conditions and Privacy policy',
      name: 'termsAndCondition',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Master Temples`
  String get masterTemples {
    return Intl.message(
      'Master Temples',
      name: 'masterTemples',
      desc: '',
      args: [],
    );
  }

  /// `Mantra`
  String get mantra {
    return Intl.message('Mantra', name: 'mantra', desc: '', args: []);
  }

  /// `Mantra Name`
  String get mantraName {
    return Intl.message('Mantra Name', name: 'mantraName', desc: '', args: []);
  }

  /// `Enter Mantra Name`
  String get enterMantraName {
    return Intl.message(
      'Enter Mantra Name',
      name: 'enterMantraName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Mantra`
  String get enterMantra {
    return Intl.message(
      'Enter Mantra',
      name: 'enterMantra',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new password and confirm it.`
  String get resetSubText {
    return Intl.message(
      'Enter a new password and confirm it.',
      name: 'resetSubText',
      desc: '',
      args: [],
    );
  }

  /// `Enter your registered email address and we’ll send you an OTP to reset your password.`
  String get fogotSubtext {
    return Intl.message(
      'Enter your registered email address and we’ll send you an OTP to reset your password.',
      name: 'fogotSubtext',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword1 {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword1',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcomeBack {
    return Intl.message('Welcome', name: 'welcomeBack', desc: '', args: []);
  }

  /// `Temples`
  String get templeDetailText {
    return Intl.message(
      'Temples',
      name: 'templeDetailText',
      desc: '',
      args: [],
    );
  }

  /// `Seva/Pooja`
  String get sevaText {
    return Intl.message('Seva/Pooja', name: 'sevaText', desc: '', args: []);
  }

  /// `Online Seva & Harake Bookings`
  String get onlineSeva {
    return Intl.message(
      'Online Seva & Harake Bookings',
      name: 'onlineSeva',
      desc: '',
      args: [],
    );
  }

  /// `Create User`
  String get createUser {
    return Intl.message('Create User', name: 'createUser', desc: '', args: []);
  }

  /// `Create Event`
  String get createEvent {
    return Intl.message(
      'Create Event',
      name: 'createEvent',
      desc: '',
      args: [],
    );
  }

  /// `Create Mantra`
  String get createMantra {
    return Intl.message(
      'Create Mantra',
      name: 'createMantra',
      desc: '',
      args: [],
    );
  }

  /// `Event Name`
  String get event {
    return Intl.message('Event Name', name: 'event', desc: '', args: []);
  }

  /// `Update Event`
  String get updateEvent {
    return Intl.message(
      'Update Event',
      name: 'updateEvent',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message('Events', name: 'events', desc: '', args: []);
  }

  /// `Bookings`
  String get bookings {
    return Intl.message('Bookings', name: 'bookings', desc: '', args: []);
  }

  /// `Contacts`
  String get contacts {
    return Intl.message('Contacts', name: 'contacts', desc: '', args: []);
  }

  /// `Donation Tracking`
  String get donationText {
    return Intl.message(
      'Donation Tracking',
      name: 'donationText',
      desc: '',
      args: [],
    );
  }

  /// `Ritual & Event Promotion`
  String get ritualText {
    return Intl.message(
      'Ritual & Event Promotion',
      name: 'ritualText',
      desc: '',
      args: [],
    );
  }

  /// `Audit & Committee Reports`
  String get audittext {
    return Intl.message(
      'Audit & Committee Reports',
      name: 'audittext',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Reports`
  String get transactionText {
    return Intl.message(
      'Transaction Reports',
      name: 'transactionText',
      desc: '',
      args: [],
    );
  }

  /// `Seva & WOW Tracker`
  String get wowtracker {
    return Intl.message(
      'Seva & WOW Tracker',
      name: 'wowtracker',
      desc: '',
      args: [],
    );
  }

  /// `Temple Details`
  String get templeDetail {
    return Intl.message(
      'Temple Details',
      name: 'templeDetail',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Search User..`
  String get searchUser {
    return Intl.message(
      'Search User..',
      name: 'searchUser',
      desc: '',
      args: [],
    );
  }

  /// `Select the temple first to view deities.`
  String get selectDeities {
    return Intl.message(
      'Select the temple first to view deities.',
      name: 'selectDeities',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter Verification code`
  String get verificationCode {
    return Intl.message(
      'Enter Verification code',
      name: 'verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `4 digits code was sent to `
  String get otpSubTitle {
    return Intl.message(
      '4 digits code was sent to ',
      name: 'otpSubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resend {
    return Intl.message('Resend Code', name: 'resend', desc: '', args: []);
  }

  /// `Verify`
  String get verify {
    return Intl.message('Verify', name: 'verify', desc: '', args: []);
  }

  /// `Create User`
  String get createAcc {
    return Intl.message('Create User', name: 'createAcc', desc: '', args: []);
  }

  /// `Add Master Temple`
  String get addMasterTemple {
    return Intl.message(
      'Add Master Temple',
      name: 'addMasterTemple',
      desc: '',
      args: [],
    );
  }

  /// `Add Temple`
  String get addTemple {
    return Intl.message('Add Temple', name: 'addTemple', desc: '', args: []);
  }

  /// `Temple Name`
  String get templeName {
    return Intl.message('Temple Name', name: 'templeName', desc: '', args: []);
  }

  /// `Pincode`
  String get pincode {
    return Intl.message('Pincode', name: 'pincode', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Deities`
  String get deities {
    return Intl.message('Deities', name: 'deities', desc: '', args: []);
  }

  /// `Images`
  String get images {
    return Intl.message('Images', name: 'images', desc: '', args: []);
  }

  /// `Users`
  String get userDetails {
    return Intl.message('Users', name: 'userDetails', desc: '', args: []);
  }

  /// `Select Role`
  String get selectedRole {
    return Intl.message(
      'Select Role',
      name: 'selectedRole',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message('Role', name: 'role', desc: '', args: []);
  }

  /// `Temples`
  String get temples {
    return Intl.message('Temples', name: 'temples', desc: '', args: []);
  }

  /// `Select Temple`
  String get selectTemples {
    return Intl.message(
      'Select Temple',
      name: 'selectTemples',
      desc: '',
      args: [],
    );
  }

  /// `Temple`
  String get temple {
    return Intl.message('Temple', name: 'temple', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Upload Temples From Excel`
  String get uploadFromExcel {
    return Intl.message(
      'Upload Temples From Excel',
      name: 'uploadFromExcel',
      desc: '',
      args: [],
    );
  }

  /// `Edit User`
  String get editUser {
    return Intl.message('Edit User', name: 'editUser', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `State`
  String get state {
    return Intl.message('State', name: 'state', desc: '', args: []);
  }

  /// `Architecture`
  String get architecture {
    return Intl.message(
      'Architecture',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Contact Name`
  String get contactName {
    return Intl.message(
      'Contact Name',
      name: 'contactName',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Temple Location`
  String get templelocation {
    return Intl.message(
      'Temple Location',
      name: 'templelocation',
      desc: '',
      args: [],
    );
  }

  /// `Temple Description`
  String get templedescription {
    return Intl.message(
      'Temple Description',
      name: 'templedescription',
      desc: '',
      args: [],
    );
  }

  /// `Temple Phone Number`
  String get templephonenumber {
    return Intl.message(
      'Temple Phone Number',
      name: 'templephonenumber',
      desc: '',
      args: [],
    );
  }

  /// `Temple Email`
  String get templeemail {
    return Intl.message(
      'Temple Email',
      name: 'templeemail',
      desc: '',
      args: [],
    );
  }

  /// `Deities`
  String get deitiestemple {
    return Intl.message('Deities', name: 'deitiestemple', desc: '', args: []);
  }

  /// `Temple Architecture`
  String get templearchitecture {
    return Intl.message(
      'Temple Architecture',
      name: 'templearchitecture',
      desc: '',
      args: [],
    );
  }

  /// `Edit Images`
  String get editImages {
    return Intl.message('Edit Images', name: 'editImages', desc: '', args: []);
  }

  /// `Current`
  String get currentStatus {
    return Intl.message('Current', name: 'currentStatus', desc: '', args: []);
  }

  /// `Requested`
  String get requested {
    return Intl.message('Requested', name: 'requested', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Submit`
  String get submitAllApprovals {
    return Intl.message(
      'Submit',
      name: 'submitAllApprovals',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get eventDescription {
    return Intl.message(
      'Description',
      name: 'eventDescription',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInformation {
    return Intl.message(
      'Contact Information',
      name: 'contactInformation',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get eventLocation {
    return Intl.message('Location', name: 'eventLocation', desc: '', args: []);
  }

  /// `Add Pooja / Seva`
  String get addPuja {
    return Intl.message(
      'Add Pooja / Seva',
      name: 'addPuja',
      desc: '',
      args: [],
    );
  }

  /// `Update Pooja`
  String get updatePuja {
    return Intl.message('Update Pooja', name: 'updatePuja', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Search events...`
  String get search {
    return Intl.message('Search events...', name: 'search', desc: '', args: []);
  }

  /// `Search Temples...`
  String get searchTemples {
    return Intl.message(
      'Search Temples...',
      name: 'searchTemples',
      desc: '',
      args: [],
    );
  }

  /// `Poojas`
  String get pujaList {
    return Intl.message('Poojas', name: 'pujaList', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Requests`
  String get updateRequests {
    return Intl.message('Requests', name: 'updateRequests', desc: '', args: []);
  }

  /// `Fee: `
  String get fee {
    return Intl.message('Fee: ', name: 'fee', desc: '', args: []);
  }

  /// `Add Seva / Pooja name`
  String get addSevaAndPuja {
    return Intl.message(
      'Add Seva / Pooja name',
      name: 'addSevaAndPuja',
      desc: '',
      args: [],
    );
  }

  /// `Slot`
  String get slot {
    return Intl.message('Slot', name: 'slot', desc: '', args: []);
  }

  /// `Select Slot`
  String get selectSlot {
    return Intl.message('Select Slot', name: 'selectSlot', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Enter Pooja / Seva duration time`
  String get enterPuja {
    return Intl.message(
      'Enter Pooja / Seva duration time',
      name: 'enterPuja',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Enter Cost`
  String get cost {
    return Intl.message('Enter Cost', name: 'cost', desc: '', args: []);
  }

  /// `Fees`
  String get fees {
    return Intl.message('Fees', name: 'fees', desc: '', args: []);
  }

  /// `Devotees `
  String get maxDevote {
    return Intl.message('Devotees ', name: 'maxDevote', desc: '', args: []);
  }

  /// `Number of Devotees`
  String get maxNoDevote {
    return Intl.message(
      'Number of Devotees',
      name: 'maxNoDevote',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image `
  String get uploadText {
    return Intl.message(
      'Upload Image ',
      name: 'uploadText',
      desc: '',
      args: [],
    );
  }

  /// `Upload Images`
  String get uploadImageSeva {
    return Intl.message(
      'Upload Images',
      name: 'uploadImageSeva',
      desc: '',
      args: [],
    );
  }

  /// `Booking Cutoff / Notice`
  String get cutOffText {
    return Intl.message(
      'Booking Cutoff / Notice',
      name: 'cutOffText',
      desc: '',
      args: [],
    );
  }

  /// `Priest Dakshina (Optional)`
  String get priestText {
    return Intl.message(
      'Priest Dakshina (Optional)',
      name: 'priestText',
      desc: '',
      args: [],
    );
  }

  /// `From Time`
  String get fromTime {
    return Intl.message('From Time', name: 'fromTime', desc: '', args: []);
  }

  /// `To Time`
  String get toTime {
    return Intl.message('To Time', name: 'toTime', desc: '', args: []);
  }

  /// `From Date`
  String get fromDate {
    return Intl.message('From Date', name: 'fromDate', desc: '', args: []);
  }

  /// `To Date`
  String get toDate {
    return Intl.message('To Date', name: 'toDate', desc: '', args: []);
  }

  /// `No pujas available`
  String get noPujaAvailable {
    return Intl.message(
      'No pujas available',
      name: 'noPujaAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Deities: `
  String get deitiesText {
    return Intl.message('Deities: ', name: 'deitiesText', desc: '', args: []);
  }

  /// `Description : `
  String get descriptionText {
    return Intl.message(
      'Description : ',
      name: 'descriptionText',
      desc: '',
      args: [],
    );
  }

  /// `Select Cut-off Notice`
  String get cutOffNoticeText {
    return Intl.message(
      'Select Cut-off Notice',
      name: 'cutOffNoticeText',
      desc: '',
      args: [],
    );
  }

  /// `From: `
  String get from {
    return Intl.message('From: ', name: 'from', desc: '', args: []);
  }

  /// `To: `
  String get to {
    return Intl.message('To: ', name: 'to', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inActive {
    return Intl.message('Inactive', name: 'inActive', desc: '', args: []);
  }

  /// `Max Devotees: `
  String get maxDevotee {
    return Intl.message(
      'Max Devotees: ',
      name: 'maxDevotee',
      desc: '',
      args: [],
    );
  }

  /// `Available Days :`
  String get availableDays {
    return Intl.message(
      'Available Days :',
      name: 'availableDays',
      desc: '',
      args: [],
    );
  }

  /// `Available Time Slots :`
  String get availableslot {
    return Intl.message(
      'Available Time Slots :',
      name: 'availableslot',
      desc: '',
      args: [],
    );
  }

  /// `View Images`
  String get viewImg {
    return Intl.message('View Images', name: 'viewImg', desc: '', args: []);
  }

  /// `No available time slots`
  String get noAvailableSlot {
    return Intl.message(
      'No available time slots',
      name: 'noAvailableSlot',
      desc: '',
      args: [],
    );
  }

  /// `Hide Details`
  String get hideDetails {
    return Intl.message(
      'Hide Details',
      name: 'hideDetails',
      desc: '',
      args: [],
    );
  }

  /// `View & Approve`
  String get viewAndApprove {
    return Intl.message(
      'View & Approve',
      name: 'viewAndApprove',
      desc: '',
      args: [],
    );
  }

  /// `Approve`
  String get approve {
    return Intl.message('Approve', name: 'approve', desc: '', args: []);
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Previous Data`
  String get previousData {
    return Intl.message(
      'Previous Data',
      name: 'previousData',
      desc: '',
      args: [],
    );
  }

  /// `Changes Data`
  String get changesData {
    return Intl.message(
      'Changes Data',
      name: 'changesData',
      desc: '',
      args: [],
    );
  }

  /// `Add comment for rejection`
  String get reason {
    return Intl.message(
      'Add comment for rejection',
      name: 'reason',
      desc: '',
      args: [],
    );
  }

  /// `Rejection Comment (applies to all rejected fields)`
  String get rejectionComment {
    return Intl.message(
      'Rejection Comment (applies to all rejected fields)',
      name: 'rejectionComment',
      desc: '',
      args: [],
    );
  }

  /// `Special Requirements (allow user to add special requirements)`
  String get specialReq {
    return Intl.message(
      'Special Requirements (allow user to add special requirements)',
      name: 'specialReq',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'kn'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
