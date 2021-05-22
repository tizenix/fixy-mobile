import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/services/advertisement_service.dart';
import 'package:fixy_mobile/services/file_service.dart';
import 'package:fixy_mobile/services/location_service.dart';
import 'package:fixy_mobile/widget/progress_hud_custom.dart';
import 'package:fixy_mobile/widget/warning_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class CreateAdvertisementLocationDetailsPage extends StatefulWidget {
  final dynamic formData;
  final dynamic advertisement;

  CreateAdvertisementLocationDetailsPage({this.formData, this.advertisement});

  @override
  _CreateAdvertisementLocationDetailsPageState createState() =>
      _CreateAdvertisementLocationDetailsPageState();
}

class _CreateAdvertisementLocationDetailsPageState
    extends State<CreateAdvertisementLocationDetailsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController _controller;

  List<dynamic> districtList = [];
  List<dynamic> citiesList = [];

  List<dynamic> districtListFiltered = [];
  List<dynamic> citiesListFiltered = [];

  List<dynamic> selectedDistricts = [];
  List<dynamic> selectedCities = [];

  bool showDistricts = false;
  bool showCities = false;

  bool isLoading = true;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    _getLocations();
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

    dynamic resGetCities =
        await locationService.getCities({}, userProvider.user['jwt']);

    if (!resGetCities[SUCCESS_KEY]) {
      setState(() {
        isLoading = false;
      });
      _callWarningDialog(context, resGetCities[MESSAGE_KEY]);
      return;
    }

    List<dynamic> _selectedCities = [];
    List<dynamic> _selectedDistricts = [];
    List<dynamic> _citiesListFiltered = [];
    List<dynamic> _districtListFiltered = [];
    List<dynamic> _districtList = resGetDistricts[MESSAGE_KEY];
    List<dynamic> _citiesList = resGetCities[MESSAGE_KEY];
    if (widget?.advertisement != null) {
      _selectedCities = List.from(widget?.advertisement['cities']);

      _citiesList.forEach((cl) {
        final filtered =
            _selectedCities.where((sc) => sc['id'] == cl['id']).toList();
        if (filtered.length == 0) {
          _citiesListFiltered.add(cl);
        }
      });

      _districtList.forEach((dl) {
        final filtered =
            _selectedCities.where((sc) => sc['district'] == dl['id']).toList();
        if (filtered.length == 0) {
          _districtListFiltered.add(dl);
        } else {
          _selectedDistricts.add(Map.from(dl));
        }
      });
    } else {
      _districtListFiltered = List.from(_districtList);
      _citiesListFiltered = List.from(_citiesList);
    }

    setState(() {
      citiesList = _citiesList;
      districtList = _districtList;
      districtListFiltered = List.from(_districtListFiltered);
      citiesListFiltered = List.from(_citiesListFiltered);
      selectedCities = _selectedCities;
      selectedDistricts = _selectedDistricts;
      isLoading = false;
    });
  }

  void _setFilteredDistricts(dynamic filtered) {
    _controller.setState(() {
      districtListFiltered = List.from(filtered);
    });
  }

  void _addSelectedDistricts(dynamic value, String key) {
    _controller.setState(() {
      if (key == 'district_name') {
        if (selectedDistricts.length == 5) {
          _callWarningDialog(context, "Maximum number of locations is 5.");
          return;
        }

        if (!selectedDistricts.contains(value)) {
          selectedDistricts.add(value);
          districtListFiltered.remove(value);
        }
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

    setState(() {
      if (key == 'district_name') {
        if (selectedDistricts.length == 5) {
          _callWarningDialog(context, "Maximum number of locations is 5.");
          return;
        }

        if (!selectedDistricts.contains(value)) {
          selectedDistricts.add(value);
          districtListFiltered.remove(value);
        }
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

  void _removeSelectedDistricts(
    dynamic value,
    String key,
  ) {
    if (_controller != null) {
      _controller.setState(() {
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

    setState(() {
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

  void _cancelDistrictSelection(String key) {
    _controller.setState(() {
      if (key == 'district_name') {
        districtListFiltered = List.from(districtList);
        selectedDistricts.clear();
      } else {
        citiesListFiltered = List.from(citiesList);
        selectedCities.clear();
      }
    });

    setState(() {
      if (key == 'district_name') {
        selectedDistricts.forEach((element) {
          districtListFiltered.add(element);
        });
        selectedDistricts.clear();
      } else {
        selectedCities.forEach((element) {
          citiesListFiltered.add(element);
        });
        selectedCities.clear();
      }
    });
  }

  void _continue() async {
    if (selectedCities.length == 0 || selectedDistricts.length == 0) {
      return;
    }

    var userProvider = Provider.of<UserProvider>(context, listen: false);

    dynamic formData = widget.formData;
    formData['cities'] = selectedCities;
    formData['service_provider_detail'] =
        userProvider.serviceProvider['id'].toString();
    if (userProvider.company != null) {
      formData['company_detail'] = userProvider.company['id'].toString();
    }
    pr.show();

    var advertisementService = AdvertisementService();

    dynamic resAd;
    if (widget?.advertisement != null) {
      resAd = await advertisementService.updateAdvertisements(formData,
          widget?.advertisement['id'].toString(), userProvider.user['jwt']);
    } else {
      resAd = await advertisementService.createAdvertisements(
          formData, userProvider.user['jwt']);
    }

    if (!resAd[SUCCESS_KEY]) {
      pr.hide();
      _callWarningDialog(context, resAd[MESSAGE_KEY]);
      return;
    }

    if (widget.formData['imageOne'] != "") {
      // Upload ad photos
      final dynamic uploadMapAdPhotosOne = {
        'files': [widget.formData['imageOne']],
        'ref': 'advertisements',
        'refId': resAd[MESSAGE_KEY]['id'.toString()],
        'field': 'photos',
        'path': 'photos',
      };

      if (widget?.advertisement != null) {
        final String id = widget?.advertisement['photos'][0]['id'].toString();

        if (id.isNotEmpty) {
          await FileService().delete(id, userProvider.user['jwt']);
        }
      }

      dynamic uploadAdPhotoOne = await FileService()
          .upload(uploadMapAdPhotosOne, userProvider.user['jwt']);

      if (!uploadAdPhotoOne[SUCCESS_KEY]) {
        pr.hide();
        _callWarningDialog(context, uploadAdPhotoOne[MESSAGE_KEY]);
        return;
      }
    }

    if (widget.formData['imageTwo'] != "") {
      // Upload ad photos
      final dynamic uploadMapAdPhotosTwo = {
        'files': [widget.formData['imageTwo']],
        'ref': 'advertisements',
        'refId': resAd[MESSAGE_KEY]['id'.toString()],
        'field': 'photos',
        'path': 'photos',
      };

      if (widget?.advertisement != null) {
        final String id = widget?.advertisement['photos'][1]['id'].toString();

        if (id.isNotEmpty) {
          await FileService().delete(id, userProvider.user['jwt']);
        }
      }

      dynamic uploadAdPhotoTwo = await FileService()
          .upload(uploadMapAdPhotosTwo, userProvider.user['jwt']);

      pr.hide();

      if (!uploadAdPhotoTwo[SUCCESS_KEY]) {
        _callWarningDialog(context, uploadAdPhotoTwo[MESSAGE_KEY]);
        return;
      }
    }

    pr.hide();

    userProvider.setServiceProvider(userProvider.serviceProvider);

    if (widget?.advertisement != null) {
      Navigator.of(context).popUntil((route) {
        return route.settings.name == '/advertisement_details';
      });
    } else {
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  dynamic _callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: text,
            onPressed: () {},
            buttonColor: AppColors.purple,
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

  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: () {
        _continue();
      },
      child: Container(
        height: 60,
        color: selectedCities.length == 0 || selectedDistricts.length == 0
            ? Color(0xFFA9AAAF)
            : AppColors.purple,
        alignment: Alignment.center,
        child: Text(
          'PUBLISH NOW',
          style: TextStyle(
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
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
          final filtered = districtList.where((element) {
            final String name = element['district_name'].toLowerCase();
            return name.contains(value);
          }).toList();

          _setFilteredDistricts(filtered);
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

  Widget _buildApply(Size size, String key) {
    bool isSelected;

    if (key == 'district_name') {
      isSelected = selectedDistricts.length > 0;
    } else {
      isSelected = selectedCities.length > 0;
    }

    return GestureDetector(
      onTap: () {
        // _controller.setState(() {
        //   districtListFiltered = List.from(districtList);
        // });
        Navigator.pop(context);
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

  Widget _buildCancel(String key) {
    return GestureDetector(
      onTap: () {
        _cancelDistrictSelection(key);
        Navigator.pop(context);
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

  Widget _buildSelectedChips(Size size, List<dynamic> selected, String key,
      {bool isMainView = false}) {
    List<Widget> chips = [];

    selected.forEach((tag) {
      final Widget chip = InputChip(
          deleteIconColor: Colors.white,
          backgroundColor: isMainView ? Color(0xFFA9AAAF) : AppColors.purple,
          selectedColor: AppColors.purple,
          elevation: 2,
          onDeleted: () {
            _removeSelectedDistricts(tag, key);
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

  Widget _buildSubTitleValue(
      Size size,
      List<dynamic> selected,
      List<dynamic> filtered,
      BuildContext ctx,
      String placeHolder,
      String key) {
    return Row(
      children: [
        selected.length != 0
            ? Expanded(
                child: Container(
                  child: _buildSelectedChips(size, selected, key,
                      isMainView: true),
                ),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 25, right: 10),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
                  height: 33,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color(0xFFA9AAAF).withOpacity(0.34)),
                  child: Text(
                    placeHolder,
                    style: TextStyle(
                        fontFamily: PsConfig.hkgrotesk_font_family,
                        color: AppColors.bottom_border),
                  ),
                ),
              ),
        GestureDetector(
          onTap: () async {
            _controller = scaffoldKey.currentState.showBottomSheet((ctx) {
              return Container(
                color: Colors.black.withOpacity(0.4),
                height: size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  height: size.height * 0.9,
                  width: size.width,
                  child: Column(
                    children: [
                      _buildLocationTitle(),
                      _buildLocationSearchField(size, placeHolder),
                      SizedBox(height: 20),
                      Container(
                        child: _buildSelectedChips(size, selected, key),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _addSelectedDistricts(filtered[index], key);
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
                                    filtered[index][key],
                                    style: TextStyle(
                                        fontFamily:
                                            PsConfig.hkgrotesk_font_family,
                                        fontSize: 14,
                                        color: AppColors.bottom_border),
                                  ),
                                ),
                              );
                            },
                            itemCount: filtered.length,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildApply(size, key),
                      _buildCancel(key),
                    ],
                  ),
                ),
              );
            }, backgroundColor: Colors.transparent);
          },
          child: Container(
            width: 60,
            height: 33,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: AppColors.purple,
              borderRadius: BorderRadius.circular(13),
            ),
            alignment: Alignment.center,
            child: Text(
              'Select',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double safeTopPadding = MediaQuery.of(context).padding.top;

    pr = ProgressDialog(
      context,
      isDismissible: false,
      type: ProgressDialogType.Download,
      customBody: ProgressHudCustom(
        text: "Please wait",
        backgroundColor: AppColors.purple,
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopBar(),
                Container(
                  height: size.height - (140 + safeTopPadding),
                  alignment: Alignment.center,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView(
                          children: [
                            _buildTitle('Location Details', size),
                            _buildSubTitle('Districts', size),
                            _buildSubTitleValue(
                                size,
                                selectedDistricts,
                                districtListFiltered,
                                context,
                                'Select District',
                                'district_name'),
                            SizedBox(height: 20),
                            _buildSubTitle('Cities', size),
                            _buildSubTitleValue(
                                size,
                                selectedCities,
                                citiesListFiltered,
                                context,
                                'Select City',
                                'city_name'),
                            SizedBox(
                              height: 40,
                            )
                          ],
                        ),
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
