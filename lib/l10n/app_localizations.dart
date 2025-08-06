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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get technicalSupport;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Technical Support Service'**
  String get welcomeMessage;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'You can contact our support team to solve any problem you face'**
  String get supportDescription;

  /// No description provided for @startNewChat.
  ///
  /// In en, this message translates to:
  /// **'Start New Conversation'**
  String get startNewChat;

  /// No description provided for @previousConversations.
  ///
  /// In en, this message translates to:
  /// **'Previous Conversations'**
  String get previousConversations;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No previous conversations'**
  String get noConversations;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get deleteConversation;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this conversation?'**
  String get deleteConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @supportTeam.
  ///
  /// In en, this message translates to:
  /// **'Technical Support Team'**
  String get supportTeam;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @startChatWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Start chat with support'**
  String get startChatWithSupport;

  /// No description provided for @supportChat.
  ///
  /// In en, this message translates to:
  /// **'Support Chat'**
  String get supportChat;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @newMessage.
  ///
  /// In en, this message translates to:
  /// **'New Message'**
  String get newMessage;

  /// No description provided for @supportReply.
  ///
  /// In en, this message translates to:
  /// **'Support Reply'**
  String get supportReply;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message?'**
  String get confirmDeleteMessage;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in'**
  String get notLoggedIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get enterRegisteredEmail;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailAddress;

  /// No description provided for @checkSpamNote.
  ///
  /// In en, this message translates to:
  /// **'* Check your spam folder if you don\'t find the reset email.'**
  String get checkSpamNote;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createYourAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Email is already registered'**
  String get emailAlreadyExists;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhone;

  /// No description provided for @shortPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is too short'**
  String get shortPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get weakPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @registrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Registration is currently disabled'**
  String get registrationDisabled;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'This email is not registered'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get wrongPassword;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please check your credentials.'**
  String get loginError;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmail;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get shortPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @confirmDeleteChat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get confirmDeleteChat;

  /// No description provided for @supportDashboard.
  ///
  /// In en, this message translates to:
  /// **'Support Dashboard'**
  String get supportDashboard;

  /// No description provided for @noOpenChats.
  ///
  /// In en, this message translates to:
  /// **'No open chats at the moment'**
  String get noOpenChats;

  /// No description provided for @noMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages'**
  String get noMessages;

  /// No description provided for @attachImage.
  ///
  /// In en, this message translates to:
  /// **'Attach Image'**
  String get attachImage;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get addressHint;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a description for your request'**
  String get descriptionHint;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @pickupAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Address'**
  String get pickupAddressLabel;

  /// No description provided for @pickupAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pickup address'**
  String get pickupAddressHint;

  /// No description provided for @pickupAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter pickup address'**
  String get pickupAddressRequired;

  /// No description provided for @dropoffAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Dropoff Address'**
  String get dropoffAddressLabel;

  /// No description provided for @dropoffAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter dropoff address'**
  String get dropoffAddressHint;

  /// No description provided for @dropoffAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter dropoff address'**
  String get dropoffAddressRequired;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get ageHint;

  /// No description provided for @symptomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Symptoms or Complaint'**
  String get symptomsLabel;

  /// No description provided for @symptomsHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your symptoms in detail'**
  String get symptomsHint;

  /// No description provided for @medicineLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine or Prescription'**
  String get medicineLabel;

  /// No description provided for @medicineHint.
  ///
  /// In en, this message translates to:
  /// **'Enter medicine name or upload prescription'**
  String get medicineHint;

  /// No description provided for @foodItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Requested Items'**
  String get foodItemsLabel;

  /// No description provided for @foodItemsHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the items you want to order'**
  String get foodItemsHint;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @enterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get enterYourPhone;

  /// No description provided for @enterYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterYourAddress;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @dateNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Date not available'**
  String get dateNotAvailable;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

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

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @attachedImage.
  ///
  /// In en, this message translates to:
  /// **'Attached Image'**
  String get attachedImage;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @yourRequestHasBeen.
  ///
  /// In en, this message translates to:
  /// **'Your request has been'**
  String get yourRequestHasBeen;

  /// No description provided for @unknownName.
  ///
  /// In en, this message translates to:
  /// **'Unknown Name'**
  String get unknownName;

  /// No description provided for @noAddress.
  ///
  /// In en, this message translates to:
  /// **'No address provided'**
  String get noAddress;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No phone number'**
  String get noPhone;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description provided'**
  String get noDescription;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @noNewRequests.
  ///
  /// In en, this message translates to:
  /// **'No new requests'**
  String get noNewRequests;

  /// No description provided for @noAcceptedRequests.
  ///
  /// In en, this message translates to:
  /// **'No accepted requests'**
  String get noAcceptedRequests;

  /// No description provided for @noRejectedRequests.
  ///
  /// In en, this message translates to:
  /// **'No rejected requests'**
  String get noRejectedRequests;

  /// No description provided for @noRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests'**
  String get noRequests;

  /// No description provided for @noCurrentlyRequests.
  ///
  /// In en, this message translates to:
  /// **'No current requests'**
  String get noCurrentlyRequests;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your address'**
  String get enterAddress;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdatingProfile;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deliverParcel.
  ///
  /// In en, this message translates to:
  /// **'Deliver Your Parcel'**
  String get deliverParcel;

  /// No description provided for @doctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get doctors;

  /// No description provided for @dentist.
  ///
  /// In en, this message translates to:
  /// **'Dentist'**
  String get dentist;

  /// No description provided for @internal.
  ///
  /// In en, this message translates to:
  /// **'Internal'**
  String get internal;

  /// No description provided for @pediatrics.
  ///
  /// In en, this message translates to:
  /// **'Pediatrics'**
  String get pediatrics;

  /// No description provided for @orthopedic.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic'**
  String get orthopedic;

  /// No description provided for @dermatology.
  ///
  /// In en, this message translates to:
  /// **'Dermatology'**
  String get dermatology;

  /// No description provided for @ophthalmology.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmology'**
  String get ophthalmology;

  /// No description provided for @ent.
  ///
  /// In en, this message translates to:
  /// **'ENT'**
  String get ent;

  /// No description provided for @psychiatry.
  ///
  /// In en, this message translates to:
  /// **'Psychiatry'**
  String get psychiatry;

  /// No description provided for @pharmacies.
  ///
  /// In en, this message translates to:
  /// **'Pharmacies'**
  String get pharmacies;

  /// No description provided for @humanPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Human Pharmacy'**
  String get humanPharmacy;

  /// No description provided for @vetPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Pharmacy'**
  String get vetPharmacy;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @grocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery Store'**
  String get grocery;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @fastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get fastFood;

  /// No description provided for @traditionalFood.
  ///
  /// In en, this message translates to:
  /// **'Traditional Food'**
  String get traditionalFood;

  /// No description provided for @deliverYourParcel.
  ///
  /// In en, this message translates to:
  /// **'Deliver Your Parcel'**
  String get deliverYourParcel;

  /// No description provided for @veterinaryPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Pharmacy'**
  String get veterinaryPharmacy;

  /// No description provided for @groceryStore.
  ///
  /// In en, this message translates to:
  /// **'Grocery Store'**
  String get groceryStore;

  /// No description provided for @freeShippingTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Shipping'**
  String get freeShippingTitle;

  /// No description provided for @freeShippingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'First 10 orders only'**
  String get freeShippingSubtitle;

  /// No description provided for @limitedOfferTag.
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limitedOfferTag;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @discount20Title.
  ///
  /// In en, this message translates to:
  /// **'20% Discount'**
  String get discount20Title;

  /// No description provided for @discount20Subtitle.
  ///
  /// In en, this message translates to:
  /// **'For doctors & medical Services'**
  String get discount20Subtitle;

  /// No description provided for @medicalSpecialTag.
  ///
  /// In en, this message translates to:
  /// **'Medical Special'**
  String get medicalSpecialTag;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @discount10Title.
  ///
  /// In en, this message translates to:
  /// **'10% Discount'**
  String get discount10Title;

  /// No description provided for @discount10Subtitle.
  ///
  /// In en, this message translates to:
  /// **'In partner restaurants'**
  String get discount10Subtitle;

  /// No description provided for @diningOfferTag.
  ///
  /// In en, this message translates to:
  /// **'Dining Offer'**
  String get diningOfferTag;

  /// No description provided for @reserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve Now'**
  String get reserveNow;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be logged in first'**
  String get loginRequired;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications currently'**
  String get noNotifications;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitle;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No Content'**
  String get noContent;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Your Location'**
  String get selectLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @addResponse.
  ///
  /// In en, this message translates to:
  /// **'Add Response'**
  String get addResponse;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @expectedTime.
  ///
  /// In en, this message translates to:
  /// **'Expected Time'**
  String get expectedTime;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @responseSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Response submitted successfully'**
  String get responseSubmittedSuccessfully;

  /// No description provided for @responseSubmissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit response'**
  String get responseSubmissionFailed;

  /// No description provided for @requestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Request Accepted'**
  String get requestAccepted;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected'**
  String get requestRejected;

  /// No description provided for @serviceType.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get serviceType;

  /// No description provided for @enterReason.
  ///
  /// In en, this message translates to:
  /// **'Enter rejection reason...'**
  String get enterReason;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @providerNote.
  ///
  /// In en, this message translates to:
  /// **'Provider Note'**
  String get providerNote;

  /// No description provided for @deliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery Time'**
  String get deliveryTime;

  /// No description provided for @servicePrice.
  ///
  /// In en, this message translates to:
  /// **'Service Price'**
  String get servicePrice;

  /// No description provided for @acceptDelivery.
  ///
  /// In en, this message translates to:
  /// **'Accept Delivery '**
  String get acceptDelivery;

  /// No description provided for @noNewDeliveryRequests.
  ///
  /// In en, this message translates to:
  /// **'No New Delivery Requests'**
  String get noNewDeliveryRequests;

  /// No description provided for @noAssignedRequests.
  ///
  /// In en, this message translates to:
  /// **'No Assigned Requests'**
  String get noAssignedRequests;

  /// No description provided for @noCompletedDeliveries.
  ///
  /// In en, this message translates to:
  /// **'No Completed Deliveries'**
  String get noCompletedDeliveries;
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
