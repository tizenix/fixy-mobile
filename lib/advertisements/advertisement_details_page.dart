import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_details.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/advertisement_service.dart';
import 'package:fixy_mobile/widget/edit_black_button.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AdvertisementDetailsPage extends StatefulWidget {
  final dynamic advertisement;

  AdvertisementDetailsPage({this.advertisement});

  @override
  _AdvertisementDetailsPageState createState() =>
      _AdvertisementDetailsPageState();
}

class _AdvertisementDetailsPageState extends State<AdvertisementDetailsPage>
    with TickerProviderStateMixin {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _buildImages(Size size, dynamic photos) {
    List<Widget> list = [];
    photos.forEach((p) {
      final Widget image = Container(
        width: size.width,
        child: CachedNetworkImage(
          imageUrl: p['url'],
          placeholder: (context, url) =>
              Shimmer.fromColors(
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
      );
      list.add(image);
    });

    return list;
  }

  Widget _buildProfileImage(dynamic ad) {
    String url;
    if (ad['company_detail'] != null) {
      url = ad['company_detail']['logo']['url'];
    } else {
      url = ad['service_provider_detail']['avatar']['url'];
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 15),
      child: Stack(
        children: [
          Container(
            width: 85,
            height: 85,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) =>
                  Shimmer.fromColors(
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
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.check_green,
                ),
                width: 20,
                height: 20,
                alignment: Alignment.center,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15,
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildRatings() {
    final List<Widget> stars = [1, 2, 3, 4, 5].map((e) {
      return Container(
        child: Icon(
          Icons.star_rounded,
          color: AppColors.star_not_filled,
        ),
      );
    }).toList();

    final ratingValue = widget.advertisement['avgRating'] == null
        ? "0"
        : widget.advertisement['avgRating'].toString();
    final Widget rating = Container(
      child: Text(
        "  ($ratingValue)",
        style: TextStyle(
            color: AppColors.dark_black,
            fontSize: 16,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontWeight: FontWeight.w700),
      ),
    );
    stars.add(rating);

    return Row(
      children: stars,
    );
  }

  Widget _buildTitle(Size size, String title) {
    return Container(
      width: size.width - 130,
      child: Text(
        title,
        overflow: TextOverflow.ellipsis,
        maxLines: 5,
        style: TextStyle(
            color: AppColors.dark_black,
            fontSize: 18,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildRecommendation() {
    return Text(
      "Recommendations (5)",
      style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.dark_black,
          fontFamily: PsConfig.hkgrotesk_font_family,
          fontSize: 15),
    );
  }

  Widget _buildWorkingAreas(dynamic cities, Size size) {
    List<Widget> list = [];

    cities.forEach((c) {
      final Widget chip = InputChip(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        label: Text(
          c['city_name'],
          style: TextStyle(
              fontSize: 11,
              color: AppColors.dark_black,
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontWeight: FontWeight.w700),
        ),
      );
      list.add(chip);
    });

    return Container(
      padding: const EdgeInsets.only(top: 3.0),
      width: size.width - 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 25,
            alignment: Alignment.centerLeft,
            child: Text(
              "Working Areas",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  color: AppColors.text_grey),
            ),
          ),
          Wrap(
            spacing: 5,
            runSpacing: -5,
            children: list,
          ),
        ],
      ),
    );
  }

  Widget _buildEditAdvertisementButton(
      Size size, dynamic advertisementDetails) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/create_advertisements_details',
            arguments: CreateAdvertisementDetailsPage(
                advertisement: advertisementDetails));
      },
      child: EditBlackButton(text: "Edit Advertisement", size: size),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      indicatorColor: AppColors.border_green,
      labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          fontFamily: PsConfig.hkgrotesk_font_family),
      labelColor: AppColors.dark_black,
      unselectedLabelColor: AppColors.text_grey,
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        fontFamily: PsConfig.hkgrotesk_font_family,
      ),
      tabs: [
        Tab(
          text: "Description",
        ),
        Tab(
          text: "Recommendations",
        )
      ],
    );
  }

  Widget _buildImageSlider(Size size, dynamic advertisementDetails) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 1,
        height: 300,
      ),
      items: _buildImages(size, advertisementDetails['photos']),
    );
  }

  Widget _buildBottomSheetIndicator(Size size) {
    return Positioned(
      top: 260,
      width: size.width,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.scaffold_bg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34),
            topRight: Radius.circular(34),
          ),
        ),
        child: Container(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.bottom_sheet_indicator,
                borderRadius: BorderRadius.circular(10)),
            width: 50,
            height: 6,
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(
      UserProvider userProvider, Size size, dynamic advertisementDetails) {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileImage(advertisementDetails),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(size, advertisementDetails['Title']),
              _buildRatings(),
              _buildRecommendation(),
              _buildWorkingAreas(advertisementDetails['cities'], size),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

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
      backgroundColor: AppColors.scaffold_bg,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        mini: true,
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          // top: false,
          // bottom: false,
          child: FutureBuilder(
            future: AdvertisementService().getAdvertisement(
              widget.advertisement['id'],
              userProvider.user['jwt'],
            ),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  if (snapshot.hasError)
                    return Text(snapshot.error);
                  else {
                    dynamic getAdsResult = snapshot.data;
                    if (!getAdsResult[SUCCESS_KEY]) {
                      return Center(child: Text(getAdsResult[MESSAGE_KEY]));
                    }

                    dynamic advertisementDetails = getAdsResult[MESSAGE_KEY];

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          height: 300,
                          color: Colors.grey,
                          child: Stack(
                            children: [
                              _buildImageSlider(size, advertisementDetails),
                              _buildBottomSheetIndicator(size),
                            ],
                          ),
                        ),
                        _buildProfile(userProvider, size, advertisementDetails),
                        _buildEditAdvertisementButton(
                            size, advertisementDetails),
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildTabBar(),
                              Container(
                                height: size.height,
                                child: TabBarView(children: [
                                  Container(
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 15,
                                              height: 1.5,
                                              fontFamily: PsConfig
                                                  .hkgrotesk_font_family,
                                              color: AppColors.dark_black),
                                          children: [
                                            TextSpan(
                                              text: advertisementDetails[
                                                      'Description']
                                                  .toString()[0],
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1,
                                                  fontFamily: PsConfig
                                                      .hkgrotesk_font_family,
                                                  color: AppColors.dark_black),
                                            ),
                                            TextSpan(
                                                text: advertisementDetails[
                                                        'Description']
                                                    .toString()
                                                    .substring(1))
                                          ]),
                                    ),
                                    padding: EdgeInsets.all(20),
                                  ),
                                  Container(),
                                ]),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
