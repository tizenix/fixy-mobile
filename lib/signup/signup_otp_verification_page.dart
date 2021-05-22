import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/signup/signup_login_info_page.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignupOTPVerificationPage extends StatefulWidget {
  final String verificationId;
  final dynamic formData;
  final UserType userType;
  final ServiceType serviceType;

  SignupOTPVerificationPage(
      {this.verificationId, this.formData, this.userType, this.serviceType});

  @override
  _SignupOTPVerificationPageState createState() =>
      _SignupOTPVerificationPageState();
}

class _SignupOTPVerificationPageState extends State<SignupOTPVerificationPage> {
  final FocusNode _focusNode = FocusNode();
  String _smsCode;
  String _verificationId;

  @override
  initState() {
    super.initState();
    _verificationId = widget.verificationId;
    //_smsCode = '123456';
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _focusNode.dispose();
    super.dispose();
  }

  void _verify() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_smsCode.isEmpty) {
      _callWarningDialog(context, 'Please enter OTP code.');
      return;
    }

    if (_smsCode.length < 6) {
      _callWarningDialog(context, 'Please enter 6 digit OTP code.');
      return;
    }

    dynamic resultSignInWithPhoneNumber =
        await AuthService().signInWithPhoneNumber(_verificationId, _smsCode);
    if (!resultSignInWithPhoneNumber[SUCCESS_KEY]) {
      _callWarningDialog(context, resultSignInWithPhoneNumber[MESSAGE_KEY]);
      return;
    }

    dynamic _formData = widget.formData;
    _formData['firebase_uid'] = resultSignInWithPhoneNumber[MESSAGE_KEY].uid;

    Navigator.pushReplacementNamed(
      context,
      '/signup_login_info',
      arguments: SignupLoginInfoPage(
        formData: widget.formData,
        userType: widget.userType,
        serviceType: widget.serviceType,
      ),
    );
  }

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential user) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      _callWarningDialog(
          context, 'Phone number verification failed.${authException.message}');
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;

      setState(() {
        _smsCode = '';
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      //print("time out");
      _callWarningDialog(context, 'Time out. Please try again.');
    };

    // String phoneNumber =
    //     '${countries[_selectedCountryIndex].dialCode}${_phoneNumberController.text}';

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.formData['phoneNumber'],
        timeout: Duration(milliseconds: 10000),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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

  Widget _buildProgressBar() {
    return Container(
      child: Padding(
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiddle(Size size) {
    final String phoneNumber =
        '${widget.formData['phoneNumber'].substring(0, 2)} ${widget.formData['phoneNumber'].substring(2, 5)} ${widget.formData['phoneNumber'].substring(5)}';
    return Container(
      height: size.height - 134,
      child: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.center,
            child: Text(
              'Verification Code',
              style: TextStyle(
                  color: Color(0xFF1B1B1B),
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0, top: 100),
                  child: Text(
                    'Please enter the verification code sent\nto (+94) $phoneNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: PsConfig.hkgrotesk_font_family),
                  ),
                ),
                Container(
                  width: size.width * 0.7,
                  child: PinFieldAutoFill(
                    currentCode: _smsCode,
                    keyboardType: TextInputType.number,
                    codeLength: 6,
                    focusNode: _focusNode,
                    autofocus: true,
                    decoration: UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 24, color: Colors.black),
                        colorBuilder: FixedColorBuilder(Colors.black)),
                    //decoration: UnderlineDecoration( ),
                    onCodeChanged: (String value) {
                      //if (value.length == 6) {
                      _smsCode = value;
                      // _submit();
                      //}
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: GestureDetector(
                    onTap: () async {
                      await _sendCodeToPhoneNumber();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn\'t get code?",
                          style: TextStyle(
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          " RESEND",
                          style: TextStyle(
                              color: Color(0xFFFF6D59),
                              fontFamily: PsConfig.hkgrotesk_font_family,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContinue() {
    return GestureDetector(
      onTap: () {
        _verify();
      },
      child: Container(
        height: 60,
        color: widget.userType == UserType.ServiceProvider
            ? AppColors.purple
            : AppColors.border_green,
        alignment: Alignment.center,
        child: Text(
          'VERIFY',
          style: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
            displayDoneButton: true,
            focusNode: _focusNode,
            displayArrows: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.scaffold_bg,
      body: KeyboardActions(
        config: _buildConfig(context),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildProgressBar(),
                _buildMiddle(size),
                _buildContinue(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
