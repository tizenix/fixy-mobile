import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditBlackButton extends StatelessWidget {
  final String text;
  final Size size;

  EditBlackButton({this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dark_black,
      height: 50,
      width: size.width,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: PsConfig.hkgrotesk_font_family,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset('assets/images/reply_all.svg'),
          )
        ],
      ),
    );
  }
}
