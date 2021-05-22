import 'dart:io';

import 'package:fixy_mobile/app_util.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/signup/service_provider/signup_description_page.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';

class SignupCompanyDetailsPage extends StatefulWidget {
  final dynamic formData;
  final ServiceType serviceType;

  SignupCompanyDetailsPage({this.formData, this.serviceType});

  @override
  _SignupCompanyDetailsPageState createState() =>
      _SignupCompanyDetailsPageState();
}

class _SignupCompanyDetailsPageState extends State<SignupCompanyDetailsPage> {
  //Organization
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyAddressController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  TextEditingController brNumberController = TextEditingController();

  File brImage;

  @override
  void initState() {
    super.initState();
    // companyNameController.text = "ABC company";
    // companyAddressController.text = "No 32/ Colombo";
    // brNumberController.text = "PV023938934";
    // companyEmailController.text = "ben55@mail.com";
  }

  void _continueOrganization() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (companyNameController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Company Name');
      return;
    }

    if (companyAddressController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Company Address');
      return;
    }

    if (companyEmailController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Company Email');
      return;
    }

    if (!AppUtil.validEmail(companyEmailController.text)) {
      _callWarningDialog(context, 'Please enter valid Email');
      return;
    }

    if (brNumberController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter BR Number');
      return;
    }

    if (brImage == null) {
      _callWarningDialog(context, 'Please add BR photo');
      return;
    }

    dynamic _formData = widget.formData;

    _formData["companyName"] = companyNameController.text.trim();
    _formData["address"] = companyAddressController.text.trim();
    _formData["email"] = companyEmailController.text.trim();
    _formData["businessRegNo"] = brNumberController.text.trim();
    _formData["brImage"] = brImage;

    Navigator.pushNamed(
      context,
      '/signup_description',
      arguments: SignupDescriptionPage(
        formData: _formData,
        serviceType: widget.serviceType,
      ),
    );
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

  void _showImageOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.only(top: 15, left: 15),
            title: Text('Choose an Option',
                style: TextStyle(
                  fontFamily: PsConfig.hkgrotesk_font_family,
                )),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  _getImageCamera();
                  _dismissDialog();
                },
                child: Container(
                  child: const Text(
                    'Take Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: PsConfig.hkgrotesk_font_family,
                    ),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  _dismissDialog();
                  await _getImageGallery();
                },
                child: const Text(
                  'Choose Photo',
                  style: TextStyle(
                      fontSize: 16, fontFamily: PsConfig.hkgrotesk_font_family),
                ),
              ),
              (brImage != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          brImage = null;
                        });
                        _dismissDialog();
                      },
                      child: const Text(
                        'Delete Photo',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: PsConfig.hkgrotesk_font_family),
                      ),
                    )
                  : Container(),
            ],
          );
        });
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  Future _getImageCamera() async {
    var imagePickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera); //pickImage(source: );

    File imageFile = File(imagePickedFile.path);
    setState(() {
      brImage = imageFile;
    });
  }

  Future _getImageGallery() async {
    try {
      List<Media> _listImagePaths = await ImagePickers.pickerPaths(
          galleryMode: GalleryMode.image,
          selectCount: 1,
          showGif: false,
          showCamera: true,
          compressSize: 500,
          uiConfig: UIConfig(uiThemeColor: AppColors.purple),
          cropConfig: CropConfig(enableCrop: false, width: 2, height: 1));
      print(_listImagePaths);

      if (_listImagePaths.length > 0) {
        File imageFile = File(_listImagePaths[0].path);
        print(imageFile);

        setState(() {
          brImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    companyEmailController.dispose();
    brNumberController.dispose();
    super.dispose();
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

  Widget _buildOrganization(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProgressBar(),
          Container(
            color: AppColors.scaffold_bg,
            height: size.height - (164),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTitle('Company Details', size),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: companyNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: 'Company Name',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: companyAddressController,
                      keyboardType: TextInputType.streetAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: 'Company Address',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: companyEmailController,
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
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: brNumberController,
                      keyboardType: TextInputType.streetAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          hintText: 'BR Number',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, top: 5, bottom: 35),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showImageOptions();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 150,
                              color: Color(0xFFF3F4FB),
                              child: brImage == null
                                  ? Icon(Icons.add_a_photo_rounded)
                                  : Image.file(
                                      brImage,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _continueOrganization();
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark, child: _buildOrganization(size)),
    );
  }
}
