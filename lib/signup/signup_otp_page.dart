import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/signup/signup_otp_verification_page.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SignupOTPPage extends StatefulWidget {
  final dynamic formData;
  final UserType userType;
  final ServiceType serviceType;

  SignupOTPPage({this.formData, this.userType, this.serviceType});

  @override
  _SignupOTPPageState createState() => _SignupOTPPageState();
}

class _SignupOTPPageState extends State<SignupOTPPage> {
  TextEditingController phoneNumberController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String verificationId;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    //phoneNumberController.text = '766786060';
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _continueOTP() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (phoneNumberController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter phone number');
      return;
    }

    if (phoneNumberController.text.length != 9) {
      _callWarningDialog(context, 'Phone Number must be of 10 digit');
      return;
    }

    await _sendCodeToPhoneNumber();
  }

  Future<void> _sendCodeToPhoneNumber() async {
    setState(() {
      isLoading = true;
    });

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
      this.verificationId = verificationId;

      setState(() {
        isLoading = false;
      });

      dynamic _formData = widget.formData;
      _formData['phoneNumber'] = '${phoneNumberController.text}';

      Navigator.pushNamed(
        context,
        '/otp_verification',
        arguments: SignupOTPVerificationPage(
          verificationId: this.verificationId,
          formData: _formData,
          userType: widget.userType,
          serviceType: widget.serviceType,
        ),
      );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      //_callWarningDialog(context, 'Time out. Please try again.');
    };

    String phoneNumber = '+94${phoneNumberController.text}';

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
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

  Widget _buildProgressBarServiceProvider() {
    return Container(
      color: Colors.white,
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
      ),
    );
  }

  Widget _buildProgressBarCustomer() {
    return Container(
      color: Colors.white,
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
                      color: AppColors.border_green.withOpacity(0.15),
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: Container(
                      height: 10,
                      color: AppColors.border_green.withOpacity(0.15),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeWillSend() {
    return Container(
      height: 90,
      alignment: Alignment.center,
      child: Text(
        'We will send you a one time password\non your phone number',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: PsConfig.hkgrotesk_font_family),
      ),
    );
  }

  Widget _buildPhoneNumberTextField() {
    return Container(
      height: 120,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 40, left: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            alignment: Alignment.center,
            child: Text(
              '(+94)',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              enableSuggestions: false,
              autocorrect: false,
              focusNode: _focusNode,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: PsConfig.hkgrotesk_font_family),
              inputFormatters: [
                LengthLimitingTextInputFormatter(9),
              ],
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Your Phone Number',
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: PsConfig.hkgrotesk_font_family)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddle(Size size) {
    return Container(
      height: size.height - 164,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height - (374),
              width: size.width,
              padding: EdgeInsets.only(left: 40, top: 75, bottom: 75),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Image.asset(
                'assets/images/signup_otp.png',
              ),
            ),
            _buildPhoneNumberTextField(),
            _buildWeWillSend(),
          ],
        ),
      ),
    );
  }

  Widget _buildContinue() {
    return GestureDetector(
      onTap: () {
        _continueOTP();
      },
      child: Container(
        height: 60,
        color: widget.userType == UserType.Customer
            ? AppColors.border_green
            : AppColors.purple,
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

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      //keyboardBarColor: AppColors.text_field_bg,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
            displayActionBar: false,
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
      backgroundColor: Color(0xFF747E94),
      body: KeyboardActions(
        tapOutsideToDismiss: true,
        config: _buildConfig(context),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.userType == UserType.ServiceProvider
                    ? _buildProgressBarServiceProvider()
                    : _buildProgressBarCustomer(),
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
