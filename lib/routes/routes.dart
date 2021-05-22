import 'package:fixy_mobile/advertisements/advertisement_details_page.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_category_details_page.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_details.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_location_details_page.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_service_category_page.dart';
import 'package:fixy_mobile/dashboard/customer/dashboard_customer_page.dart';
import 'package:fixy_mobile/dashboard/service_provider/dashboard_page.dart';
import 'package:fixy_mobile/landing_page.dart';
import 'package:fixy_mobile/login/forgot_password_page.dart';
import 'package:fixy_mobile/login/login_page.dart';
import 'package:fixy_mobile/signup/customer/signup_personal_details_customer_page.dart';
import 'package:fixy_mobile/signup/service_provider/signup_company_details_page.dart';
import 'package:fixy_mobile/signup/service_provider/signup_description_page.dart';
import 'package:fixy_mobile/signup/service_provider/signup_personal_details_page.dart';
import 'package:fixy_mobile/signup/service_provider/signup_select_service_page.dart';
import 'package:fixy_mobile/signup/signup_login_info_page.dart';
import 'package:fixy_mobile/signup/signup_otp_page.dart';
import 'package:fixy_mobile/signup/signup_otp_verification_page.dart';
import 'package:fixy_mobile/signup/signup_profile_picture_upload_page.dart';
import 'package:fixy_mobile/signup/signup_terms_and_conditions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/landing_page':
        return PageTransition(
            child: LandingPage(), type: PageTransitionType.topToBottom);
      case '/login_page':
        return PageTransition(
            child: LoginPage(), type: PageTransitionType.bottomToTop);
      case '/signup_select_service':
        return PageTransition(
          child: SignupSelectService(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: Duration(milliseconds: 10),
        );
      case '/signup_personal_details':
        final SignupPersonalDetailsPage arguments = args;
        return PageTransition(
            child: SignupPersonalDetailsPage(
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_personal_details_customer':
        return PageTransition(
            child: SignupPersonalDetailsCustomerPage(),
            type: PageTransitionType.rightToLeft);
      case '/otp':
        final SignupOTPPage arguments = args;
        return PageTransition(
            child: SignupOTPPage(
              formData: arguments.formData,
              userType: arguments.userType,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/otp_verification':
        final SignupOTPVerificationPage arguments = args;
        return PageTransition(
            duration: Duration(milliseconds: 10),
            reverseDuration: Duration(milliseconds: 10),
            child: SignupOTPVerificationPage(
              formData: arguments.formData,
              verificationId: arguments.verificationId,
              userType: arguments.userType,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_login_info':
        final SignupLoginInfoPage arguments = args;
        return PageTransition(
            child: SignupLoginInfoPage(
              formData: arguments.formData,
              userType: arguments.userType,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_description':
        final SignupDescriptionPage arguments = args;
        return PageTransition(
            child: SignupDescriptionPage(
              formData: arguments.formData,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_profile_picture_upload':
        final SignupProfilePictureUploadPage arguments = args;
        return PageTransition(
            child: SignupProfilePictureUploadPage(
              formData: arguments.formData,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_terms_and_conditions':
        final SignupTermsAndConditionsPage arguments = args;
        return PageTransition(
            child: SignupTermsAndConditionsPage(
              formData: arguments.formData,
            ),
            type: PageTransitionType.rightToLeft);
      case '/signup_company_details':
        final SignupCompanyDetailsPage arguments = args;
        return PageTransition(
            child: SignupCompanyDetailsPage(
              formData: arguments.formData,
              serviceType: arguments.serviceType,
            ),
            type: PageTransitionType.rightToLeft);
      case '/dashboard':
        return PageTransition(
            child: DashboardPage(),
            type: PageTransitionType.rightToLeftWithFade);
      case '/dashboard_customer':
        return PageTransition(
            child: DashboardCustomerPage(),
            type: PageTransitionType.rightToLeftWithFade);
      case '/forgot_password':
        return PageTransition(
            child: ForgotPasswordPage(), type: PageTransitionType.fade);
      case '/create_advertisements_details':
        final CreateAdvertisementDetailsPage arguments = args;
        return PageTransition(
            child: CreateAdvertisementDetailsPage(
                advertisement: arguments.advertisement),
            type: PageTransitionType.rightToLeft);
      case '/create_advertisements_service_category':
        final CreateAdvertisementServiceCategoryPage arguments = args;
        return PageTransition(
            child: CreateAdvertisementServiceCategoryPage(
              formData: arguments.formData,
              advertisement: arguments.advertisement,
            ),
            type: PageTransitionType.rightToLeft);
      case '/create_advertisements_category_details':
        final CreateAdvertisementCategoryDetailsPage arguments = args;
        return PageTransition(
            child: CreateAdvertisementCategoryDetailsPage(
              formData: arguments.formData,
              advertisement: arguments.advertisement,
            ),
            type: PageTransitionType.rightToLeft);
      case '/create_advertisements_location_details':
        final CreateAdvertisementLocationDetailsPage arguments = args;
        return PageTransition(
            child: CreateAdvertisementLocationDetailsPage(
              formData: arguments.formData,
              advertisement: arguments.advertisement,
            ),
            type: PageTransitionType.rightToLeft);
      case '/advertisement_details':
        final AdvertisementDetailsPage arguments = args;
        return PageTransition(
            child: AdvertisementDetailsPage(
              advertisement: arguments.advertisement,
            ),
            type: PageTransitionType.rightToLeft);
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
