import 'dart:io';

import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/auth_service.dart';
import 'package:fixy_mobile/services/file_service.dart';
import 'package:fixy_mobile/signup/signup_profile_picture_upload_page.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class SignupDescriptionPage extends StatefulWidget {
  final dynamic formData;
  final ServiceType serviceType;

  SignupDescriptionPage({this.formData, this.serviceType});

  @override
  _SignupDescriptionPageState createState() => _SignupDescriptionPageState();
}

class _SignupDescriptionPageState extends State<SignupDescriptionPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController educationQualificationsController =
      TextEditingController();

  ProgressDialog pr;

  File imageOne;
  File imageTwo;

  @override
  void initState() {
    super.initState();
    // descriptionController.text = "Service description";
    // websiteController.text = "Web.sdd.com";
    // educationQualificationsController.text = "HD";
    // facebookController.text = "facebo.com";
    // instagramController.text = "insta.com";
  }

  @override
  void dispose() {
    websiteController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  void _continue() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (descriptionController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Description');
      return;
    }

    if (imageOne == null || imageTwo == null) {
      _callWarningDialog(context, 'Please add portfolio photos');
      return;
    }

    if (educationQualificationsController.text.isEmpty &&
        widget.serviceType == ServiceType.Individual) {
      _callWarningDialog(context, 'Please enter Education Qualifications');
      return;
    }

    if (websiteController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Website');
      return;
    }

    if (facebookController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Facebook Page');
      return;
    }

    if (instagramController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Instagram');
      return;
    }

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    pr.show();

    // if (widget.formData['serviceType'] == ServiceType.Individual.index) {
    //   createServiceProvider(userProvider);
    // } else {
    //   createCompanyDetails(userProvider);
    // }
    dynamic _formData = widget.formData;
    if (widget.serviceType == ServiceType.Organization) {
      _formData = await createCompanyDetails(userProvider);
    }

    await createServiceProvider(userProvider, _formData);
  }

  Future<dynamic> createServiceProvider(
      UserProvider userProvider, dynamic formData) async {
    // Service provider details
    dynamic spDetails = {
      "user": userProvider.user['user']['id'],
      "bio": descriptionController.text,
      "educationQual": educationQualificationsController.text,
      "fb": facebookController.text,
      "insta": instagramController.text,
      "website": websiteController.text,
      "advertisements": [],
      "address": ""
    };

    dynamic resultServiceProviderDetails = await AuthService()
        .createServiceProviderDetails(spDetails, userProvider.user['jwt']);

    if (!resultServiceProviderDetails[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resultServiceProviderDetails[MESSAGE_KEY]);
      return;
    }

    dynamic uploadPortfolioResultOne = await uploadPortfolio(
        'service-provider-details',
        resultServiceProviderDetails[MESSAGE_KEY]['id'].toString(),
        userProvider);

    if (!uploadPortfolioResultOne[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, uploadPortfolioResultOne[MESSAGE_KEY]);
      return;
    }

    formData['service_provider_details'] =
        resultServiceProviderDetails[MESSAGE_KEY];

    pr.hide();
    Navigator.pushNamed(context, '/signup_profile_picture_upload',
        arguments: SignupProfilePictureUploadPage(
          formData: formData,
          serviceType: widget.serviceType,
        ));
  }

  Future<dynamic> createCompanyDetails(UserProvider userProvider) async {
    // Company details
    dynamic companyDetails = {
      "companyName": widget.formData['companyName'],
      "email": widget.formData['email'],
      "phoneNumber": widget.formData['phoneNumber'],
      "bio": descriptionController.text,
      "fb": facebookController.text,
      "insta": instagramController.text,
      "website": websiteController.text,
      "user": userProvider.user['user']['id'],
      "advertisements": [],
      "address": widget.formData['address']
    };

    dynamic resultCompanyDetails = await AuthService()
        .createCompanyDetails(companyDetails, userProvider.user['jwt']);

    if (!resultCompanyDetails[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resultCompanyDetails[MESSAGE_KEY]);
      return;
    }

    dynamic uploadPortfolioResultOne = await uploadPortfolio('company-details',
        resultCompanyDetails[MESSAGE_KEY]['id'].toString(), userProvider);

    if (!uploadPortfolioResultOne[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, uploadPortfolioResultOne[MESSAGE_KEY]);
      return;
    }

    if (widget.serviceType == ServiceType.Organization) {
      // Upload br image
      final dynamic uploadMapBr = {
        'files': [widget.formData['brImage']],
        'ref': 'company-details',
        'refId': resultCompanyDetails[MESSAGE_KEY]['id'],
        'field': 'businessRegDoc',
        'path': 'businessRegDoc'
      };

      dynamic uploadResultBr =
          await FileService().upload(uploadMapBr, userProvider.user['jwt']);

      if (!uploadResultBr[SUCCESS_KEY]) {
        pr.hide();
        _callWarningDialog(context, uploadResultBr[MESSAGE_KEY]);
        return;
      }
    }

    var _formData = widget.formData;
    _formData['company_details'] = resultCompanyDetails[MESSAGE_KEY];
    userProvider.setCompany(resultCompanyDetails[MESSAGE_KEY]);

    return _formData;
    // pr.hide();
    // Navigator.pushNamed(context, '/signup_profile_picture_upload',
    //     arguments: SignupProfilePictureUploadPage(
    //       formData: widget.formData,
    //     ));
  }

  Future<dynamic> uploadPortfolio(
      String ref, String refId, UserProvider userProvider) async {
    // Upload portfolio
    final dynamic uploadMapOne = {
      'files': [imageOne, imageTwo],
      'ref': ref,
      'refId': refId,
      'field': 'portfolio',
      'path': 'portfolio'
    };

    dynamic uploadPortfolioResultOne =
        await FileService().upload(uploadMapOne, userProvider.user['jwt']);

    return uploadPortfolioResultOne;
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

  Widget _buildServiceDescription(Size size) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 8.0, bottom: 10),
      width: size.width,
      alignment: Alignment.centerLeft,
      child: Text(
        'Description',
        style: TextStyle(
            color: Color(0xFF707070),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }

  Widget _buildServiceDescriptionTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0, left: 25.0),
      child: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: TextField(
            controller: descriptionController,
            textInputAction: TextInputAction.done,
            maxLines: 10,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(border: InputBorder.none)),
      ),
    );
  }

  Widget _buildYourPortfolio(Size size) {
    return Container(
      padding:
          const EdgeInsets.only(left: 25, right: 25, top: 30.0, bottom: 10),
      width: size.width,
      alignment: Alignment.centerLeft,
      child: Text(
        widget.serviceType == ServiceType.Individual
            ? 'Portfolio'
            : 'Company Portfolio',
        style: TextStyle(
            color: Color(0xFF707070),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }

  void _showImageOptions(int imageIndex) {
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
                  _getImageCamera(imageIndex);
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
                  await _getImageGallery(imageIndex);
                },
                child: const Text(
                  'Choose Photo',
                  style: TextStyle(
                      fontSize: 16, fontFamily: PsConfig.hkgrotesk_font_family),
                ),
              ),
              (imageIndex == 1 && imageOne != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          imageOne = null;
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
              (imageIndex == 2 && imageTwo != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          imageTwo = null;
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
              // (imageIndex == 3 && brImage != null)
              //     ? SimpleDialogOption(
              //   onPressed: () {
              //     setState(() {
              //       brImage = null;
              //     });
              //     _dismissDialog();
              //   },
              //   child: const Text(
              //     'Delete Photo',
              //     style: TextStyle(
              //         fontSize: 16,
              //         fontFamily: PsConfig.hkgrotesk_font_family),
              //   ),
              // )
              //     : Container(),
            ],
          );
        });
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  Future _getImageCamera(int imageIndex) async {
    var imagePickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera); //pickImage(source: );

    File imageFile = File(imagePickedFile.path);

    if (imageIndex == 1) {
      setState(() {
        imageOne = imageFile;
      });
    } else if (imageIndex == 2) {
      setState(() {
        imageTwo = imageFile;
      });
    }
  }

  Future _getImageGallery(int imageIndex) async {
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

        if (imageIndex == 1) {
          setState(() {
            imageOne = imageFile;
          });
        } else if (imageIndex == 2) {
          setState(() {
            imageTwo = imageFile;
          });
        }
        // else if (imageIndex == 3) {
        //   setState(() {
        //     brImage = imageFile;
        //   });
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _showImageOptions(1);
            },
            child: Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              child: imageOne == null
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Color(0xFFF3F4FB),
                      child: Icon(Icons.add_a_photo_rounded),
                    )
                  : Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          padding: EdgeInsets.all(10),
                          child: Image.file(
                            imageOne,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -13,
                          right: -13,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageOne = null;
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showImageOptions(2);
            },
            child: Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              child: imageTwo == null
                  ? Container(
                      height: 100,
                      width: 100,
                      color: Color(0xFFF3F4FB),
                      child: Icon(Icons.add_a_photo_rounded),
                    )
                  : Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          padding: EdgeInsets.all(10),
                          child: Image.file(
                            imageTwo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -13,
                          right: -13,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                imageTwo = null;
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationQualifications() {
    return widget.serviceType == ServiceType.Individual
        ? Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, bottom: 15, top: 20),
            child: TextField(
              controller: educationQualificationsController,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  hintText: 'Education Qualifications',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontFamily: PsConfig.hkgrotesk_font_family)),
            ),
          )
        : Container();
  }

  Widget _buildWebsite() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15, top: 0),
      child: TextField(
        controller: websiteController,
        keyboardType: TextInputType.url,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: 'Website',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildFacebookPage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25,
        bottom: 15,
      ),
      child: TextField(
        controller: facebookController,
        keyboardType: TextInputType.url,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: 'Facebook Page',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildInstagram() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 25.0,
        right: 25,
        bottom: 35,
      ),
      child: TextField(
        controller: instagramController,
        keyboardType: TextInputType.url,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
            hintText: 'Instagram',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
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
        child: SingleChildScrollView(
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
                                ? 'Service Description'
                                : 'Company Description',
                            size),
                        _buildServiceDescription(size),
                        _buildServiceDescriptionTextField(),
                        _buildYourPortfolio(size),
                        _buildImage(),
                        _buildEducationQualifications(),
                        _buildWebsite(),
                        _buildFacebookPage(),
                        _buildInstagram()
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
          ),
        ),
      ),
    );
  }
}
