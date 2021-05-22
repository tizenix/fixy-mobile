import 'dart:convert';

import 'package:fixy_mobile/config/app_const.dart';
import 'package:http/http.dart';

abstract class BaseCategory {
  Future<dynamic> getMainCategories(dynamic map, String token);
  Future<dynamic> getSubCategories(dynamic map, String token);
}

class CategoryService extends BaseCategory {
  @override
  Future<dynamic> getMainCategories(map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + MAIN_CATEGORIES;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    int statusCode;

    try {
      final Response response = await get(
        uri,
        headers: headers,
      );

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

  @override
  Future getSubCategories(map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + SUB_CATEGORIES + '/' + map['id'];
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    int statusCode;

    try {
      final Response response = await get(
        uri,
        headers: headers,
      );

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
