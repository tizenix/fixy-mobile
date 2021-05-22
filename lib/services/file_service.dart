import 'dart:convert';
import 'dart:io';

import 'package:fixy_mobile/config/app_const.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseFile {
  Future<dynamic> upload(dynamic map, String token);
  Future<dynamic> delete(String id, String token);
}

class FileService implements BaseFile {
  // ===============================================
  // Upload
  // ===============================================
  @override
  Future<dynamic> upload(dynamic map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + FILE_UPLOAD;

    var headers = {AUTHORIZATION: "Bearer $token"};
    int statusCode;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      if (map['source'] != null) {
        request.fields.addAll({
          'ref': map['ref'],
          'refId': map['refId'].toString(),
          'field': map['field'],
          'path': map['path'],
          'source': map['source']
        });
      } else {
        request.fields.addAll({
          'ref': map['ref'],
          'refId': map['refId'].toString(),
          'field': map['field'],
          'path': map['path']
        });
      }

      List<dynamic> files = map['files'];
      for (File f in files) {
        request.files.add(await http.MultipartFile.fromPath('files', f.path));
      }

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      statusCode = response.statusCode;
      final respStr = await response.stream.bytesToString();
      if (statusCode != 200 && statusCode != 201) {
        throw new Exception(respStr);
      }

      hasError = false;
      message = respStr;
    } catch (e) {
      hasError = true;
      message = e.message;
    }

    return {SUCCESS_KEY: !hasError, MESSAGE_KEY: message};
  }

  // ===============================================
  // Delete
  // ===============================================
  @override
  Future<dynamic> delete(String id, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + FILE_DELETE + id;
    final Uri uri = Uri.parse(url);

    var headers = {AUTHORIZATION: "Bearer $token"};
    int statusCode;

    try {
      final Response response = await http.delete(uri, headers: headers);

      statusCode = response.statusCode;
      dynamic responseMap = jsonDecode(response.body);
      if (statusCode != 200 && statusCode != 201) {
        dynamic messages = responseMap['data'][0]['messages'][0]['message'];
        throw new Exception(messages);
      }

      hasError = false;
      message = responseMap;
    } catch (e) {
      hasError = true;
      message = e.message;
    }

    return {SUCCESS_KEY: !hasError, MESSAGE_KEY: message};
  }
}
