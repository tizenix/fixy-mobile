import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_service_category_page.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:shimmer/shimmer.dart';

class CreateAdvertisementDetailsPage extends StatefulWidget {
  final dynamic advertisement;

  CreateAdvertisementDetailsPage({this.advertisement});

  @override
  _CreateAdvertisementDetailsPageState createState() =>
      _CreateAdvertisementDetailsPageState();
}

class _CreateAdvertisementDetailsPageState
    extends State<CreateAdvertisementDetailsPage> {
  TextEditingController advertisementTitleController = TextEditingController();
  TextEditingController startingPriceController = TextEditingController();
  TextEditingController advertisementDescriptionController =
      TextEditingController();

  FocusNode advertisementTitleFocusNode = FocusNode();
  FocusNode startingPriceFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  File imageOne;
  File imageTwo;

  String imageOneUrl = "";
  String imageTwoUrl = "";

  @override
  void initState() {
    super.initState();

    if (widget.advertisement != null) {
      advertisementTitleController.text =
          widget.advertisement['Title']; //'Repairing Tap Line';
      startingPriceController.text =
          widget.advertisement['startingPrice'].toString(); //'1500.00';
      advertisementDescriptionController.text =
          widget.advertisement['Description']; //'Repairing Tap Line 1500.00';

      imageOneUrl = widget.advertisement['photos'][0]['url'];
      imageTwoUrl = widget.advertisement['photos'][1]['url'];
    }
  }

  void _continue() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (advertisementTitleController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Advertisement Title');
      return;
    }

    if (startingPriceController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Starting Price');
      return;
    }

    if (double.parse(startingPriceController.text) == 0.0) {
      _callWarningDialog(context, 'Starting Price cannot be 0.00');
      return;
    }

    if (advertisementDescriptionController.text.isEmpty) {
      _callWarningDialog(context, 'Please enter Advertisement\nDescription');
      return;
    }

    if (widget?.advertisement == null) {
      if (imageOne == null || imageTwo == null) {
        _callWarningDialog(context, 'Please add portfolio photos');
        return;
      }
    } else {
      if ((imageOne == null && imageOneUrl.isEmpty) ||
          (imageTwo == null && imageTwoUrl.isEmpty)) {
        _callWarningDialog(context, 'Please add portfolio photos');
        return;
      }
    }

    dynamic map = {
      "Title": advertisementTitleController.text,
      "startingPrice": startingPriceController.text,
      "Description": advertisementDescriptionController.text,
      "imageOne": imageOne ?? "",
      "imageTwo": imageTwo ?? "",
    };

    Navigator.pushNamed(context, '/create_advertisements_service_category',
        arguments: CreateAdvertisementServiceCategoryPage(
            formData: map, advertisement: widget?.advertisement));
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

  Widget _buildTopBar() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(Icons.arrow_back_ios_sharp),
            ),
            Text(
              'Create Advertisement',
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
      child: Text(
        title,
        style:
            TextStyle(fontSize: 20, fontFamily: PsConfig.hkgrotesk_font_family),
      ),
    );
  }

  Widget _buildBottomButton() {
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

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
            displayDoneButton: true,
            focusNode: startingPriceFocusNode,
            displayArrows: false),
      ],
    );
  }

  Widget _buildAdvertisementDescription(Size size) {
    return Container(
      padding:
          const EdgeInsets.only(left: 25, right: 25, top: 18.0, bottom: 10),
      width: size.width,
      alignment: Alignment.centerLeft,
      child: Text(
        'Advertisement Description',
        style: TextStyle(
            color: Color(0xFF707070),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }

  Widget _buildAdvertisementPortfolio(Size size) {
    return Container(
      padding:
          const EdgeInsets.only(left: 25, right: 25, top: 28.0, bottom: 10),
      width: size.width,
      alignment: Alignment.centerLeft,
      child: Text(
        'Advertisement Portfolio',
        style: TextStyle(
            color: Color(0xFF707070),
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
    );
  }

  Widget _buildAdvertisementTitleTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: TextField(
        controller: advertisementTitleController,
        keyboardType: TextInputType.text,
        enableSuggestions: false,
        autocorrect: false,
        focusNode: advertisementTitleFocusNode,
        textCapitalization: TextCapitalization.words,
        onEditingComplete: () => startingPriceFocusNode.nextFocus(),
        decoration: InputDecoration(
            hintText: 'Advertisement Title',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildStartingPriceTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
      child: TextField(
        controller: startingPriceController,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp(r'^\d+\.?\d{0,2}'), allow: true)
        ],
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        enableSuggestions: false,
        autocorrect: false,
        focusNode: startingPriceFocusNode,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
            hintText: 'Starting Price',
            hintStyle: TextStyle(
                color: Colors.grey,
                fontFamily: PsConfig.hkgrotesk_font_family)),
      ),
    );
  }

  Widget _buildAdvertisementDescriptionTextField() {
    return Padding(
      padding: const EdgeInsets.only(right: 25.0, left: 25.0),
      child: Container(
        height: 150,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: TextField(
            controller: advertisementDescriptionController,
            focusNode: descriptionFocusNode,
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
                          imageOneUrl = "";
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
                          imageTwoUrl = "";
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
        imageOne = imageFile;
        imageOneUrl = "";
      });
    } else if (imageIndex == 2) {
      setState(() {
        imageTwo = imageFile;
        imageTwoUrl = "";
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
            imageOneUrl = "";
          });
        } else if (imageIndex == 2) {
          setState(() {
            imageTwo = imageFile;
            imageTwoUrl = "";
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 250),
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
              child: imageOne == null && imageOneUrl.isEmpty
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
                          child: imageOne != null
                              ? Image.file(
                                  imageOne,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageOneUrl,
                                  placeholder: (context, url) => Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        child: Container(
                          color: Colors.grey,
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100]),
                                  errorWidget: (context, url, error) =>
                                      Center(child: Icon(Icons.error)),
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
                                imageOneUrl = "";
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
              child: imageTwo == null && imageTwoUrl.isEmpty
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
                          child: imageTwo != null
                              ? Image.file(
                                  imageTwo,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageTwoUrl,
                                  placeholder: (context, url) => Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        child: Container(
                          color: Colors.grey,
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100]),
                                  errorWidget: (context, url, error) =>
                                      Center(child: Icon(Icons.error)),
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
                                imageTwoUrl = "";
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double safeTopPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          bottom: false,
          child: KeyboardActions(
              config: _buildConfig(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTopBar(),
                    Container(
                      height: size.height - (140 + safeTopPadding),
                      child: ListView(
                        children: [
                          _buildTitle('Advertisement Details', size),
                          _buildAdvertisementTitleTextField(),
                          _buildStartingPriceTextField(),
                          _buildAdvertisementDescription(size),
                          _buildAdvertisementDescriptionTextField(),
                          _buildAdvertisementPortfolio(size),
                          _buildImage()
                        ],
                      ),
                    ),
                    _buildBottomButton(),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
