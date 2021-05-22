import 'package:fixy_mobile/config/config.dart';
import 'package:flutter/material.dart';

class ProgressHudCustom extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  ProgressHudCustom({this.text, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: PsConfig.hkgrotesk_font_family,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
