import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixy_mobile/advertisements/advertisement_details_page.dart';
import 'package:fixy_mobile/bottom_nav/persistent-tab-view.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/advertisement_service.dart';
import 'package:fixy_mobile/services/location_service.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardCustomerHomePage extends StatefulWidget {
  const DashboardCustomerHomePage({Key key}) : super(key: key);

  @override
  _DashboardCustomerHomePageState createState() =>
      _DashboardCustomerHomePageState();
}

class _DashboardCustomerHomePageState extends State<DashboardCustomerHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;
  ProgressDialog pr;
  Future getAdvertisementsFuture;
  TextEditingController searchTextController = TextEditingController();

  List<dynamic> districtList = [];
  List<dynamic> citiesList = [];

  List<dynamic> districtListFiltered = [];
  List<dynamic> citiesListFiltered = [];

  List<dynamic> selectedDistricts = [];
  List<dynamic> selectedCities = [];

  String searchText = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAdvertisementsFuture = getAdvertisements();
    _getLocations();
  }

  Future<dynamic> getAdvertisements() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    dynamic resAdvertisements = await AdvertisementService()
        .getAdvertisementList(
            userProvider.user['jwt'], searchText, selectedCities);
    return resAdvertisements;
  }

  void _getLocations() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    var locationService = LocationService();

    dynamic resGetDistricts =
        await locationService.getDistricts({}, userProvider.user['jwt']);

    if (!resGetDistricts[SUCCESS_KEY]) {
      setState(() {
        isLoading = false;
      });
      _callWarningDialog(context, resGetDistricts[MESSAGE_KEY]);
      return;
    }

    // dynamic resGetCities =
    //     await locationService.getCities({}, userProvider.user['jwt']);

    // if (!resGetCities[SUCCESS_KEY]) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   _callWarningDialog(context, resGetCities[MESSAGE_KEY]);
    //   return;
    // }

    List<dynamic> _selectedCities = [];
    List<dynamic> _selectedDistricts = [];
    List<dynamic> _citiesListFiltered = [];
    List<dynamic> _districtListFiltered = [];
    List<dynamic> _districtList = resGetDistricts[MESSAGE_KEY];
    // List<dynamic> _citiesList = resGetCities[MESSAGE_KEY];
    // if (widget?.advertisement != null) {
    //   _selectedCities = List.from(widget?.advertisement['cities']);
    //
    //   _citiesList.forEach((cl) {
    //     final filtered =
    //         _selectedCities.where((sc) => sc['id'] == cl['id']).toList();
    //     if (filtered.length == 0) {
    //       _citiesListFiltered.add(cl);
    //     }
    //   });
    //
    //   _districtList.forEach((dl) {
    //     final filtered =
    //         _selectedCities.where((sc) => sc['district'] == dl['id']).toList();
    //     if (filtered.length == 0) {
    //       _districtListFiltered.add(dl);
    //     } else {
    //       _selectedDistricts.add(Map.from(dl));
    //     }
    //   });
    // } else {
    _districtListFiltered = List.from(_districtList);
    // _citiesListFiltered = List.from(_citiesList);
    //}

    setState(() {
      // citiesList = _citiesList;
      districtList = _districtList;
      districtListFiltered = List.from(_districtListFiltered);
      citiesListFiltered = List.from(_citiesListFiltered);
      selectedCities = _selectedCities;
      selectedDistricts = _selectedDistricts;
      isLoading = false;
    });
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
            buttonColor: AppColors.border_green,
          );
        });
  }

  void _setFilteredDistricts(dynamic filtered) {
    setState(() {
      districtListFiltered = List.from(filtered);
    });
  }

  void _setFilteredCities(dynamic filtered) {
    setState(() {
      citiesListFiltered = List.from(filtered);
    });
  }

  void _addSelectedDistricts(
      dynamic value, String key, StateSetter stateSetter) {
    stateSetter(() {
      if (key == 'district_name') {
        if (selectedDistricts.length == 5) {
          _callWarningDialog(context, "Maximum number of locations is 5.");
          return;
        }

        districtListFiltered = [...districtListFiltered, ...selectedDistricts];

        selectedDistricts.clear();
        selectedDistricts.add(value);
        if (districtListFiltered.contains(value)) {
          districtListFiltered.remove(value);
        }

        citiesListFiltered = [...value['city']];
      } else {
        if (selectedCities.length == 5) {
          _callWarningDialog(
              context, "Maximum number of locations you can select is 5.");
          return;
        }

        if (!selectedCities.contains(value)) {
          selectedCities.add(value);
          citiesListFiltered.remove(value);
        }
      }
    });
  }

  Widget _buildServiceProvider() {
    return Container(
      height: 70,
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        'Service Providers',
        style: TextStyle(
          fontFamily: PsConfig.hkgrotesk_font_family,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.dark_black,
        ),
      ),
    );
  }

  Widget _buildProfileImage(dynamic photoUrl) {
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
              imageUrl: photoUrl,
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

  Widget _buildRatings(int rate) {
    final List<Widget> stars = [1, 2, 3, 4, 5].map((e) {
      return Container(
        child: Icon(
          Icons.star_rounded,
          color: e <= rate ? AppColors.star_filled : AppColors.star_not_filled,
        ),
      );
    }).toList();

    final ratingValue = rate == null ? "0" : rate.toString();
    final Widget rating = Container(
      child: Text(
        " ($ratingValue)",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontWeight: FontWeight.w700),
      ),
    );
    stars.add(rating);

    return Row(
      children: stars,
    );
  }

  Widget _buildRecommendation(List<dynamic> reviews) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 5),
      child: Text(
        "Recommendations (${reviews.length ?? 0})",
        style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.dark_black,
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontSize: 11),
      ),
    );
  }

  Widget _buildWorkingAreas(dynamic cities, Size size) {
    List<Widget> list = [];

    cities.forEach((c) {
      final Widget chip = Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.search_bar_color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          c['city_name'],
          style: TextStyle(
              fontSize: 10,
              color: AppColors.text_grey,
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontWeight: FontWeight.w700),
        ),
      );
      list.add(chip);
    });

    return Container(
      padding: const EdgeInsets.only(top: 0),
      // width: size.width - 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 1,
            runSpacing: 0,
            children: list,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisementList(dynamic adsList, Size size) {
    List<Widget> list = [];
    final formatCurrency = new NumberFormat.simpleCurrency(name: 'Rs. ');

    String adPhotoUrl = "";
    String profilePhotoUrl = "";
    String title = "";
    int rate = 0;
    String price = "0.00";

    adsList.forEach((ad) {
      adPhotoUrl = "";
      profilePhotoUrl = "";
      title = "";
      price = "";
      rate = 3;
      if (ad['photos'] != null && ad['photos'].length > 0) {
        adPhotoUrl = ad['photos'][0]['url'];
      }

      if (ad['Title'] != null) {
        title = ad['Title'];
      }

      if (ad['company_detail'] != null) {
        profilePhotoUrl = ad['company_detail']['logo']['url'];
      } else {
        profilePhotoUrl = ad['service_provider_detail']['avatar']['url'];
      }

      if (ad['avgRating'] != null) {
        rate = ad['avgRating'];
      }

      price = formatCurrency.format(ad['startingPrice'] ?? 0);

      final Widget tile = Container(
        width: size.width,
        height: 200,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: GestureDetector(
          onTap: () {
            pushNewScreenWithRouteSettings(
              context,
              screen: AdvertisementDetailsPage(advertisement: ad),
              withNavBar: false,
              settings: RouteSettings(name: '/advertisement_details'),
            );
          },
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  height: 140,
                  color: Colors.amber,
                  child: CachedNetworkImage(
                    imageUrl: adPhotoUrl,
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
                Container(
                  width: size.width,
                  height: 140,
                  color: Colors.black.withOpacity(0.2),
                ),
                Positioned(
                    bottom: 15,
                    left: 5,
                    child: Row(
                      children: [
                        _buildProfileImage(profilePhotoUrl),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            _buildRatings(ad['avgRating'] ?? 0),
                            SizedBox(height: 10),
                            _buildWorkingAreas(ad['cities'], size),
                            _buildRecommendation(ad['reviews'])
                          ],
                        )
                      ],
                    )),
                Positioned(
                    right: 0,
                    top: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.border_green,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Text(
                        price,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );

      list.add(tile);
    });

    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: ListView(
          padding: EdgeInsets.only(bottom: BOTTOM_BAR_HEIGHT), children: list),
    );
  }

  Widget _buildLocationSearchField(Size size, String placeholder) {
    return Container(
      height: 45,
      width: size.width,
      margin: EdgeInsets.only(left: 25, right: 25),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xFFF3F4FB), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        style: TextStyle(fontFamily: PsConfig.hkgrotesk_font_family),
        autocorrect: false,
        enableSuggestions: false,
        onChanged: (value) {
          if (placeholder == 'Select District') {
            final filtered = districtList.where((element) {
              final String name = element['district_name'].toLowerCase();
              return name.contains(value);
            }).toList();

            _setFilteredDistricts(filtered);
          } else {
            final filtered = selectedDistricts[0]['city'].where((element) {
              final String name = element['city_name'].toLowerCase();
              return name.contains(value);
            }).toList();

            _setFilteredCities(filtered);
          }
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Color(0xFF747E94),
              fontSize: 14,
              fontFamily: PsConfig.hkgrotesk_font_family,
            ),
            hintText: placeholder),
      ),
    );
  }

  Widget _buildApply(Size size, String key, BuildContext ctx) {
    bool isSelected;

    if (key == 'district_name') {
      isSelected = selectedDistricts.length > 0;
    } else {
      isSelected = selectedCities.length > 0;
    }

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          return;
        }

        Navigator.pop(ctx);
        if (key == 'city_name') {
          return;
        }

        showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (ctx) {
              return StatefulBuilder(builder: (contextStateBuilder, state) {
                return Container(
                  margin: EdgeInsets.only(top: 80),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  height: size.height * 0.7,
                  width: size.width,
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      _buildLocationTitle(),
                      _buildLocationSearchField(size, 'Select Cities'),
                      SizedBox(height: 20),
                      Container(
                        child: _buildSelectedChips(
                            size, selectedCities, 'city_name', state),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _addSelectedDistricts(
                                      citiesListFiltered[index],
                                      'city_name',
                                      state);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, right: 25, bottom: 5),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFF7F7F9),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    citiesListFiltered[index]['city_name'],
                                    style: TextStyle(
                                        fontFamily:
                                            PsConfig.hkgrotesk_font_family,
                                        fontSize: 14,
                                        color: AppColors.bottom_border),
                                  ),
                                ),
                              );
                            },
                            itemCount: citiesListFiltered.length ?? 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildApply(size, 'city_name', ctx),
                      _buildCancel('city_name', ctx),
                    ],
                  ),
                );
              });
            });
      },
      child: Container(
        height: 45,
        width: size.width,
        margin: EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !isSelected ? Color(0xFF747E94) : AppColors.purple,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          'Apply',
          style: TextStyle(
              color: Colors.white,
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildCancel(String key, BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        _cancelDistrictSelection(key);
        Navigator.pop(ctx);
      },
      child: Container(
        height: 55,
        margin: EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(
          'Cancel',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: PsConfig.hkgrotesk_font_family,
          ),
        ),
      ),
    );
  }

  void _cancelDistrictSelection(String key) {
    setState(() {
      districtListFiltered = List.from(districtList);
      selectedDistricts.clear();
      citiesListFiltered = List.from(citiesList);
      selectedCities.clear();
    });
  }

  void _removeSelectedDistricts(
    dynamic value,
    String key,
    StateSetter stateSetter,
  ) {
    stateSetter(() {
      if (key == 'district_name') {
        selectedDistricts.remove(value);
        if (!districtListFiltered.contains(value)) {
          districtListFiltered.add(value);
        }
      } else {
        selectedCities.remove(value);
        if (!citiesListFiltered.contains(value)) {
          citiesListFiltered.add(value);
        }
      }
    });
  }

  Widget _buildSelectedChips(
      Size size, List<dynamic> selected, String key, StateSetter stateSetter,
      {bool isMainView = false}) {
    List<Widget> chips = [];

    selected.forEach((tag) {
      final Widget chip = InputChip(
          deleteIconColor: Colors.white,
          backgroundColor: isMainView ? Color(0xFFA9AAAF) : AppColors.purple,
          selectedColor: AppColors.purple,
          elevation: 2,
          onDeleted: () {
            _removeSelectedDistricts(tag, key, stateSetter);
          },
          label: Text(
            tag[key],
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
      decoration: BoxDecoration(
          color:
              isMainView ? Color(0xFFA9AAAF).withOpacity(0.34) : Colors.white,
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(left: 25, right: 10),
      child: chips.length == 0
          ? Container()
          : Wrap(
              spacing: 8,
              runSpacing: -5,
              children: chips,
            ),
    );
  }

  Widget _buildSearchText() {
    return Expanded(
      child: TextField(
        controller: searchTextController,
        onSubmitted: (text) {
          setState(() {
            searchText = text;
            getAdvertisementsFuture = getAdvertisements();
          });
        },
        decoration: InputDecoration(
          hintText: "What we can do for you?",
          hintStyle: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              color: AppColors.text_grey,
              fontSize: 14),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          suffixIcon: searchTextController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () => searchTextController.clear(),
                  icon: Icon(Icons.clear),
                ),
        ),
        style: TextStyle(
            fontFamily: PsConfig.hkgrotesk_font_family,
            color: AppColors.text_grey,
            fontSize: 14),
      ),
    );
  }

  Widget _buildSeperator() {
    return Container(
      color: AppColors.text_grey,
      width: 0.5,
      margin: EdgeInsets.symmetric(vertical: 10),
    );
  }

  Widget _buildFilterIcon() {
    return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: SvgPicture.asset('assets/images/filter.svg'),
        onPressed: () {});
  }

  Widget _buildLocationIcon(Size size) {
    return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(
          Icons.location_on,
          color: AppColors.dark_black,
          size: 22,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              builder: (ctx) {
                return StatefulBuilder(builder: (contextStateBuilder, state) {
                  return Container(
                    margin: EdgeInsets.only(top: 80),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    height: size.height * 0.7,
                    width: size.width,
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        _buildLocationTitle(),
                        _buildLocationSearchField(size, 'Select District'),
                        SizedBox(height: 20),
                        Container(
                          child: _buildSelectedChips(
                              size, selectedDistricts, 'district_name', state),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    _addSelectedDistricts(
                                        districtListFiltered[index],
                                        'district_name',
                                        state);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 25, right: 25, bottom: 5),
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Color(0xFFF7F7F9),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      districtListFiltered[index]
                                          ['district_name'],
                                      style: TextStyle(
                                          fontFamily:
                                              PsConfig.hkgrotesk_font_family,
                                          fontSize: 14,
                                          color: AppColors.bottom_border),
                                    ),
                                  ),
                                );
                              },
                              itemCount: districtListFiltered.length,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildApply(size, 'district_name', ctx),
                        _buildCancel('district_name', ctx),
                      ],
                    ),
                  );
                });
              });
        });
  }

  AppBar _buildAppBar(UserProvider userProvider, Size size) {
    final user = userProvider.getUser();

    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: 45,
              margin: EdgeInsets.only(left: 20),
              padding: EdgeInsets.only(left: 15, right: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.search_bar_color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _buildSearchText(),
                  _buildSeperator(),
                  _buildLocationIcon(size),
                  _buildSeperator(),
                  _buildFilterIcon(),
                ],
              ),
            ),
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: Stack(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.purple.withOpacity(0.1)),
                  child: Text(
                    user['user']['firstName'][0],
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text_grey,
                        fontFamily: PsConfig.hkgrotesk_font_family,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Positioned(
                    bottom: 3,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: AppColors.border_green,
                          borderRadius: BorderRadius.circular(10)),
                    ))
              ],
            ),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationTitle() {
    return Container(
      height: 70,
      alignment: Alignment.center,
      child: Text(
        'Location',
        style: TextStyle(
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontSize: 20,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Download,
      customBody: ProgressHudCustom(
        text: "Please wait",
      ),
    );
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.scaffold_bg,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(userProvider, size),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildServiceProvider(),
            Container(
              height: size.height -
                  (BOTTOM_BAR_HEIGHT + TOP_PROFILE_STATUS + 47 + 70),
              child: RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    getAdvertisementsFuture = getAdvertisements();
                  });
                  return getAdvertisementsFuture;
                },
                child: FutureBuilder(
                  future: getAdvertisementsFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Shimmer.fromColors(
                            enabled: true,
                            child: Container(
                              width: 400,
                              height: 600,
                            ),
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100]);
                      default:
                        if (snapshot.hasError)
                          return Text(snapshot.error);
                        else {
                          dynamic getAdsResult = snapshot.data;
                          if (!getAdsResult[SUCCESS_KEY]) {
                            return Center(
                                child: Text(getAdsResult[MESSAGE_KEY]));
                          }

                          List<dynamic> advertisements =
                              getAdsResult[MESSAGE_KEY];

                          return _buildAdvertisementList(
                              advertisements.reversed, size);
                        }
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
