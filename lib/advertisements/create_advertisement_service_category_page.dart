import 'package:fixy_mobile/advertisements/create_advertisement_category_details_page.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/category_service.dart';
import 'package:fixy_mobile/widget/category_expansion_tile.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateAdvertisementServiceCategoryPage extends StatefulWidget {
  final dynamic formData;
  final dynamic advertisement;

  CreateAdvertisementServiceCategoryPage({this.formData, this.advertisement});

  @override
  _CreateAdvertisementServiceCategoryPageState createState() =>
      _CreateAdvertisementServiceCategoryPageState();
}

class _CreateAdvertisementServiceCategoryPageState
    extends State<CreateAdvertisementServiceCategoryPage> {
  dynamic mainCategoryList;
  dynamic selectSubCategory;
  dynamic selectedMainCategory;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getMainCategories();
  }

  void _getMainCategories() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var categoryService = CategoryService();

    dynamic resultCategories =
        await categoryService.getMainCategories({}, userProvider.user['jwt']);

    if (!resultCategories[SUCCESS_KEY]) {
      setState(() {
        isLoading = false;
      });
      _callWarningDialog(context, resultCategories[MESSAGE_KEY]);
      return;
    }

    setState(() {
      final cat = resultCategories[MESSAGE_KEY];
      dynamic mainCat;
      dynamic subCat;
      if (widget?.advertisement != null) {
        cat.forEach((c) {
          final dynamic subCategory = widget?.advertisement['sub_categories'];
          if (c['id'] == subCategory[0]['main_category']) {
            mainCat = c;
            subCat = subCategory[0];
          }
        });
      }

      mainCategoryList = cat;
      isLoading = false;
      if (widget?.advertisement != null) {
        selectedMainCategory = mainCat;
        selectSubCategory = subCat;
      }
    });
  }

  void _continue() {
    if (selectSubCategory == null) {
      return;
    }

    dynamic formData = widget.formData;
    formData['sub_categories'] = selectSubCategory;
    formData['main_categories'] = selectedMainCategory;

    Navigator.pushNamed(context, '/create_advertisements_category_details',
        arguments: CreateAdvertisementCategoryDetailsPage(
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

  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {
        _continue();
      },
      child: Container(
        height: 60,
        color: selectSubCategory == null
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

  List<Widget> _createSubCategoryList(dynamic mainCategory) {
    List<Widget> list = [];

    bool isMainCategory = false;

    if (selectSubCategory != null &&
        mainCategory['id'] == selectSubCategory['main_category']) {
      isMainCategory = true;
    }

    mainCategory['sub_categories'].forEach((sb) {
      Widget row = GestureDetector(
        onTap: () {
          setState(() {
            selectSubCategory = sb;
            selectedMainCategory = mainCategory;
          });
        },
        child: Container(
          height: 45,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: isMainCategory && sb['id'] == selectSubCategory['id']
                ? AppColors.purple.withOpacity(0.27)
                : AppColors.scaffold_bg,
            border: Border(
              bottom: BorderSide(width: 0.5, color: AppColors.bottom_border),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
              ),
              Text(
                '${sb['name']}',
                style: TextStyle(
                    color: AppColors.bottom_border,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: PsConfig.hkgrotesk_font_family),
              )
            ],
          ),
        ),
      );

      list.add(row);
    });

    if (list.length == 0) {
      list.add(Container(
        height: 45,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: AppColors.bottom_border),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
            ),
            Text(
              '-- No Sub Categories available --',
              style: TextStyle(
                  color: AppColors.bottom_border,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: PsConfig.hkgrotesk_font_family),
            )
          ],
        ),
      ));
    }

    return list;
  }

  Widget _buildCategoryList() {
    if (mainCategoryList == null || mainCategoryList.length == 0) {
      return Center(child: Text('No records found.'));
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 25),
      itemBuilder: (context, index) {
        return CategoryExpansionTile(
          backgroundColor: Colors.white,
          tilePadding: EdgeInsets.zero,
          subtitle: Container(
            height: 55,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: AppColors.purple,
                border: Border(
                    bottom: BorderSide(
                        width: 0.6, color: AppColors.bottom_border))),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/home.png',
                  width: 80,
                  color: Colors.white,
                ),
                Text(
                  '${mainCategoryList[index]['name']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: PsConfig.hkgrotesk_font_family),
                ),
              ],
            ),
          ),
          title: Container(
            height: 55,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        width: 0.6, color: AppColors.bottom_border))),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/home.png',
                  width: 80,
                ),
                Text(
                  '${mainCategoryList[index]['name']}',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: PsConfig.hkgrotesk_font_family),
                ),
              ],
            ),
          ),
          onExpansionChanged: (expanded) {
            print(expanded);
          },
          children: _createSubCategoryList(mainCategoryList[index]),
        );
      },
      itemCount: mainCategoryList.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double safeTopPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(),
                _buildTitle('Choose Service Category', size),
                Container(
                  height: size.height - (200 + safeTopPadding),
                  alignment: Alignment.center,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : _buildCategoryList(),
                ),
                _buildBottomButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
