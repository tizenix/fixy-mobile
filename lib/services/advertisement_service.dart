import 'dart:convert';

import 'package:fixy_mobile/config/app_const.dart';
import 'package:http/http.dart';

abstract class BaseAdvertisement {
  Future<dynamic> getAdvertisement(dynamic map, String token);

  Future<dynamic> getAdvertisementList(
      String token, String searchText, List<dynamic> selectedCities);

  Future<dynamic> createAdvertisements(dynamic map, String token);

  Future<dynamic> updateAdvertisements(dynamic map, String id, String token);

  Future<dynamic> deleteAdvertisements(dynamic map, String token);
}

class AdvertisementService extends BaseAdvertisement {
  @override
  Future<dynamic> getAdvertisement(map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + GET_ADVERTISEMENTS + "/$map";
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
  Future<dynamic> getAdvertisementList(
    String token,
    String searchText,
    List<dynamic> selectedCities,
  ) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    Map<String, String> params = {"Title_contains": searchText};
    String paramsString = Uri(queryParameters: params).query;
    final String url = BASE_URL + GET_ADVERTISEMENTS + "?$paramsString";
    final Uri uri = Uri.parse(url);

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
  Future<dynamic> createAdvertisements(map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + CREATE_ADVERTISEMENTS;
    final Uri uri = Uri.parse(url);

    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    Map body = {
      "Title": map["Title"],
      "startingPrice": map["startingPrice"],
      "Description": map["Description"],
      "sub_categories": map["sub_categories"],
      "tags": map["tags"],
      "cities": map["cities"],
      "service_provider_detail": map["service_provider_detail"],
      "company_detail": map["company_detail"],
      "adType": map["adType"],
      "IsPromoted": map["IsPromoted"],
    };

    String jsonString = jsonEncode(body);

    int statusCode;

    try {
      final Response response = await post(
        uri,
        body: jsonString,
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
  Future<dynamic> updateAdvertisements(map, String id, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + UPDATE_ADVERTISEMENTS + '/$id';
    final Uri uri = Uri.parse(url);

    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    Map body = {
      "Title": map["Title"],
      "startingPrice": map["startingPrice"],
      "Description": map["Description"],
      "sub_categories": map["sub_categories"],
      "tags": map["tags"],
      "cities": map["cities"],
      "service_provider_detail": map["service_provider_detail"],
      "company_detail": map["company_detail"],
      "adType": map["adType"],
      "IsPromoted": map["IsPromoted"],
    };

    String jsonString = jsonEncode(body);

    int statusCode;

    try {
      final Response response = await put(
        uri,
        body: jsonString,
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
  Future<dynamic> deleteAdvertisements(map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + DELETE_ADVERTISEMENTS + "/${map["id"]}";
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    int statusCode;

    try {
      final Response response = await delete(
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
