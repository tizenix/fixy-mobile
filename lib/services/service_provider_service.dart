import 'dart:convert';

import 'package:fixy_mobile/config/app_const.dart';
import 'package:http/http.dart';

abstract class BaseServiceProvider {
  Future<dynamic> getServiceProviderDetails(String id, String token);
}

class ServiceProviderService extends BaseServiceProvider {
  @override
  Future<dynamic> getServiceProviderDetails(String id, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + SERVICE_PROVIDER_DETAILS + '/$id';
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    print("Token $token");

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
