import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/signup/signup_otp_page.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignupPersonalDetailsCustomerPage extends StatefulWidget {
  const SignupPersonalDetailsCustomerPage({Key key}) : super(key: key);

  @override
  _SignupPersonalDetailsCustomerPageState createState() =>
      _SignupPersonalDetailsCustomerPageState();
}

class _SignupPersonalDetailsCustomerPageState
    extends State<SignupPersonalDetailsCustomerPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  String gender = 'male';
  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    // firstNameController.text = "Prag";
    // lastNameController.text = "Afro";
    // dateOfBirthController.text = "1991-02-14";
    // emailController.text = "prag@mail.com";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    emailController.dispose();
    super.dispose();
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
            buttonColor: AppColors.border_green,
          );
        });
  }

  void _continue() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (firstNameController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter First Name');
      return;
    }

    if (lastNameController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Last Name');
      return;
    }

    if (dateOfBirthController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Date of Birth');
      return;
    }

    if (emailController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Email');
      return;
    }

    formData["firstName"] = firstNameController.text.trim();
    formData["lastName"] = lastNameController.text.trim();
    formData["birthDate"] = dateOfBirthController.text.trim();
    formData["email"] = emailController.text.trim();
    formData["gender"] = gender;

    Navigator.pushNamed(context, '/otp',
        arguments: SignupOTPPage(
          formData: formData,
          userType: UserType.Customer,
          serviceType: ServiceType.Individual,
        ));
  }

  Widget _buildProgressBar() {
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
                    color: AppColors.border_green.withOpacity(0.15),
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

  Widget _buildFirstName() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: TextField(
        controller: firstNameController,
        keyboardType: TextInputType.text,
        enableSuggestions: false,
        autocorrect: false,
        textCapitalization: TextCapitalization.words,
        onEditingComplete: () => lastNameFocusNode.nextFocus(),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border_green, width: 2),
            ),
            hintText: 'First Name',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildLastName() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: TextField(
        controller: lastNameController,
        keyboardType: TextInputType.text,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: lastNameFocusNode,
        textCapitalization: TextCapitalization.words,
        onEditingComplete: () => emailFocusNode.nextFocus(),
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border_green, width: 2),
            ),
            hintText: 'Last Name',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: emailFocusNode,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border_green, width: 2),
            ),
            hintText: 'Email',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildDateOfBirth() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: GestureDetector(
        onTap: () async {
          final DateTime pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1920),
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              dateOfBirthController.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
        child: TextField(
          controller: dateOfBirthController,
          enabled: false,
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_rounded),
              hintText: 'Date of Birth (DD/MM/YYYY)',
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: PsConfig.hkgrotesk_font_family)),
        ),
      ),
    );
  }

  Widget _buildGender() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 25.0, right: 25, bottom: 15, top: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                gender = 'male';
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text('Male',
                      style: TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 16,
                          fontFamily: PsConfig.hkgrotesk_font_family)),
                  SizedBox(
                    width: 5,
                  ),
                  gender == 'male'
                      ? Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank_rounded,
                        )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 25,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                gender = 'female';
              });
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text('Female',
                      style: TextStyle(
                          color: Color(0xFF707070),
                          fontSize: 16,
                          fontFamily: PsConfig.hkgrotesk_font_family)),
                  SizedBox(
                    width: 5,
                  ),
                  gender == 'female'
                      ? Icon(
                          Icons.check_box,
                          color: Colors.green,
                        )
                      : Icon(
                          Icons.check_box_outline_blank_rounded,
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProgressBar(),
              Container(
                color: AppColors.scaffold_bg,
                height: size.height - (170),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 200),
                  child: Column(
                    children: [
                      _buildTitle('Personal Details', size),
                      _buildFirstName(),
                      _buildLastName(),
                      _buildEmail(),
                      _buildDateOfBirth(),
                      _buildGender(),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _continue();
                },
                child: Container(
                  height: 60,
                  color: AppColors.border_green,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
