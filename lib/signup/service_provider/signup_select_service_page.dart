import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/signup/service_provider/signup_personal_details_page.dart';
import 'package:flutter/material.dart';

class SignupSelectService extends StatefulWidget {
  @override
  _SignupSelectService createState() => _SignupSelectService();
}

class _SignupSelectService extends State<SignupSelectService> {
  ServiceType selectedService = ServiceType.Individual;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
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
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.85,
                0.99,
              ],
              colors: [
                Colors.grey.shade800,
                AppColors.purple
              ]),
        ),
        child: Center(
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: 205,
              width: size.width * 0.85,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Select Your Service Type',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          fontFamily: PsConfig.hkgrotesk_font_family),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 25.0, bottom: 25, right: 10, left: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedService = ServiceType.Individual;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedService ==
                                            ServiceType.Individual
                                        ? Colors.white
                                        : Colors.black),
                                color: selectedService == ServiceType.Individual
                                    ? AppColors.purple
                                    : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60))),
                            child: Text(
                              'Individual',
                              style: TextStyle(
                                  color:
                                      selectedService == ServiceType.Individual
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 16,
                                  fontFamily: PsConfig.hkgrotesk_font_family),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedService = ServiceType.Organization;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, top: 15, bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selectedService ==
                                            ServiceType.Organization
                                        ? Colors.white
                                        : Colors.black),
                                color:
                                    selectedService == ServiceType.Organization
                                        ? AppColors.purple
                                        : Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60))),
                            child: Text(
                              'Organization',
                              style: TextStyle(
                                  color: selectedService ==
                                          ServiceType.Organization
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontFamily: PsConfig.hkgrotesk_font_family),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup_personal_details',
                          arguments: SignupPersonalDetailsPage(
                            serviceType: selectedService,
                          ));
                    },
                    child: Container(
                      width: size.width * 0.85,
                      height: 50,
                      color: AppColors.purple,
                      alignment: Alignment.center,
                      child: Text(
                        'Continue',
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
      ),
    );
  }
}
