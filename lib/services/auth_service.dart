import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixy_mobile/config/app_const.dart';
import 'package:fixy_mobile/config/config.dart';
import 'package:http/http.dart';

abstract class BaseAuth {
  Future<dynamic> register(dynamic map, UserType userType);
  Future<dynamic> createServiceProviderDetails(dynamic map, String token);
  Future<dynamic> createCompanyDetails(dynamic map, String token);
  Future<dynamic> login(String username, String password);
  Future<dynamic> forgotPassword(String username);
  Future<dynamic> resetPassword(String username, String password);
}

class AuthService implements BaseAuth {
  // ===============================================
  // Register
  // ===============================================
  @override
  Future<dynamic> register(dynamic map, UserType userType) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + AUTH_LOCAL_REGISTER;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    String serviceType = "";

    if (userType == UserType.ServiceProvider) {
      serviceType =
          map['serviceType'] == ServiceType.Individual.index ? 'Sp' : 'Orgsp';
    } else {}

    Map body = {
      'username': map['username'],
      'email': map['email'],
      'provider': 'local',
      'password': map['password'],
      'role': serviceType,
      'firstName': map['firstName'],
      'lastName': map['lastName'],
      'nicNumber': map['nicNumber'],
      'birthDate': map['birthDate'],
      'phoneNumber': map['phoneNumber'],
      'location_latitude': 0,
      'location_longitude': 0,
      'gender': map['gender'],
      'firebase_uid': map['firebase_uid']
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

  // ===============================================
  // Create Service Provide Details
  // ===============================================
  @override
  Future<dynamic> createServiceProviderDetails(
      dynamic map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + SERVICE_PROVIDER_DETAILS;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    Map body = map;
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

  // ===============================================
  // Create Company Details
  // ===============================================
  @override
  Future<dynamic> createCompanyDetails(dynamic map, String token) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + COMPANY_DETAILS;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token"
    };

    Map body = map;
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

  // ===============================================
  // Login
  // ===============================================
  @override
  Future<dynamic> login(String username, String password) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + AUTH_LOCAL;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    Map body = {'identifier': username, 'password': password};

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

  // ===============================================
  // Forgot Password
  // ===============================================
  @override
  Future<dynamic> forgotPassword(String username) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + AUTH_FORGOT_PASSWORD;

    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};
    final Uri uri = Uri.parse(url);
    Map body = {'identifier': username};

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

  // ===============================================
  // Forgot Password
  // ===============================================
  @override
  Future<dynamic> resetPassword(String username, String password) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    final String url = BASE_URL + AUTH_RESET_PASSWORD;
    final Uri uri = Uri.parse(url);
    Map<String, String> headers = {CONTENT_TYPE: APPLICATION_JSON};

    Map body = {'identifier': username, 'password': password};

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

  // ===============================================
  // Phone Number Authentication
  // ===============================================
  Future<Map<String, dynamic>> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    bool hasError = true;
    dynamic message = SOMETHING_WENT_WRONG;

    try {
      AuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      if (result.user != null) {
        hasError = false;
        message = result.user;
      } else {
        hasError = true;
        message = 'Login Error';
      }
    } catch (error) {
      hasError = true;
      message = error.message;
    }

    return {SUCCESS_KEY: !hasError, MESSAGE_KEY: message};
  }
}
