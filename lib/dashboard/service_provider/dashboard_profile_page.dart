import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:fixy_mobile/models/providers/user_provider.dart';
import 'package:fixy_mobile/widget/edit_black_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DashboardProfilePage extends StatefulWidget {
  @override
  _DashboardProfilePageState createState() => _DashboardProfilePageState();
}

class _DashboardProfilePageState extends State<DashboardProfilePage> {
  Widget _buildProfilePhoto(UserProvider userProvider) {
    String url;
    if (userProvider.getCompany() != null) {
      url = userProvider.getCompany()['logo']['url'];
    } else {
      url = userProvider.getServiceProvider()['avatar']['url'];
    }

    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(75)),
            child: CachedNetworkImage(
              imageUrl: url,
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
              bottom: 3,
              right: 10,
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

  Widget _buildName(UserProvider userProvider) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 40,
      child: Text(
        userProvider.user['user']['firstName'],
        style: TextStyle(
            fontFamily: PsConfig.hkgrotesk_font_family,
            fontSize: 18,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildRatings(int avg) {
    final List<Widget> stars = [1, 2, 3, 4, 5].map((e) {
      return Container(
        child: Icon(
          Icons.star_rounded,
          color: e <= avg ? AppColors.star_filled : AppColors.star_not_filled,
        ),
      );
    }).toList();

    return Row(
      children: stars,
    );
  }

  Widget _buildRatingsLevel() {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "4.8",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 45,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  color: AppColors.star_filled),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildRatings(4),
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(5)),
                    height: 20,
                    width: 120,
                    margin: EdgeInsets.only(top: 2),
                    alignment: Alignment.center,
                    child: Text(
                      "Level 1",
                      style: TextStyle(
                          fontFamily: PsConfig.hkgrotesk_font_family,
                          fontSize: 11,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(UserProvider userProvider) {
    final String bio = userProvider.serviceProvider['bio'];

    return Container(
      child: RichText(
        text: TextSpan(
            style: TextStyle(
                fontSize: 15,
                height: 1.5,
                fontFamily: PsConfig.hkgrotesk_font_family,
                color: AppColors.dark_black),
            children: [
              TextSpan(
                text: bio.toString()[0],
                style: TextStyle(
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.w700,
                    fontFamily: PsConfig.hkgrotesk_font_family,
                    color: AppColors.dark_black),
              ),
              TextSpan(text: bio.toString().substring(1))
            ]),
      ),
      padding: EdgeInsets.all(20),
    );
  }

  Widget _buildImageSlider(Size size, UserProvider userProvider) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 0.66,
        height: 120,
      ),
      items: _buildImages(size, userProvider.serviceProvider['portfolio']),
    );
  }

  List<Widget> _buildImages(Size size, dynamic photos) {
    List<Widget> list = [];
    photos.forEach((p) {
      final Widget image = Container(
        width: size.width,
        margin: EdgeInsets.only(left: 5, right: 5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: p['url'],
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
      );
      list.add(image);
    });

    return list;
  }

  @override
  Widget build(BuildContext context) {
    dynamic userProvider = Provider.of<UserProvider>(context, listen: true);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.scaffold_bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfilePhoto(userProvider),
            _buildName(userProvider),
            _buildRatingsLevel(),
            EditBlackButton(text: "Edit Profile", size: size),
            _buildDescription(userProvider),
            _buildImageSlider(size, userProvider)
          ],
        ),
      ),
    );
  }
}
