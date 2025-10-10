import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'IDEC Dental Conference & Exhibition'**
  String get appTitle;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Select language screen title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Governorate field label
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// Qualification field label
  ///
  /// In en, this message translates to:
  /// **'Qualification'**
  String get qualification;

  /// OTP verification screen title
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// OTP instruction text
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code sent to your phone'**
  String get enterOtp;

  /// Verify button text
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// Resend OTP button text
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// Logout button in confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutButton;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Connection status screen title
  ///
  /// In en, this message translates to:
  /// **'Connection Status'**
  String get connectionStatus;

  /// Connected status
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// Disconnected status
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No internet connection message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error occurred'**
  String get serverError;

  /// Invalid credentials error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// Password too short validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Get started button text
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome to IDEC 2026'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Join the IDEC Dental Conference & Exhibition and connect with dentists, specialists, and innovators from around the world.'**
  String get onboardingDescription1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Connect & Network'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Build professional connections with fellow attendees, share experiences, and collaborate on advancing the field of dentistry.'**
  String get onboardingDescription2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Exhibition & Trade'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Explore the latest technologies and products in dentistry through our trade exhibition and interactive demonstrations.'**
  String get onboardingDescription3;

  /// No description provided for @onboardingPage3Description.
  ///
  /// In en, this message translates to:
  /// **'Explore the latest products and technologies in the dental exhibition'**
  String get onboardingPage3Description;

  /// Name too short validation message
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// Phone number too short validation message
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 10 digits'**
  String get phoneTooShort;

  /// Terms and conditions text
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Privacy policy text
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// OTP sent success message
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSentSuccessfully;

  /// Please accept terms validation message
  ///
  /// In en, this message translates to:
  /// **'Please accept terms and conditions'**
  String get pleaseAcceptTerms;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @viewSchedule.
  ///
  /// In en, this message translates to:
  /// **'View Schedule'**
  String get viewSchedule;

  /// No description provided for @speakers.
  ///
  /// In en, this message translates to:
  /// **'Speakers'**
  String get speakers;

  /// No description provided for @viewSpeakers.
  ///
  /// In en, this message translates to:
  /// **'View Speakers'**
  String get viewSpeakers;

  /// No description provided for @exhibition.
  ///
  /// In en, this message translates to:
  /// **'Exhibition'**
  String get exhibition;

  /// No description provided for @viewExhibition.
  ///
  /// In en, this message translates to:
  /// **'View Exhibition'**
  String get viewExhibition;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @viewNotifications.
  ///
  /// In en, this message translates to:
  /// **'View Notifications'**
  String get viewNotifications;

  /// No description provided for @recentUpdates.
  ///
  /// In en, this message translates to:
  /// **'Recent Updates'**
  String get recentUpdates;

  /// No description provided for @conferenceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Conference Update'**
  String get conferenceUpdate;

  /// No description provided for @conferenceUpdateDesc.
  ///
  /// In en, this message translates to:
  /// **'New sessions added to the conference'**
  String get conferenceUpdateDesc;

  /// No description provided for @newSpeaker.
  ///
  /// In en, this message translates to:
  /// **'New Speaker'**
  String get newSpeaker;

  /// No description provided for @newSpeakerDesc.
  ///
  /// In en, this message translates to:
  /// **'A new speaker has joined the conference'**
  String get newSpeakerDesc;

  /// No description provided for @scheduleChange.
  ///
  /// In en, this message translates to:
  /// **'Schedule Change'**
  String get scheduleChange;

  /// No description provided for @scheduleChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Some session times have been updated'**
  String get scheduleChangeDesc;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @scheduleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Schedule will be added soon'**
  String get scheduleComingSoon;

  /// No description provided for @speakersComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Speakers list will be added soon'**
  String get speakersComingSoon;

  /// No description provided for @exhibitionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Exhibition information will be added soon'**
  String get exhibitionComingSoon;

  /// Create account subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccount;

  /// First name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// Last name field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// Phone number field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// Confirm password field hint
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Accept terms checkbox text
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms and Conditions and Privacy Policy'**
  String get acceptTerms;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Verify email screen title
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyEmail;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Phone'**
  String get verifyPhone;

  /// Verification code sent message
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to'**
  String get verificationCodeSent;

  /// Didn't receive code text
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveCode;

  /// Resend button text
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Resend countdown text
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// Clear code button text
  ///
  /// In en, this message translates to:
  /// **'Clear Code'**
  String get clearCode;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// OR divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Invalid OTP code error message
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code'**
  String get invalidOtpCode;

  /// OTP expired error message
  ///
  /// In en, this message translates to:
  /// **'OTP code has expired'**
  String get otpExpired;

  /// Too many OTP attempts error message
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please request a new code'**
  String get tooManyAttempts;

  /// Edit profile screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// Save changes button text
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Bio field label
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// Bio field hint
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellAboutYourself;

  /// Security option title
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Security option subtitle
  ///
  /// In en, this message translates to:
  /// **'Change password and security settings'**
  String get securitySubtitle;

  /// Change language subtitle
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeLanguage;

  /// Check connection subtitle
  ///
  /// In en, this message translates to:
  /// **'Check your connection'**
  String get checkConnection;

  /// Help and support option title
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help and support option subtitle
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get helpSupportSubtitle;

  /// About option title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// About option subtitle
  ///
  /// In en, this message translates to:
  /// **'App version and information'**
  String get aboutSubtitle;

  /// Update personal info subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// Press back again to exit message
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get pressBackAgainToExit;

  /// Exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Connection test screen title
  ///
  /// In en, this message translates to:
  /// **'Connection Test'**
  String get connectionTest;

  /// Checking connection message
  ///
  /// In en, this message translates to:
  /// **'Checking connection...'**
  String get checkingConnection;

  /// Please wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get pleaseWait;

  /// Excellent quality
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// Good quality
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// Fair quality
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// Poor quality
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No connection status
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// Network information section title
  ///
  /// In en, this message translates to:
  /// **'Network Information'**
  String get networkInfo;

  /// Server information section title
  ///
  /// In en, this message translates to:
  /// **'Server Information'**
  String get serverInfo;

  /// Test results section title
  ///
  /// In en, this message translates to:
  /// **'Test Results'**
  String get testResults;

  /// Speed test section title
  ///
  /// In en, this message translates to:
  /// **'Speed Test'**
  String get speedTest;

  /// Connection history section title
  ///
  /// In en, this message translates to:
  /// **'Connection History'**
  String get connectionHistory;

  /// Start test button
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get startTest;

  /// Download speed label
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Upload speed label
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// Ping label
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get ping;

  /// Jitter label
  ///
  /// In en, this message translates to:
  /// **'Jitter'**
  String get jitter;

  /// Connection type label
  ///
  /// In en, this message translates to:
  /// **'Connection Type'**
  String get connectionType;

  /// Network name label
  ///
  /// In en, this message translates to:
  /// **'Network Name'**
  String get networkName;

  /// IP address label
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// Signal strength label
  ///
  /// In en, this message translates to:
  /// **'Signal Strength'**
  String get signalStrength;

  /// Server address label
  ///
  /// In en, this message translates to:
  /// **'Server Address'**
  String get serverAddress;

  /// Port label
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// Status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Response time label
  ///
  /// In en, this message translates to:
  /// **'Response Time'**
  String get responseTime;

  /// Server version label
  ///
  /// In en, this message translates to:
  /// **'Server Version'**
  String get serverVersion;

  /// Last error label
  ///
  /// In en, this message translates to:
  /// **'Last Error'**
  String get lastError;

  /// Available status
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Unavailable status
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// WiFi connection type
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get wifi;

  /// Mobile data connection type
  ///
  /// In en, this message translates to:
  /// **'Mobile Data'**
  String get mobileData;

  /// Ethernet connection type
  ///
  /// In en, this message translates to:
  /// **'Ethernet'**
  String get ethernet;

  /// Bluetooth connection type
  ///
  /// In en, this message translates to:
  /// **'Bluetooth'**
  String get bluetooth;

  /// VPN connection type
  ///
  /// In en, this message translates to:
  /// **'VPN'**
  String get vpn;

  /// Other connection type
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Internet connectivity test
  ///
  /// In en, this message translates to:
  /// **'Internet Connectivity'**
  String get internetConnectivity;

  /// DNS resolution test
  ///
  /// In en, this message translates to:
  /// **'DNS Resolution'**
  String get dnsResolution;

  /// Server ping test
  ///
  /// In en, this message translates to:
  /// **'Server Ping'**
  String get serverPing;

  /// API endpoints test
  ///
  /// In en, this message translates to:
  /// **'API Endpoints'**
  String get apiEndpoints;

  /// Network indicator
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Server indicator
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// Internet indicator
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get internet;

  /// Connection test failed message
  ///
  /// In en, this message translates to:
  /// **'Connection test failed'**
  String get connectionTestFailed;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Speed test failed message
  ///
  /// In en, this message translates to:
  /// **'Speed test failed'**
  String get speedTestFailed;

  /// Click start test instruction
  ///
  /// In en, this message translates to:
  /// **'Click \'Start Test\' to measure connection speed'**
  String get clickStartTestToMeasure;

  /// Connection history placeholder
  ///
  /// In en, this message translates to:
  /// **'Connection history will be shown here'**
  String get connectionHistoryWillBeShown;

  /// Exit app dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitAppTitle;

  /// Exit app dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitAppMessage;

  /// Server configuration screen title
  ///
  /// In en, this message translates to:
  /// **'Server Configuration'**
  String get serverConfiguration;

  /// Server URL field label
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// Server port field label
  ///
  /// In en, this message translates to:
  /// **'Server Port'**
  String get serverPort;

  /// Server URL field hint
  ///
  /// In en, this message translates to:
  /// **'Enter server URL'**
  String get enterServerUrl;

  /// Server port field hint
  ///
  /// In en, this message translates to:
  /// **'Enter server port'**
  String get enterServerPort;

  /// Invalid URL validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get invalidUrl;

  /// Invalid port validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid port number'**
  String get invalidPort;

  /// Port range validation message
  ///
  /// In en, this message translates to:
  /// **'Port must be between 1 and 65535'**
  String get portRange;

  /// Test connection button text
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get testConnection;

  /// Save configuration button text
  ///
  /// In en, this message translates to:
  /// **'Save Configuration'**
  String get saveConfiguration;

  /// Reset to default button text
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// Configuration saved success message
  ///
  /// In en, this message translates to:
  /// **'Configuration saved successfully'**
  String get configurationSaved;

  /// Configuration save failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to save configuration'**
  String get configurationFailed;

  /// Reset configuration dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Configuration'**
  String get resetConfiguration;

  /// Reset configuration dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset to default settings?'**
  String get resetConfigurationMessage;

  /// Current configuration section title
  ///
  /// In en, this message translates to:
  /// **'Current Configuration'**
  String get currentConfiguration;

  /// Default configuration section title
  ///
  /// In en, this message translates to:
  /// **'Default Configuration'**
  String get defaultConfiguration;

  /// Testing connection message
  ///
  /// In en, this message translates to:
  /// **'Testing connection...'**
  String get testingConnection;

  /// Connection successful message
  ///
  /// In en, this message translates to:
  /// **'Connection successful'**
  String get connectionSuccessful;

  /// Connection failed message
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// Server reachable message
  ///
  /// In en, this message translates to:
  /// **'Server is reachable'**
  String get serverReachable;

  /// Server unreachable message
  ///
  /// In en, this message translates to:
  /// **'Server is unreachable'**
  String get serverUnreachable;

  /// Please verify account message
  ///
  /// In en, this message translates to:
  /// **'Please verify your account'**
  String get pleaseVerifyAccount;

  /// Account under review message
  ///
  /// In en, this message translates to:
  /// **'Account under review'**
  String get accountUnderReview;

  /// Tap to complete profile message
  ///
  /// In en, this message translates to:
  /// **'Tap to complete your profile'**
  String get tapToCompleteProfile;

  /// Account rejected message
  ///
  /// In en, this message translates to:
  /// **'Account rejected, please update your information'**
  String get accountRejectedPleaseUpdate;

  /// Please complete profile message
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile'**
  String get pleaseCompleteProfile;

  /// Maintenance mode title
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceMode;

  /// Maintenance mode message
  ///
  /// In en, this message translates to:
  /// **'The app is under maintenance. Please try again later.'**
  String get maintenanceMessage;

  /// Estimated time label
  ///
  /// In en, this message translates to:
  /// **'Estimated Time'**
  String get estimatedTime;

  /// Check back later button
  ///
  /// In en, this message translates to:
  /// **'Check Back Later'**
  String get checkBackLater;

  /// Request timeout error message
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get requestTimeout;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// Retry upload button
  ///
  /// In en, this message translates to:
  /// **'Retry Upload'**
  String get retryUpload;

  /// Upload progress message
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploadProgress;

  /// Upload complete message
  ///
  /// In en, this message translates to:
  /// **'Upload Complete'**
  String get uploadComplete;

  /// Upload cancelled message
  ///
  /// In en, this message translates to:
  /// **'Upload Cancelled'**
  String get uploadCancelled;

  /// Operation failed message
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// Try again later message
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get tryAgainLater;

  /// Connection lost message
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get connectionLost;

  /// Reconnecting message
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// Offline mode indicator
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offlineMode;

  /// Queued operations label
  ///
  /// In en, this message translates to:
  /// **'Queued Operations'**
  String get queuedOperations;

  /// Sync pending message
  ///
  /// In en, this message translates to:
  /// **'Sync Pending'**
  String get syncPending;

  /// Select OTP channel title
  ///
  /// In en, this message translates to:
  /// **'Select Verification Method'**
  String get selectOtpChannel;

  /// SMS OTP channel
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get otpChannelSms;

  /// WhatsApp OTP channel
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get otpChannelWhatsapp;

  /// Email OTP channel
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get otpChannelEmail;

  /// Registration open status
  ///
  /// In en, this message translates to:
  /// **'Registration Open'**
  String get registrationOpen;

  /// Registration closed status
  ///
  /// In en, this message translates to:
  /// **'Registration Closed'**
  String get registrationClosed;

  /// Registration limited status
  ///
  /// In en, this message translates to:
  /// **'Registration Limited'**
  String get registrationLimited;

  /// Contact support button
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Next available time label
  ///
  /// In en, this message translates to:
  /// **'Next Available'**
  String get nextAvailable;

  /// Choose verification method instruction
  ///
  /// In en, this message translates to:
  /// **'Choose how to receive your verification code'**
  String get chooseVerificationMethod;

  /// Send to phone number text
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// Server not available error message
  ///
  /// In en, this message translates to:
  /// **'Server is not available'**
  String get serverNotAvailable;

  /// Session expired error message
  ///
  /// In en, this message translates to:
  /// **'Your session has expired'**
  String get sessionExpired;

  /// File too large error message
  ///
  /// In en, this message translates to:
  /// **'File is too large'**
  String get fileTooLarge;

  /// Invalid file type error message
  ///
  /// In en, this message translates to:
  /// **'Invalid file type'**
  String get invalidFileType;

  /// Upload failed error message
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// Please check internet connection message
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get pleaseCheckInternet;

  /// Delete document button text
  ///
  /// In en, this message translates to:
  /// **'Delete Document'**
  String get deleteDocument;

  /// Confirmation message for deleting a document
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the document?'**
  String get deleteDocumentConfirmation;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Account verified status
  ///
  /// In en, this message translates to:
  /// **'Account Verified'**
  String get accountVerified;

  /// Verification pending status
  ///
  /// In en, this message translates to:
  /// **'Verification Pending'**
  String get verificationPending;

  /// Verification rejected status
  ///
  /// In en, this message translates to:
  /// **'Verification Rejected'**
  String get verificationRejected;

  /// Account not verified status
  ///
  /// In en, this message translates to:
  /// **'Account Not Verified'**
  String get accountNotVerified;

  /// Description for verified account
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully verified'**
  String get verifiedAccountDescription;

  /// Description for pending verification
  ///
  /// In en, this message translates to:
  /// **'Your account is under review'**
  String get pendingVerificationDescription;

  /// Description for rejected verification
  ///
  /// In en, this message translates to:
  /// **'Your verification request has been rejected'**
  String get rejectedVerificationDescription;

  /// Description for unverified account
  ///
  /// In en, this message translates to:
  /// **'Your account is not verified'**
  String get unverifiedAccountDescription;

  /// Verification status label
  ///
  /// In en, this message translates to:
  /// **'Verification Status'**
  String get verificationStatus;

  /// Rejection reason label
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// Last updated label
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Verified status
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// Pending verification status
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pendingVerification;

  /// Unverified status
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// Replace document button text
  ///
  /// In en, this message translates to:
  /// **'Replace Document'**
  String get replaceDocument;

  /// Uploaded on date label
  ///
  /// In en, this message translates to:
  /// **'Uploaded on'**
  String get uploadedOn;

  /// Select image source dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// Gallery option for image picker
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Camera option for image picker
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Invalid image format error message
  ///
  /// In en, this message translates to:
  /// **'Invalid image format. Please select a JPG or PNG image'**
  String get invalidImageFormat;

  /// Image too large error message
  ///
  /// In en, this message translates to:
  /// **'Image is too large. Maximum size is 5MB'**
  String get imageTooLarge;

  /// Server settings title
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// Edit server settings button text
  ///
  /// In en, this message translates to:
  /// **'Edit Server Settings'**
  String get editServerSettings;

  /// Server host field label
  ///
  /// In en, this message translates to:
  /// **'Server Host'**
  String get serverHost;

  /// Server port number field label
  ///
  /// In en, this message translates to:
  /// **'Port Number'**
  String get serverPortNumber;

  /// Main server button text
  ///
  /// In en, this message translates to:
  /// **'Main Server'**
  String get mainServer;

  /// Local server button text
  ///
  /// In en, this message translates to:
  /// **'Local Server'**
  String get localServer;

  /// Save server settings button text
  ///
  /// In en, this message translates to:
  /// **'Save Server Settings'**
  String get saveServerSettings;

  /// Server settings saved success message
  ///
  /// In en, this message translates to:
  /// **'Server settings saved successfully'**
  String get serverSettingsSaved;

  /// Server settings save failed message
  ///
  /// In en, this message translates to:
  /// **'Failed to save server settings'**
  String get serverSettingsFailed;

  /// Invalid server host error message
  ///
  /// In en, this message translates to:
  /// **'Invalid server host'**
  String get invalidServerHost;

  /// Invalid server port error message
  ///
  /// In en, this message translates to:
  /// **'Invalid server port'**
  String get invalidServerPort;

  /// Enter valid host validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid server host'**
  String get enterValidHost;

  /// Enter valid port validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid port number (1-65535)'**
  String get enterValidPort;

  /// Current server settings label
  ///
  /// In en, this message translates to:
  /// **'Current Server Settings'**
  String get currentServerSettings;

  /// Saving settings loading message
  ///
  /// In en, this message translates to:
  /// **'Saving settings...'**
  String get savingSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
