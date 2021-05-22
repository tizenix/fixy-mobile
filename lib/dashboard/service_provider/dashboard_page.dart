import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixy_mobile/bottom_nav/persistent-tab-view.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/dashboard/service_provider/dashboard_advertisement_page.dart';
import 'package:fixy_mobile/dashboard/service_provider/dashboard_notifications_page.dart';
import 'package:fixy_mobile/dashboard/service_provider/dashboard_profile_page.dart';
import 'package:fixy_mobile/dashboard/service_provider/dashboard_promote_page.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<String> tabsTitle = [
    'Profile',
    'Advertisement',
    'Promote',
    'Notification'
  ];

  String currentTitle = "Profile";

  @override
  void initState() {
    super.initState();
    _checkIsCreateAdPop();
  }

  void _checkIsCreateAdPop() async {
    //await AppPreferences.setIsCreateAdPopShowed(true);
    final bool isCreateAdPopShowed =
        await AppPreferences.getIsCreateAdPopShowed();
    if (isCreateAdPopShowed == null || !isCreateAdPopShowed) {
      _callWarningDialog(context);
    }
  }

  dynamic _callWarningDialog(BuildContext context) {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
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
                      "Create Your First Advertisement",
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AppPreferences.setIsCreateAdPopShowed(true);
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/create_advertisements_details',
                      );
                    },
                    child: Container(
                      height: 42,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColors.purple,
                          borderRadius: BorderRadius.circular(25)),
                      child: Text(
                        'Create Now',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AppPreferences.setIsCreateAdPopShowed(true);
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 32,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      alignment: Alignment.center,
                      child: Text(
                        'Skip & Continue',
                        style: TextStyle(
                            color: AppColors.purple,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  List<Widget> _buildScreens() {
    return [
      DashboardProfilePage(),
      DashboardAdvertisementPage(),
      DashboardPromotePage(),
      DashboardNotificationsPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          title: "Profile",
          activeColor: AppColors.purple,
          inactiveColor: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.assignment),
          title: "Advertisement",
          activeColor: AppColors.purple,
          inactiveColor: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.stars_rounded),
          title: "Promote",
          activeColor: AppColors.purple,
          inactiveColor: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.notifications_active_rounded),
          title: "Notifications",
          activeColor: AppColors.purple,
          inactiveColor: Colors.grey),
    ];
  }

  Widget _buildImAvailable() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: AppColors.border_green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "I\'m Available",
          style: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              color: Colors.white,
              fontSize: 10),
        ),
      ),
    );
  }

  AppBar _buildAppBar(UserProvider userProvider) {
    String url;
    if (userProvider.getCompany() != null) {
      url = userProvider.getCompany()['logo']['url'];
    } else {
      url = userProvider.getServiceProvider()['avatar']['url'];
    }

    return AppBar(
      centerTitle: false,
      elevation: 0,
      title: Text(
        currentTitle,
        style: TextStyle(
            color: AppColors.dark_black,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontSize: 20,
            fontWeight: FontWeight.w700),
      ),
      backgroundColor: AppColors.scaffold_bg,
      actions: [
        _buildImAvailable(),
        Builder(
          builder: (context) => IconButton(
            icon: Container(
                width: 30,
                height: 30,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                )),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(UserProvider userProvider) {
    String url;
    if (userProvider.getCompany() != null) {
      url = userProvider.getCompany()['logo']['url'];
    } else {
      url = userProvider.getServiceProvider()['avatar']['url'];
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(75)),
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
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 40,
                  child: Text(
                    userProvider.user['user']['firstName'],
                    style: TextStyle(
                        fontFamily: PsConfig.hkgrotesk_font_family,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                      height: 40,
                      width: 130,
                      alignment: Alignment.center,
                      child: _buildImAvailable()),
                ),
                Container(
                  height: 1,
                  color: AppColors.dark_black,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 5),
                        child:
                            Icon(Icons.settings, color: AppColors.dark_black),
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              userProvider.company = null;
              userProvider.serviceProvider = null;
              userProvider.user = null;
              AppPreferences.clearAll();

              Navigator.pushNamedAndRemoveUntil(
                  context, '/login_page', (Route<dynamic> route) => false);
            },
            child: Container(
              color: AppColors.star_filled,
              height: 55,
              alignment: Alignment.center,
              child: Text(
                'LOGOUT',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    fontFamily: PsConfig.hkgrotesk_font_family,
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
    dynamic userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      appBar: _buildAppBar(userProvider),
      endDrawer: _buildDrawer(userProvider),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        navBarStyle: NavBarStyle.style9,
        navBarHeight: BOTTOM_BAR_HEIGHT,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(35.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        onItemSelected: (index) {
          setState(() {
            currentTitle = tabsTitle[index];
          });
        },
      ),
    );
  }
}
