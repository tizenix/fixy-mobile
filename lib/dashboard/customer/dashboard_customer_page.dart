import 'package:fixy_mobile/bottom_nav/persistent-tab-view.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/dashboard/customer/dashboard_customer_home_page.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/utils/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardCustomerPage extends StatefulWidget {
  const DashboardCustomerPage({Key key}) : super(key: key);

  @override
  _DashboardCustomerPageState createState() => _DashboardCustomerPageState();
}

class _DashboardCustomerPageState extends State<DashboardCustomerPage> {
  final List<String> tabsTitle = [
    'Search',
    'Home',
    'Favourite',
  ];

  String currentTitle = "Home";

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  List<Widget> _buildScreens() {
    return [
      Container(),
      DashboardCustomerHomePage(),
      Container(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.search),
          title: "Search",
          activeColor: AppColors.border_green,
          inactiveColor: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home_rounded),
          title: "Home",
          activeColor: AppColors.border_green,
          inactiveColor: Colors.grey),
      PersistentBottomNavBarItem(
          icon: Icon(Icons.favorite),
          title: "Favourite",
          activeColor: AppColors.border_green,
          inactiveColor: Colors.grey),
    ];
  }

  Widget _buildDrawer(UserProvider userProvider) {
    final user = userProvider.getUser();

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
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(65),
                        color: AppColors.purple.withOpacity(0.1)),
                    child: Text(
                      user['user']['firstName'][0],
                      style: TextStyle(
                          fontSize: 60,
                          color: AppColors.text_grey,
                          fontFamily: PsConfig.hkgrotesk_font_family,
                          fontWeight: FontWeight.w700),
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
        ));
  }
}
