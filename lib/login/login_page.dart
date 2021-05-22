import 'package:fixy_mobile/app_util.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserType userType = UserType.ServiceProvider;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();

  ProgressDialog pr;

  void _continue() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (emailController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Email');
      return;
    }

    if (!AppUtil.validEmail(emailController.text)) {
      _callWarningDialog(context, 'Please enter valid Email');
      return;
    }

    if (passwordController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Password');
      return;
    }

    pr.style(
        backgroundColor: userType == UserType.ServiceProvider
            ? AppColors.purple
            : AppColors.border_green);
    pr.show();

    dynamic resultLogin = await AuthService()
        .login(emailController.text, passwordController.text);

    pr.hide();
    if (!resultLogin[SUCCESS_KEY]) {
      _callWarningDialog(context, resultLogin[MESSAGE_KEY]);
      return;
    }

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUser(resultLogin[MESSAGE_KEY]);

    await AppPreferences.setEmail(emailController.text);
    await AppPreferences.setPassword(passwordController.text);

    Navigator.pushNamed(context, '/landing_page');
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
            buttonColor: userType == UserType.Customer
                ? AppColors.border_green
                : AppColors.purple,
          );
        });
  }

  Widget _buildLoginAsACustomer(Size size) {
    return GestureDetector(
      onTap: () {
        if (userType == UserType.Customer) {
          setState(() {
            userType = UserType.ServiceProvider;
          });
        } else {
          setState(() {
            userType = UserType.Customer;
          });
        }
      },
      child: Container(
        width: size.width,
        height: 80,
        alignment: Alignment.bottomCenter,
        child: Text(
          userType == UserType.Customer
              ? 'Login as a Service Provider'
              : 'Login as a Customer',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: PsConfig.hkgrotesk_font_family),
        ),
      ),
    );
  }

  Widget _buildMiddleLogo(Size size) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/FIXY.png',
          width: size.width * 0.65,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Snap in to better lifestyle !",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: PsConfig.hkgrotesk_font_family,
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildTextField(Size size) {
    return Container(
      width: size.width,
      height: 230,
      //color: Colors.yellow,
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Container(
            height: 55,
            padding: EdgeInsets.only(left: 20, right: 10, top: 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.text_field_bg.withOpacity(0.15),
              border: Border.all(color: Color(0xFF576F93).withOpacity(0.6)),
              borderRadius: BorderRadius.all(
                Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                    onEditingComplete: () => passwordFocusNode.nextFocus(),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Color(0xFF707070)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 0),
                  child: Icon(
                    Icons.mail_outline_rounded,
                    color: Color(0xFF576F93),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: 55,
            padding: EdgeInsets.only(left: 20, right: 10, top: 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.text_field_bg.withOpacity(0.15),
              border: Border.all(color: Color(0xFF576F93).withOpacity(0.6)),
              borderRadius: BorderRadius.all(
                Radius.circular(35),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Color(0xFF707070)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 0),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFF576F93),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  Icons.check_box_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 3),
                Text(
                  'Remember me',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: PsConfig.hkgrotesk_font_family),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    //_callWarningDialog(context, "On progress");
                    Navigator.pushNamed(context, '/forgot_password');
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: PsConfig.hkgrotesk_font_family),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCreateNewAccount(Size size) {
    return Container(
      width: size.width,
      height: 50,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          if (userType == UserType.ServiceProvider) {
            Navigator.pushNamed(context, '/signup_select_service');
          } else {
            Navigator.pushNamed(context, '/signup_personal_details_customer');
          }
        },
        child: Text(
          'Create new account',
          style: TextStyle(
              color: userType == UserType.ServiceProvider
                  ? Colors.white
                  : AppColors.border_green,
              fontSize: 15,
              fontFamily: PsConfig.hkgrotesk_font_family),
        ),
      ),
    );
  }

  Widget _buildContinueButton(Size size) {
    return GestureDetector(
      onTap: () async {
        _continue();
      },
      child: Container(
        height: 60,
        width: size.width,
        color: userType == UserType.ServiceProvider
            ? AppColors.purple
            : AppColors.border_green,
        alignment: Alignment.center,
        child: Text(
          'CONTINUE',
          style: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
    );
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
          );
        });
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
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.dark_black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLoginAsACustomer(size),
                _buildMiddleLogo(size),
                _buildTextField(size),
                _buildCreateNewAccount(size),
                _buildContinueButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
