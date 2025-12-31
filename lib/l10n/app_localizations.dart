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

  /// Cancel button
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
  /// **'Integrated Professional Network'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Connect with elite dentists and international experts, participate in workshops and scientific sessions to exchange knowledge and develop your professional skills in dentistry.'**
  String get onboardingDescription2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Advanced Dental Exhibition'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Discover cutting-edge innovations and medical equipment at the comprehensive IDEC exhibition, and explore the latest technologies and advanced dental tools.'**
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
  /// **'Uploaded On'**
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

  /// From text for date ranges
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// To text for date ranges
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Days remaining text
  ///
  /// In en, this message translates to:
  /// **'days remaining'**
  String get daysRemaining;

  /// Hours remaining text
  ///
  /// In en, this message translates to:
  /// **'hours remaining'**
  String get hoursRemaining;

  /// Minutes remaining text
  ///
  /// In en, this message translates to:
  /// **'minutes remaining'**
  String get minutesRemaining;

  /// Under review status
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// Payment pending status
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// Active participant status
  ///
  /// In en, this message translates to:
  /// **'Active Participant'**
  String get activeParticipant;

  /// On hold status
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get onHold;

  /// Rejected status
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Registration status label
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get registrationStatus;

  /// Title for payment gateway selection
  ///
  /// In en, this message translates to:
  /// **'Select Payment Gateway'**
  String get selectPaymentGateway;

  /// Processing payment status
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processingPayment;

  /// Complete payment button
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// Payment success message
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get paymentSuccess;

  /// Payment failed message
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// Active participant message
  ///
  /// In en, this message translates to:
  /// **'You are now an active participant'**
  String get youAreNowActiveParticipant;

  /// No active gateways message
  ///
  /// In en, this message translates to:
  /// **'No active payment gateways available'**
  String get noActiveGateways;

  /// Invoice receipt title
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get invoiceReceipt;

  /// Receipt details title
  ///
  /// In en, this message translates to:
  /// **'Receipt Details'**
  String get receiptDetails;

  /// Invoice number label
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// Conference or course label
  ///
  /// In en, this message translates to:
  /// **'Conference/Course'**
  String get conferenceOrCourse;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Issue date label
  ///
  /// In en, this message translates to:
  /// **'Issue Date'**
  String get issueDate;

  /// Due date label
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// Transaction details title
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// Transaction number label
  ///
  /// In en, this message translates to:
  /// **'Transaction Number'**
  String get transactionNumber;

  /// Payment gateway label
  ///
  /// In en, this message translates to:
  /// **'Payment Gateway'**
  String get paymentGateway;

  /// Payment method label
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Transaction date label
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// Completion date label
  ///
  /// In en, this message translates to:
  /// **'Completion Date'**
  String get completionDate;

  /// Share receipt button
  ///
  /// In en, this message translates to:
  /// **'Share Receipt'**
  String get shareReceipt;

  /// Back to home button
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// Payment input title
  ///
  /// In en, this message translates to:
  /// **'Payment Input'**
  String get paymentInput;

  /// Confirm payment button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmPayment;

  /// Enter payment code label
  ///
  /// In en, this message translates to:
  /// **'Enter Payment Code'**
  String get enterPaymentCode;

  /// Enter secret code label
  ///
  /// In en, this message translates to:
  /// **'Enter Secret Code'**
  String get enterSecretCode;

  /// Feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get featureComingSoon;

  /// Payment processing error message
  ///
  /// In en, this message translates to:
  /// **'Payment Processing Error'**
  String get paymentProcessingError;

  /// Gateway selection title
  ///
  /// In en, this message translates to:
  /// **'Select Payment Gateway'**
  String get gatewaySelectionTitle;

  /// Test mode label
  ///
  /// In en, this message translates to:
  /// **'Test Mode'**
  String get testMode;

  /// Production mode label
  ///
  /// In en, this message translates to:
  /// **'Production Mode'**
  String get productionMode;

  /// No description provided for @myDocuments.
  ///
  /// In en, this message translates to:
  /// **'My Documents'**
  String get myDocuments;

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents uploaded yet'**
  String get noDocuments;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name'**
  String get documentName;

  /// No description provided for @documentType.
  ///
  /// In en, this message translates to:
  /// **'Document Type'**
  String get documentType;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get fileSize;

  /// No description provided for @viewDocument.
  ///
  /// In en, this message translates to:
  /// **'View Document'**
  String get viewDocument;

  /// No description provided for @downloadDocument.
  ///
  /// In en, this message translates to:
  /// **'Download Document'**
  String get downloadDocument;

  /// No description provided for @shareDocument.
  ///
  /// In en, this message translates to:
  /// **'Share Document'**
  String get shareDocument;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @fullNameAr.
  ///
  /// In en, this message translates to:
  /// **'Full Name (Arabic)'**
  String get fullNameAr;

  /// No description provided for @fullNameEn.
  ///
  /// In en, this message translates to:
  /// **'Full Name (English)'**
  String get fullNameEn;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @workplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplace;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @graduationYear.
  ///
  /// In en, this message translates to:
  /// **'Graduation Year'**
  String get graduationYear;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @allCourses.
  ///
  /// In en, this message translates to:
  /// **'All Courses'**
  String get allCourses;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @availableCourses.
  ///
  /// In en, this message translates to:
  /// **'Available Courses'**
  String get availableCourses;

  /// No description provided for @registeredCourses.
  ///
  /// In en, this message translates to:
  /// **'Registered Courses'**
  String get registeredCourses;

  /// No description provided for @completedCourses.
  ///
  /// In en, this message translates to:
  /// **'Completed Courses'**
  String get completedCourses;

  /// No description provided for @upcomingCourses.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Courses'**
  String get upcomingCourses;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @courseName.
  ///
  /// In en, this message translates to:
  /// **'Course Name'**
  String get courseName;

  /// No description provided for @courseDescription.
  ///
  /// In en, this message translates to:
  /// **'Course Description'**
  String get courseDescription;

  /// No description provided for @courseInstructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get courseInstructor;

  /// No description provided for @courseDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get courseDuration;

  /// No description provided for @courseLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get courseLevel;

  /// No description provided for @coursePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get coursePrice;

  /// No description provided for @courseCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get courseCapacity;

  /// No description provided for @courseLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get courseLocation;

  /// No description provided for @courseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get courseDate;

  /// No description provided for @courseTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get courseTime;

  /// No description provided for @registerForCourse.
  ///
  /// In en, this message translates to:
  /// **'Register for Course'**
  String get registerForCourse;

  /// No description provided for @viewCourseDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewCourseDetails;

  /// No description provided for @noCourses.
  ///
  /// In en, this message translates to:
  /// **'No courses available'**
  String get noCourses;

  /// No description provided for @searchCourses.
  ///
  /// In en, this message translates to:
  /// **'Search courses'**
  String get searchCourses;

  /// No description provided for @filterCourses.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterCourses;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'seats'**
  String get seats;

  /// No description provided for @seatsAvailable.
  ///
  /// In en, this message translates to:
  /// **'seats available'**
  String get seatsAvailable;

  /// No description provided for @fullyBooked.
  ///
  /// In en, this message translates to:
  /// **'Fully Booked'**
  String get fullyBooked;

  /// No description provided for @allSpeakers.
  ///
  /// In en, this message translates to:
  /// **'All Speakers'**
  String get allSpeakers;

  /// No description provided for @featuredSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Featured Speakers'**
  String get featuredSpeakers;

  /// No description provided for @speakerDetails.
  ///
  /// In en, this message translates to:
  /// **'Speaker Details'**
  String get speakerDetails;

  /// No description provided for @speakerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get speakerName;

  /// No description provided for @speakerTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get speakerTitle;

  /// No description provided for @speakerBio.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get speakerBio;

  /// No description provided for @speakerSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get speakerSessions;

  /// No description provided for @noSpeakers.
  ///
  /// In en, this message translates to:
  /// **'No speakers available'**
  String get noSpeakers;

  /// No description provided for @searchSpeakers.
  ///
  /// In en, this message translates to:
  /// **'Search speakers'**
  String get searchSpeakers;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @allSessions.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get allSessions;

  /// No description provided for @mySessions.
  ///
  /// In en, this message translates to:
  /// **'My Sessions'**
  String get mySessions;

  /// No description provided for @upcomingSessions.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Sessions'**
  String get upcomingSessions;

  /// No description provided for @pastSessions.
  ///
  /// In en, this message translates to:
  /// **'Past Sessions'**
  String get pastSessions;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @sessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Title'**
  String get sessionTitle;

  /// No description provided for @sessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sessionDescription;

  /// No description provided for @sessionSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker'**
  String get sessionSpeaker;

  /// No description provided for @sessionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sessionDate;

  /// No description provided for @sessionTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get sessionTime;

  /// No description provided for @sessionLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get sessionLocation;

  /// No description provided for @sessionDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sessionDuration;

  /// No description provided for @joinSession.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get joinSession;

  /// No description provided for @addToCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to Calendar'**
  String get addToCalendar;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions available'**
  String get noSessions;

  /// No description provided for @searchSessions.
  ///
  /// In en, this message translates to:
  /// **'Search sessions'**
  String get searchSessions;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @myRegistrations.
  ///
  /// In en, this message translates to:
  /// **'My Registrations'**
  String get myRegistrations;

  /// No description provided for @activeRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeRegistrations;

  /// No description provided for @pendingRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingRegistrations;

  /// No description provided for @completedRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedRegistrations;

  /// No description provided for @cancelledRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledRegistrations;

  /// No description provided for @registrationDetails.
  ///
  /// In en, this message translates to:
  /// **'Registration Details'**
  String get registrationDetails;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDate;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paidAmount;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining Amount'**
  String get remainingAmount;

  /// No description provided for @viewReceipt.
  ///
  /// In en, this message translates to:
  /// **'View Receipt'**
  String get viewReceipt;

  /// No description provided for @downloadReceipt.
  ///
  /// In en, this message translates to:
  /// **'Download Receipt'**
  String get downloadReceipt;

  /// No description provided for @cancelRegistration.
  ///
  /// In en, this message translates to:
  /// **'Cancel Registration'**
  String get cancelRegistration;

  /// No description provided for @noRegistrations.
  ///
  /// In en, this message translates to:
  /// **'No registrations yet'**
  String get noRegistrations;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @partiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get partiallyPaid;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @latestNews.
  ///
  /// In en, this message translates to:
  /// **'Latest News'**
  String get latestNews;

  /// No description provided for @newsDetails.
  ///
  /// In en, this message translates to:
  /// **'News Details'**
  String get newsDetails;

  /// No description provided for @newsTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get newsTitle;

  /// No description provided for @newsContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get newsContent;

  /// No description provided for @publishedOn.
  ///
  /// In en, this message translates to:
  /// **'Published On'**
  String get publishedOn;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @noNews.
  ///
  /// In en, this message translates to:
  /// **'No news available'**
  String get noNews;

  /// No description provided for @searchNews.
  ///
  /// In en, this message translates to:
  /// **'Search news'**
  String get searchNews;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @videoGallery.
  ///
  /// In en, this message translates to:
  /// **'Video Gallery'**
  String get videoGallery;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @allPhotos.
  ///
  /// In en, this message translates to:
  /// **'All Photos'**
  String get allPhotos;

  /// No description provided for @allVideos.
  ///
  /// In en, this message translates to:
  /// **'All Videos'**
  String get allVideos;

  /// No description provided for @viewPhoto.
  ///
  /// In en, this message translates to:
  /// **'View Photo'**
  String get viewPhoto;

  /// No description provided for @viewVideo.
  ///
  /// In en, this message translates to:
  /// **'View Video'**
  String get viewVideo;

  /// No description provided for @downloadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadPhoto;

  /// No description provided for @sharePhoto.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get sharePhoto;

  /// No description provided for @noPhotos.
  ///
  /// In en, this message translates to:
  /// **'No photos available'**
  String get noPhotos;

  /// No description provided for @noVideos.
  ///
  /// In en, this message translates to:
  /// **'No videos available'**
  String get noVideos;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'photos'**
  String get photos;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'videos'**
  String get videos;

  /// No description provided for @allNotifications.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allNotifications;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unreadNotifications;

  /// No description provided for @readNotifications.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get readNotifications;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All as Read'**
  String get markAllAsRead;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteNotification;

  /// No description provided for @deleteAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAllNotifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendMessage;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessages;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'typing...'**
  String get typing;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @attachFile.
  ///
  /// In en, this message translates to:
  /// **'Attach File'**
  String get attachFile;

  /// No description provided for @attachPhoto.
  ///
  /// In en, this message translates to:
  /// **'Attach Photo'**
  String get attachPhoto;

  /// No description provided for @attachVideo.
  ///
  /// In en, this message translates to:
  /// **'Attach Video'**
  String get attachVideo;

  /// No description provided for @voiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Voice Message'**
  String get voiceMessage;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @requirements.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get requirements;

  /// No description provided for @certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get certificate;

  /// No description provided for @certified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get certified;

  /// No description provided for @instructor.
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;
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
