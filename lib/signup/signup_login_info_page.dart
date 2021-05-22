import 'package:fixy_mobile/app_util.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/services/file_service.dart';
import 'package:fixy_mobile/signup/service_provider/signup_company_details_page.dart';
import 'package:fixy_mobile/signup/service_provider/signup_description_page.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class SignupLoginInfoPage extends StatefulWidget {
  final dynamic formData;
  final UserType userType;
  final ServiceType serviceType;

  SignupLoginInfoPage({this.formData, this.userType, this.serviceType});

  @override
  _SignupLoginInfoPageState createState() => _SignupLoginInfoPageState();
}

class _SignupLoginInfoPageState extends State<SignupLoginInfoPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    // userNameController.text = 'alex8';
    // passwordController.text = 'Text@1234';
    // rePasswordController.text = 'Text@1234';
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  void _continue(BuildContext buildContext) async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Email');
      return;
    }

    if (!AppUtil.validEmail(emailController.text)) {
      _callWarningDialog(context, 'Please enter a valid Email');
      return;
    }

    if (userNameController.text.isEmpty) {
      _callWarningDialog(buildContext, 'Please enter User Name');
      return;
    }

    if (passwordController.text.isEmpty) {
      _callWarningDialog(buildContext, 'Please enter Password');
      return;
    }

    if (rePasswordController.text.isEmpty) {
      _callWarningDialog(buildContext, 'Please enter Re-Password');
      return;
    }

    if (!validatePassword(passwordController.text)) {
      _callWarningDialog(buildContext,
          'Please enter strong password.\n\nMinimum 1 Upper case\nMinimum 1 lowercase\nMinimum 1 Numeric Number\nMinimum 1 Special Character\nCommon Allow Character ( ! @ # \$ & * ~ )');
      return;
    }

    if (passwordController.text != rePasswordController.text) {
      _callWarningDialog(buildContext, 'Re-Password does not match');
      return;
    }

    dynamic _formData = widget.formData;
    _formData['email'] = emailController.text.trim();
    _formData['username'] = userNameController.text.trim();
    _formData['password'] = passwordController.text.trim();

    pr.style(
        backgroundColor: widget.userType == UserType.ServiceProvider
            ? AppColors.purple
            : AppColors.border_green);
    pr.show();
    if (widget.userType == UserType.ServiceProvider) {
      _registerServiceProvider(_formData, buildContext);
    } else {
      _registerCustomer(_formData, buildContext);
    }
  }

  void _registerCustomer(dynamic formData, BuildContext buildContext) async {
    // Register customer
    dynamic registerResult =
        await AuthService().register(formData, widget.userType);

    if (!registerResult[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(buildContext, registerResult[MESSAGE_KEY]);
      return;
    }

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(registerResult[MESSAGE_KEY]);

    await AppPreferences.setEmail(userNameController.text);
    await AppPreferences.setPassword(passwordController.text);

    pr.hide();

    Navigator.pushNamed(
      context,
      '/dashboard_customer',
    );
  }

  void _registerServiceProvider(
      dynamic formData, BuildContext buildContext) async {
    // Register service user
    dynamic registerResult =
        await AuthService().register(formData, widget.userType);

    if (!registerResult[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(buildContext, registerResult[MESSAGE_KEY]);
      return;
    }

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(registerResult[MESSAGE_KEY]);

    // Upload nic
    final dynamic uploadMapNicFront = {
      'files': [formData['nicFront']],
      'ref': 'user',
      'refId': userProvider.user['user']['id'].toString(),
      'field': 'nicPhotos',
      'path': 'nic',
      'source': 'users-permissions'
    };

    dynamic uploadNicResultNicFront =
        await FileService().upload(uploadMapNicFront, userProvider.user['jwt']);

    pr.hide();

    if (!uploadNicResultNicFront[SUCCESS_KEY]) {
      _callWarningDialog(buildContext, uploadNicResultNicFront[MESSAGE_KEY]);
      return;
    }

    await AppPreferences.setEmail(userNameController.text);
    await AppPreferences.setPassword(passwordController.text);

    if (widget.serviceType == ServiceType.Individual) {
      Navigator.pushNamed(
        context,
        '/signup_description',
        arguments: SignupDescriptionPage(
          formData: formData,
          serviceType: widget.serviceType,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        '/signup_company_details',
        arguments: SignupCompanyDetailsPage(
          formData: formData,
          serviceType: widget.serviceType,
        ),
      );
    }
  }

  bool validatePassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
            buttonColor: widget.userType == UserType.ServiceProvider
                ? AppColors.purple
                : AppColors.border_green,
          );
        });
  }

  Widget _buildProgressBarServiceProvider() {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(left: 20, top: 50.0, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.arrow_back_ios_sharp),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: PsConfig.hkgrotesk_font_family,
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 5, left: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple.withOpacity(0.15),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple.withOpacity(0.15),
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple.withOpacity(0.15),
                  )),
                  widget.serviceType == ServiceType.Organization
                      ? SizedBox(width: 10)
                      : Container(),
                  widget.serviceType == ServiceType.Organization
                      ? Expanded(
                          child: Container(
                          height: 10,
                          color: AppColors.purple.withOpacity(0.15),
                        ))
                      : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBarCustomer() {
    return Container(
      height: 110,
      padding: const EdgeInsets.only(left: 20, top: 50.0, right: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.arrow_back_ios_sharp),
                ),
                Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: PsConfig.hkgrotesk_font_family,
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 5, left: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.border_green,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.border_green,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.border_green,
                  )),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.border_green,
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
      child: Text(
        title,
        style:
            TextStyle(fontSize: 26, fontFamily: PsConfig.hkgrotesk_font_family),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Download,
      customBody: ProgressHudCustom(
        text: "Please wait",
        backgroundColor: widget.userType == UserType.ServiceProvider
            ? AppColors.purple
            : AppColors.border_green,
      ),
    );

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            color: AppColors.scaffold_bg,
            child: Column(
              children: [
                widget.userType == UserType.ServiceProvider
                    ? _buildProgressBarServiceProvider()
                    : _buildProgressBarCustomer(),
                _buildTitle('Login Information', size),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: PsConfig.hkgrotesk_font_family)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
                  child: TextField(
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.userType == UserType.ServiceProvider
                                  ? AppColors.purple
                                  : AppColors.border_green,
                              width: 2),
                        ),
                        hintText: 'User Name',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: PsConfig.hkgrotesk_font_family)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
                  child: TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.userType == UserType.ServiceProvider
                                  ? AppColors.purple
                                  : AppColors.border_green,
                              width: 2),
                        ),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: PsConfig.hkgrotesk_font_family)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
                  child: TextField(
                    controller: rePasswordController,
                    keyboardType: TextInputType.text,
                    enableSuggestions: false,
                    autocorrect: false,
                    obscureText: true,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.userType == UserType.ServiceProvider
                                  ? AppColors.purple
                                  : AppColors.border_green,
                              width: 2),
                        ),
                        hintText: 'Re-Password',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: PsConfig.hkgrotesk_font_family)),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    _continue(context);
                  },
                  child: Container(
                    height: 60,
                    color: widget.userType == UserType.ServiceProvider
                        ? AppColors.purple
                        : AppColors.border_green,
                    alignment: Alignment.center,
                    child: Text(
                      widget.userType == UserType.ServiceProvider
                          ? 'CONTINUE'
                          : 'FINISH',
                      style: TextStyle(
                          fontFamily: PsConfig.hkgrotesk_font_family,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
