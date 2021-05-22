import 'dart:io';

import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/services/company_service.dart';
import 'package:fixy_mobile/services/file_service.dart';
import 'package:fixy_mobile/services/service_provider_service.dart';
import 'package:fixy_mobile/signup/signup_terms_and_conditions_page.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class SignupProfilePictureUploadPage extends StatefulWidget {
  final dynamic formData;
  final ServiceType serviceType;

  SignupProfilePictureUploadPage({this.formData, this.serviceType});

  @override
  _SignupProfilePictureUploadPageState createState() =>
      _SignupProfilePictureUploadPageState();
}

class _SignupProfilePictureUploadPageState
    extends State<SignupProfilePictureUploadPage> {
  File profilePicture;

  ProgressDialog pr;

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
              (profilePicture != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          profilePicture = null;
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

  Future _getImageCamera() async {
    var imagePickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera); //pickImage(source: );

    File imageFile = File(imagePickedFile.path);

    setState(() {
      profilePicture = imageFile;
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
          profilePicture = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _continue() async {
    if (profilePicture == null || profilePicture == null) {
      _callWarningDialog(context, 'Please add profile photo');
      return;
    }
    pr.show();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final authService = AuthService();
    final String email = await AppPreferences.getEmail();
    final String password = await AppPreferences.getPassword();
    dynamic resultLoginUser = await authService.login(email, password);
    if (!resultLoginUser[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resultLoginUser[MESSAGE_KEY]);
      return;
    }

    userProvider.setUser(resultLoginUser[MESSAGE_KEY]);

    String ref;
    String refId;
    String field;

    if (widget.serviceType == ServiceType.Individual) {
      ref = 'service-provider-details';
      refId = widget.formData['service_provider_details']['id'].toString();
      field = 'avatar';
    } else {
      ref = 'company-details';
      refId = widget.formData['company_details']['id'].toString();
      field = 'logo';
    }

    // Upload profile picture
    final dynamic uploadMap = {
      'files': [profilePicture],
      'ref': ref,
      'refId': refId,
      'field': field,
      'path': field
    };

    pr.show();

    dynamic uploadNicResultNicFront =
        await FileService().upload(uploadMap, userProvider.user['jwt']);
    pr.hide();

    if (!uploadNicResultNicFront[SUCCESS_KEY]) {
      _callWarningDialog(context, uploadNicResultNicFront[MESSAGE_KEY]);
      return;
    }

    if (widget.serviceType == ServiceType.Organization) {
      final companyService = CompanyService();
      dynamic resultCompanyDetails = await companyService.getCompanyDetails(
          userProvider.user['user']['company_detail']['id'].toString(),
          userProvider.user['jwt']);

      if (!resultCompanyDetails[SUCCESS_KEY]) {
        pr.hide();
        _callWarningDialog(context, resultCompanyDetails[MESSAGE_KEY]);
        return;
      }

      userProvider.setCompany(resultCompanyDetails[MESSAGE_KEY]);
    }

    final serviceProviderService = ServiceProviderService();
    dynamic resultServiceProvider =
        await serviceProviderService.getServiceProviderDetails(
            userProvider.user['user']['service_provider_detail']['id']
                .toString(),
            userProvider.user['jwt']);

    if (!resultServiceProvider[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resultServiceProvider[MESSAGE_KEY]);
      return;
    }

    userProvider.setServiceProvider(resultServiceProvider[MESSAGE_KEY]);

    Navigator.pushNamed(context, '/signup_terms_and_conditions',
        arguments: SignupTermsAndConditionsPage(
          formData: widget.formData,
        ));
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
                    color: AppColors.purple.withOpacity(0.15),
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

  Widget _buildProfile(Size size) {
    return GestureDetector(
      onTap: () {
        _showImageOptions();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: size.width * 0.3,
              child: profilePicture == null
                  ? Icon(
                      Icons.person,
                      color: Colors.grey.withOpacity(0.35),
                      size: size.width * 0.2,
                    )
                  : ClipOval(
                      child: Image.file(
                        profilePicture,
                        fit: BoxFit.cover,
                        width: size.width * 0.6,
                        height: size.width * 0.6,
                      ),
                    ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: CircleAvatar(
                    backgroundColor: Color(0xFF747E94),
                    radius: 24,
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      color: Colors.white,
                    )))
          ],
        ),
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

  Widget _buildName(Size size) {
    String name;

    if (widget.serviceType == ServiceType.Individual) {
      name = "${widget.formData['firstName']} ${widget.formData['lastName']}";
    } else {
      name = widget.formData['companyName'];
    }

    return Text(
      name,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
        fontFamily: PsConfig.hkgrotesk_font_family,
        color: Color(0xFF747E94),
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
                      _buildTitle(
                          widget.serviceType == ServiceType.Individual
                              ? 'Upload Profile Picture'
                              : 'Upload Your Logo',
                          size),
                      _buildProfile(size),
                      _buildName(size),
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
