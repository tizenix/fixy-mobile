import 'dart:io';

import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/signup/signup_otp_page.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:intl/intl.dart';

class SignupPersonalDetailsPage extends StatefulWidget {
  final ServiceType serviceType;

  SignupPersonalDetailsPage({this.serviceType});

  @override
  _SignupPersonalDetailsPageState createState() =>
      _SignupPersonalDetailsPageState();
}

class _SignupPersonalDetailsPageState extends State<SignupPersonalDetailsPage> {
  // Individual
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController nicController = TextEditingController();

  FocusNode lastNameFocusNode = FocusNode();
  FocusNode nicFocusNode = FocusNode();

  String gender = 'male';
  File nicImageOne;
  File nicImageTwo;

  File brImage;

  Map<String, dynamic> formData = {};

  @override
  void initState() {
    super.initState();
    // firstNameController.text = "Ben";
    // lastNameController.text = "Afro";
    // dateOfBirthController.text = "1991-02-14";
    // individualEmailController.text = "alex9@mail.com";
    // nicController.text = "910452142V";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateOfBirthController.dispose();
    nicController.dispose();
    super.dispose();
  }

  void _continueIndividual() {
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

    if (nicController.text.isEmpty || nicController.text.length != 10) {
      _callWarningDialog(context, 'Please enter NIC');
      return;
    }

    if (nicImageOne == null || nicImageTwo == null) {
      _callWarningDialog(context, 'Please add NIC photos');
      return;
    }

    formData["firstName"] = firstNameController.text.trim();
    formData["lastName"] = lastNameController.text.trim();
    formData["birthDate"] = dateOfBirthController.text.trim();
    formData["nicNumber"] = nicController.text.trim();
    formData["nicFront"] = nicImageOne;
    formData["nicBack"] = nicImageTwo;
    formData["serviceType"] = widget.serviceType.index;
    formData["gender"] = gender;

    Navigator.pushNamed(context, '/otp',
        arguments: SignupOTPPage(
          formData: formData,
          userType: UserType.ServiceProvider,
          serviceType: widget.serviceType,
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
              (imageIndex == 1 && nicImageOne != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          nicImageOne = null;
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
              (imageIndex == 2 && nicImageTwo != null)
                  ? SimpleDialogOption(
                      onPressed: () {
                        setState(() {
                          nicImageTwo = null;
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
              (imageIndex == 3 && brImage != null)
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

  Future _getImageCamera(int imageIndex) async {
    var imagePickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera); //pickImage(source: );

    File imageFile = File(imagePickedFile.path);

    if (imageIndex == 1) {
      setState(() {
        nicImageOne = imageFile;
      });
    } else if (imageIndex == 2) {
      setState(() {
        nicImageTwo = imageFile;
      });
    } else if (imageIndex == 3) {
      setState(() {
        brImage = imageFile;
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
            nicImageOne = imageFile;
          });
        } else if (imageIndex == 2) {
          setState(() {
            nicImageTwo = imageFile;
          });
        } else if (imageIndex == 3) {
          setState(() {
            brImage = imageFile;
          });
        }
      }
    } catch (e) {
      print(e);
    }
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
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 10,
                    color: AppColors.purple.withOpacity(0.15),
                  )),
                  widget.serviceType.index == ServiceType.Organization.index
                      ? SizedBox(width: 10)
                      : Container(),
                  widget.serviceType.index == ServiceType.Organization.index
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

  Widget _buildIndividual(Size size) {
    return SingleChildScrollView(
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
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.words,
                      onEditingComplete: () => lastNameFocusNode.nextFocus(),
                      decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
                    child: TextField(
                      controller: lastNameController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      focusNode: lastNameFocusNode,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          hintText: 'Last Name',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15, top: 15),
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
                                        fontFamily:
                                            PsConfig.hkgrotesk_font_family)),
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
                                        fontFamily:
                                            PsConfig.hkgrotesk_font_family)),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, bottom: 15, top: 15),
                    child: TextField(
                      controller: nicController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: false,
                      autocorrect: false,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                          hintText: 'NIC',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: PsConfig.hkgrotesk_font_family)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, top: 15, bottom: 15),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text('NIC Photos',
                          style: TextStyle(
                              color: Color(0xFF707070),
                              fontSize: 16,
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
                              _showImageOptions(1);
                            },
                            child: Container(
                              height: 100,
                              color: Color(0xFFF3F4FB),
                              child: nicImageOne == null
                                  ? Stack(
                                      children: [
                                        Positioned(
                                            top: 5,
                                            left: 10,
                                            child: Text(
                                              'Front',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                  fontFamily: PsConfig
                                                      .hkgrotesk_font_family),
                                            )),
                                        Container(
                                            height: 100,
                                            width: double.infinity,
                                            child:
                                                Icon(Icons.add_a_photo_rounded))
                                      ],
                                    )
                                  : Image.file(
                                      nicImageOne,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _showImageOptions(2);
                            },
                            child: Container(
                              height: 100,
                              color: Color(0xFFF3F4FB),
                              child: nicImageTwo == null
                                  ? Stack(
                                      children: [
                                        Positioned(
                                            top: 5,
                                            left: 10,
                                            child: Text(
                                              'Back',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey,
                                                  fontFamily: PsConfig
                                                      .hkgrotesk_font_family),
                                            )),
                                        Container(
                                            height: 100,
                                            width: double.infinity,
                                            child:
                                                Icon(Icons.add_a_photo_rounded))
                                      ],
                                    )
                                  : Image.file(
                                      nicImageTwo,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _continueIndividual();
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
          value: SystemUiOverlayStyle.dark, child: _buildIndividual(size)),
    );
  }
}
