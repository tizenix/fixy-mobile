import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/services/company_service.dart';
import 'package:fixy_mobile/services/service_provider_service.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_colors.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _login();
  }

  void _login() async {
    final String email = await AppPreferences.getEmail();
    final String password = await AppPreferences.getPassword();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    dynamic resultLogin = await AuthService().login(email, password);
    if (!resultLogin[SUCCESS_KEY]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login_page', (Route<dynamic> route) => false);
      return;
    }

    userProvider.setUser(resultLogin[MESSAGE_KEY]);

    if (userProvider.user['user']['service_provider_detail'] != null) {
      // Assume not null means Service Provide - Need the proper role
      final serviceProviderService = ServiceProviderService();
      dynamic resultServiceProvider =
          await serviceProviderService.getServiceProviderDetails(
              userProvider.user['user']['service_provider_detail']['id']
                  .toString(),
              userProvider.user['jwt']);

      if (!resultServiceProvider[SUCCESS_KEY]) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login_page', (Route<dynamic> route) => false);
        return;
      }

      userProvider.setServiceProvider(resultServiceProvider[MESSAGE_KEY]);

      if (userProvider.user['user']['company_detail'] != null) {
        final companyService = CompanyService();
        dynamic resultCompanyDetail = await companyService.getCompanyDetails(
            userProvider.user['user']['company_detail']['id'].toString(),
            userProvider.user['jwt']);

        if (!resultCompanyDetail[SUCCESS_KEY]) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login_page', (Route<dynamic> route) => false);
          return;
        }

        userProvider.setCompany(resultCompanyDetail[MESSAGE_KEY]);
      }

      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      // Assume null means Customer - Need the proper role
      Navigator.pushReplacementNamed(context, '/dashboard_customer');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.dark_black,
      body: Center(
        child: GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/images/FIXY.png',
              width: size.width * 0.5,
            )),
      ),
    );
  }
}
