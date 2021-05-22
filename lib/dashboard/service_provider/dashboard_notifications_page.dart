import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DashboardNotificationsPage extends StatefulWidget {
  @override
  _DashboardNotificationsPageState createState() =>
      _DashboardNotificationsPageState();
}

class _DashboardNotificationsPageState
    extends State<DashboardNotificationsPage> {
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //dynamic userProvider = Provider.of<UserProvider>(context, listen: true);
    //final Size size = MediaQuery.of(context).size;

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
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    color: AppColors.text_grey.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Renew Your Premium Batch",
                            style: TextStyle(
                                color: AppColors.dark_black,
                                fontFamily: PsConfig.hkgrotesk_font_family,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                "20 Days",
                                style: TextStyle(
                                    color: AppColors.purple,
                                    decoration: TextDecoration.underline,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " Remaining to expire",
                                style: TextStyle(
                                    color: AppColors.dark_black,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    color: AppColors.text_grey.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Renew Your Premium Batch",
                            style: TextStyle(
                                color: AppColors.dark_black,
                                fontFamily: PsConfig.hkgrotesk_font_family,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                "20 Days",
                                style: TextStyle(
                                    color: AppColors.purple,
                                    decoration: TextDecoration.underline,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " Remaining to expire",
                                style: TextStyle(
                                    color: AppColors.dark_black,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    color: AppColors.text_grey.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Renew Your Premium Batch",
                            style: TextStyle(
                                color: AppColors.dark_black,
                                fontFamily: PsConfig.hkgrotesk_font_family,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                "20 Days",
                                style: TextStyle(
                                    color: AppColors.purple,
                                    decoration: TextDecoration.underline,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " Remaining to expire",
                                style: TextStyle(
                                    color: AppColors.dark_black,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(Icons.close_rounded),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                    color: AppColors.text_grey.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Renew Your Premium Batch",
                            style: TextStyle(
                                color: AppColors.dark_black,
                                fontFamily: PsConfig.hkgrotesk_font_family,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Text(
                                "20 Days",
                                style: TextStyle(
                                    color: AppColors.purple,
                                    decoration: TextDecoration.underline,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                " Remaining to expire",
                                style: TextStyle(
                                    color: AppColors.dark_black,
                                    fontFamily: PsConfig.hkgrotesk_font_family,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      child: Icon(Icons.close_rounded),
                    )
                  ],
                ),
              )
              // Container(
              //     height: size.height -
              //         (BOTTOM_BAR_HEIGHT + TOP_PROFILE_STATUS + 47),
              //     color: AppColors.scaffold_bg,
              //     alignment: Alignment.center,
              //     child: FutureBuilder(
              //       future: ServiceProviderService().getServiceProviderDetails(
              //           userProvider.user['user']['service_provider_detail']
              //           ['id']
              //               .toString(),
              //           userProvider.user['jwt']),
              //       builder: (BuildContext context,
              //           AsyncSnapshot<dynamic> snapshot) {
              //         switch (snapshot.connectionState) {
              //           case ConnectionState.waiting:
              //             return Center(
              //               child: CircularProgressIndicator(),
              //             );
              //           default:
              //             if (snapshot.hasError)
              //               return Text(snapshot.error);
              //             else {
              //               dynamic getAdsResult = snapshot.data;
              //               if (!getAdsResult[SUCCESS_KEY]) {
              //                 return Center(
              //                     child: Text(getAdsResult[MESSAGE_KEY]));
              //               }
              //
              //               dynamic advertisements =
              //               getAdsResult[MESSAGE_KEY]['advertisements'];
              //
              //               return _buildAdvertisementList(
              //                   advertisements, size);
              //             }
              //         }
              //       },
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
