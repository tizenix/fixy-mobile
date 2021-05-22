import 'package:dotted_border/dotted_border.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_location_details_page.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/category_service.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateAdvertisementCategoryDetailsPage extends StatefulWidget {
  final dynamic formData;
  final dynamic advertisement;

  CreateAdvertisementCategoryDetailsPage({this.formData, this.advertisement});

  @override
  _CreateAdvertisementCategoryDetailsPageState createState() =>
      _CreateAdvertisementCategoryDetailsPageState();
}

class _CreateAdvertisementCategoryDetailsPageState
    extends State<CreateAdvertisementCategoryDetailsPage> {
  List<dynamic> selectedTags = [];
  List<dynamic> tagsList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getTags();
  }

  void _getTags() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    var categoryService = CategoryService();

    dynamic resGetTags = await categoryService.getSubCategories(
        {'id': widget.formData['sub_categories']['id'].toString()},
        userProvider.user['jwt']);

    if (!resGetTags[SUCCESS_KEY]) {
      setState(() {
        isLoading = false;
      });
      _callWarningDialog(context, resGetTags[MESSAGE_KEY]);
      return;
    }

    List<dynamic> tagListResult = resGetTags[MESSAGE_KEY]['tags'];
    List<dynamic> unselected = [];
    if (widget?.advertisement != null) {
      tagListResult.forEach((tl) {
        final filtered = widget?.advertisement['tags']
            .where((t) => t['id'] == tl['id'])
            .toList();
        if (filtered.length > 0) {
          selectedTags.add(tl);
        } else {
          unselected.add(tl);
        }
      });
    } else {
      unselected = tagListResult;
    }

    setState(() {
      tagsList = unselected;
      isLoading = false;
    });
  }

  void _continue(UserProvider userProvider) {
    if (selectedTags.length == 0) {
      return;
    }

    dynamic formData = widget.formData;
    formData['tags'] = selectedTags;
    formData['IsPromoted'] = false;
    formData['adType'] = userProvider.getCompany() != null ? ORG : SP;

    Navigator.pushNamed(context, '/create_advertisements_location_details',
        arguments: CreateAdvertisementLocationDetailsPage(
            formData: formData, advertisement: widget?.advertisement));
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
      height: 60,
      padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
      child: Text(
        title,
        style:
            TextStyle(fontSize: 20, fontFamily: PsConfig.hkgrotesk_font_family),
      ),
    );
  }

  Widget _buildSubTitle(String title, Size size) {
    return Container(
      width: size.width,
      padding: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Text(
        title,
        style:
            TextStyle(fontSize: 16, fontFamily: PsConfig.hkgrotesk_font_family),
      ),
    );
  }

  Widget _buildBottomButton(UserProvider userProvider) {
    return GestureDetector(
      onTap: () {
        _continue(userProvider);
      },
      child: Container(
        height: 60,
        color: selectedTags.length == 0
            ? AppColors.button_disable
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

  Widget _buildSubTitleValue(Size size, String title) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      padding: EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
      width: size.width,
      height: 33,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFFA9AAAF).withOpacity(0.34)),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 13,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontWeight: FontWeight.w500,
            color: AppColors.bottom_border),
      ),
    );
  }

  Widget _buildSelectedChips(Size size) {
    List<Widget> chips = [];

    selectedTags.forEach((tag) {
      final Widget chip = InputChip(
          deleteIconColor: Colors.white,
          backgroundColor: AppColors.purple,
          selectedColor: AppColors.purple,
          elevation: 2,
          padding: EdgeInsets.only(left: 5),
          onDeleted: () {
            setState(() {
              selectedTags.remove(tag);
              tagsList.add(tag);
            });
          },
          label: Text(
            tag['tagName'],
            style: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            // selectedTags.add(tag);
          });

      chips.add(chip);
    });

    return Container(
      width: size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 25, right: 25),
      child: chips.length == 0
          ? Container()
          : Wrap(
              spacing: 8,
              runSpacing: -5,
              children: chips,
            ),
    );
  }

  Widget _buildTagChips(Size size) {
    List<Widget> chips = [];

    tagsList.forEach((tag) {
      final Widget chip = InputChip(
          deleteIconColor: Colors.white,
          backgroundColor: AppColors.scaffold_bg.withOpacity(0),
          elevation: 0,
          padding: EdgeInsets.zero,
          label: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(30),
            padding: EdgeInsets.only(right: 15, left: 15, top: 7, bottom: 7),
            child: Text(
              tag['tagName'],
              style: TextStyle(
                fontFamily: PsConfig.hkgrotesk_font_family,
                color: AppColors.bottom_border,
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedTags.add(tag);
              tagsList.remove(tag);
            });
          });

      chips.add(chip);
    });

    return Container(
      width: size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: chips.length == 0 && isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Wrap(
              spacing: 0,
              runSpacing: -5,
              children: chips,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double safeTopPadding = MediaQuery.of(context).padding.top;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(),
                _buildTitle('Category Details', size),
                Container(
                  height: size.height - (200 + safeTopPadding),
                  alignment: Alignment.center,
                  child: ListView(
                    children: [
                      _buildSubTitle('Main Category', size),
                      _buildSubTitleValue(
                          size, widget.formData['main_categories']['name']),
                      SizedBox(height: 10),
                      _buildSubTitle('Sub Category', size),
                      _buildSubTitleValue(
                          size, widget.formData['sub_categories']['name']),
                      SizedBox(height: 10),
                      _buildSubTitle('Add your relevant service tags', size),
                      _buildSelectedChips(size),
                      _buildTagChips(size),
                    ],
                  ),
                ),
                _buildBottomButton(userProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
