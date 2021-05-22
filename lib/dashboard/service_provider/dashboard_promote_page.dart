import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPromotePage extends StatefulWidget {
  @override
  _DashboardPromotePageState createState() => _DashboardPromotePageState();
}

class _DashboardPromotePageState extends State<DashboardPromotePage> {
  int selectedIndex = 0;

  Widget _buildSegmentTab(Size size) {
    return Container(
      width: size.width,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? AppColors.purple
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Badges",
                  style: TextStyle(
                      fontFamily: PsConfig.hkgrotesk_font_family,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          selectedIndex == 0 ? Colors.white : AppColors.purple),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selectedIndex == 1
                        ? AppColors.purple
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Carousel Ads",
                  style: TextStyle(
                      fontFamily: PsConfig.hkgrotesk_font_family,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:
                          selectedIndex == 1 ? Colors.white : AppColors.purple),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _activatedStyle() {
    return TextStyle(fontSize: 12, fontFamily: PsConfig.hkgrotesk_font_family);
  }

  TextStyle _expireStyle() {
    return TextStyle(
        fontSize: 12,
        fontFamily: PsConfig.hkgrotesk_font_family,
        fontWeight: FontWeight.w700);
  }

  TextStyle _subscriptionStyle() {
    return TextStyle(
        fontSize: 11,
        color: AppColors.border_green,
        fontFamily: PsConfig.hkgrotesk_font_family,
        fontWeight: FontWeight.w700);
  }

  Widget _buildPremiumBadge() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.badge_tile_pink,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Image.asset('assets/images/premium_badge.png'),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Activated Date\n20-03-2021',
                          textAlign: TextAlign.right, style: _activatedStyle()),
                      SizedBox(width: 10),
                      Text(
                        'Activated Date\n19-05-2021',
                        textAlign: TextAlign.right,
                        style: _expireStyle(),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: EdgeInsets.only(top: 15, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            width: 1, color: AppColors.border_green)),
                    child: Text(
                      'Renew Subscription',
                      style: _subscriptionStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "20 Days",
                        style: TextStyle(
                            color: AppColors.purple,
                            decoration: TextDecoration.underline,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " Remaining to expire",
                        style: TextStyle(
                            color: AppColors.dark_black,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopAdBadge() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.badge_tile_green,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/Rectangle 1405.png',
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/top_ad_badge.png',
                    width: 40,
                    height: 40,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Activated Date\n20-03-2021',
                          textAlign: TextAlign.right, style: _activatedStyle()),
                      SizedBox(width: 10),
                      Text(
                        'Activated Date\n19-05-2021',
                        textAlign: TextAlign.right,
                        style: _expireStyle(),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: EdgeInsets.only(top: 15, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            width: 1, color: AppColors.border_green)),
                    child: Text(
                      'Renew Subscription',
                      style: _subscriptionStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "20 Days",
                        style: TextStyle(
                            color: AppColors.purple,
                            decoration: TextDecoration.underline,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " Remaining to expire",
                        style: TextStyle(
                            color: AppColors.dark_black,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopAdBadgeBuy() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.badge_tile_green,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            child: Image.asset(
              'assets/images/top_ad_badge.png',
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore m',
                      textAlign: TextAlign.right,
                      style: _activatedStyle()),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    margin: EdgeInsets.only(top: 15, bottom: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.border_green,
                        border: Border.all(
                            width: 1, color: AppColors.border_green)),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontFamily: PsConfig.hkgrotesk_font_family,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
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
      backgroundColor: AppColors.scaffold_bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSegmentTab(size),
            selectedIndex == 1
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10, left: 25, right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            "Advertise on Carousel",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                fontFamily: PsConfig.hkgrotesk_font_family,
                                color: AppColors.dark_black),
                          ),
                        ),
                        Text(
                          "Good internet, nice people and you always have a comfy feeling working here. Amazing space for getting",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: PsConfig.hkgrotesk_font_family),
                        ),
                      ],
                    ),
                  )
                : Container(),
            _buildPremiumBadge(),
            _buildTopAdBadge(),
            _buildTopAdBadgeBuy(),
          ],
        ),
      ),
    );
  }
}
