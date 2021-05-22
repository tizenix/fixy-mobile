import 'package:fixy_mobile/config/app_colors.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatefulWidget {
  const WarningDialog(
      {this.message, this.onPressed, this.buttonColor: AppColors.purple});
  final String message;
  final Function onPressed;
  final Color buttonColor;
  @override
  _WarningDialogState createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final WarningDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 60,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 10),
                    Text('Message',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: PsConfig.hkgrotesk_font_family,
                            fontWeight: FontWeight.w600)),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                widget.message,
                style: Theme.of(context).textTheme.subtitle2,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Divider(thickness: 0.5, height: 1, color: this.widget.buttonColor),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              color: this.widget.buttonColor,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onPressed();
              },
              child: Text(
                'Ok',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
            )
          ],
        ));
  }
}
