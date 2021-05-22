import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupTermsAndConditionsPage extends StatefulWidget {
  final dynamic formData;

  SignupTermsAndConditionsPage({this.formData});

  @override
  _SignupTermsAndConditionsPageState createState() =>
      _SignupTermsAndConditionsPageState();
}

class _SignupTermsAndConditionsPageState
    extends State<SignupTermsAndConditionsPage> {
  void _continue() {
    Navigator.pushNamed(context, '/dashboard');
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
                  ))
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

  Widget _buildBottomButton(Size size) {
    return GestureDetector(
      onTap: () {
        _continue();
      },
      child: Container(
        height: 60,
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          height: size.height,
          color: AppColors.scaffold_bg,
          child: Column(
            children: [
              _buildProgressBar(),
              Container(
                height: size.height - (170),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTitle("Terms & Conditions", size),
                      Container(
                        margin: EdgeInsets.only(
                            left: 25, right: 25, top: 35, bottom: 35),
                        padding: EdgeInsets.all(20),
                        width: size.width,
                        height: size.height - (164 + 150),
                        color: Colors.white,
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                      )
                    ],
                  ),
                ),
              ),
              _buildBottomButton(size)
            ],
          ),
        ),
      ),
    );
  }
}
