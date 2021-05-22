import 'dart:convert';
import 'dart:io';

class AppUtil {
  static Future<String> getBase64(File imageFile) async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    //print('Bytes : ${imageBytes}');
    return base64Encode(imageBytes);
  }

  static bool validEmail(String email) {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(email);
  }
}
