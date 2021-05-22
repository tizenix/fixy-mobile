import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fixy_mobile/advertisements/advertisement_details_page.dart';
import 'package:fixy_mobile/advertisements/create_advertisement_details.dart';
import 'package:fixy_mobile/bottom_nav/persistent-tab-view.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/advertisement_service.dart';
import 'package:fixy_mobile/services/company_service.dart';
import 'package:fixy_mobile/services/service_provider_service.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardAdvertisementPage extends StatefulWidget {
  @override
  _DashboardAdvertisementPageState createState() =>
      _DashboardAdvertisementPageState();
}

class _DashboardAdvertisementPageState
    extends State<DashboardAdvertisementPage> {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  void _deleteAdvertisement(dynamic ad) async {
    pr.show();
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final advertisementService = AdvertisementService();
    dynamic resultDeleteAd = await advertisementService
        .deleteAdvertisements({"id": ad['id']}, userProvider.user['jwt']);

    if (!resultDeleteAd[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resultDeleteAd[MESSAGE_KEY]);
      return;
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

    pr.hide();
    setState(() {
      userProvider.setServiceProvider(resultServiceProvider[MESSAGE_KEY]);
    });
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

  dynamic _showDeleteDialog(BuildContext context, dynamic ad) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Do you want to delete this advertisement?',
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 0.5,
                    height: 1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.purple,
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 0.5,
                        color: Colors.white,
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _deleteAdvertisement(ad);
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.purple,
                            alignment: Alignment.center,
                            child: Text(
                              'Ok',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  Future<dynamic> getAdvertisement(UserProvider userProvider) {
    if (userProvider.getServiceProvider() != null) {
      return ServiceProviderService().getServiceProviderDetails(
          userProvider.user['user']['service_provider_detail']['id'].toString(),
          userProvider.user['jwt']);
    } else {
      return CompanyService().getCompanyDetails(
          userProvider.company['id'].toString(), userProvider.user['jwt']);
    }
  }

  Widget _buildAdvertisementList(dynamic adsList, Size size) {
    List<Widget> list = [];

    adsList.forEach((ad) {
      final Widget tile = Container(
        width: size.width,
        height: 150,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 7),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        screen: AdvertisementDetailsPage(advertisement: ad),
                        withNavBar: false,
                        settings: RouteSettings(name: '/advertisement_details'),
                      );

                      // pushNewScreenWithRouteSettings(
                      //   context,
                      //   screen: AdvertisementDetailsPage(),
                      //   withNavBar: false,
                      //   settings: RouteSettings(
                      //     name: '/advertisement_details',
                      //     // arguments: AdvertisementDetailsPage(
                      //     //   advertisement: ad,
                      //     // ),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: ad['photos'][0]['url'],
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
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 40,
                  color: Colors.black.withOpacity(0.66),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            ad['Title'],
                            style: TextStyle(
                              fontFamily: PsConfig.hkgrotesk_font_family,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _showDeleteDialog(context, ad);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: Color(0xFFFF6D59),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  fontFamily: PsConfig.hkgrotesk_font_family,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF6D59)),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      );

      list.add(tile);
    });

    final Widget addTile = GestureDetector(
      onTap: () {
        pushNewScreenWithRouteSettings(
          context,
          screen: CreateAdvertisementDetailsPage(),
          withNavBar: false,
          settings: RouteSettings(name: '/create_advertisements_details'),
        );
      },
      child: Container(
        width: size.width,
        height: 130,
        margin: EdgeInsets.only(left: 20, right: 20),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.scaffold_bg,
        ),
        child: DottedBorder(
          color: AppColors.dark_black,
          child: Container(
            alignment: Alignment.center,
            child: Icon(
              Icons.add_circle_rounded,
              size: 40,
            ),
          ),
          strokeWidth: 1,
          borderType: BorderType.RRect,
          dashPattern: [5],
          radius: Radius.circular(10),
        ),
      ),
    );

    list.add(addTile);

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ListView(
          padding: EdgeInsets.only(bottom: BOTTOM_BAR_HEIGHT), children: list),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: true);
    String id;
    if (userProvider.getServiceProvider() != null) {
      id =
          userProvider.user['user']['service_provider_detail']['id'].toString();
    } else {
      id = userProvider.company['id'].toString();
    }

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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              //_buildTopProfileStatus(),
              Container(
                  height: size.height -
                      (BOTTOM_BAR_HEIGHT + TOP_PROFILE_STATUS + 47),
                  color: AppColors.scaffold_bg,
                  alignment: Alignment.center,
                  child: FutureBuilder(
                    future: getAdvertisement(userProvider),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
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
                              return Center(
                                  child: Text(getAdsResult[MESSAGE_KEY]));
                            }

                            dynamic advertisements =
                                getAdsResult[MESSAGE_KEY]['advertisements'];

                            return _buildAdvertisementList(
                                advertisements, size);
                          }
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
