import 'package:fixy_mobile/app_util.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
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

    pr.show();

    dynamic resultLogin =
        await AuthService().forgotPassword(emailController.text);

    pr.hide();
    if (!resultLogin[SUCCESS_KEY]) {
      _callWarningDialog(context, resultLogin[MESSAGE_KEY]);
      return;
    }

    Navigator.pop(context);
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
          );
        });
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

  Widget _buildContinueButton(Size size) {
    return GestureDetector(
      onTap: () async {
        _continue();
      },
      child: Container(
        height: 60,
        width: size.width,
        color: AppColors.purple,
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

  Widget _buildEmailTextField() {
    return Container(
      height: 150,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 40, right: 40),
      child: Container(
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
    );
  }

  Widget _buildForgotPassword(Size size) {
    return Container(
      width: size.width,
      height: 100,
      alignment: Alignment.center,
      child: Text(
        'Forgot Password',
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: PsConfig.hkgrotesk_font_family),
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
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.dark_black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildForgotPassword(size),
                _buildMiddleLogo(size),
                _buildEmailTextField(),
                _buildContinueButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
