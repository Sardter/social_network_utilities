import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_network_utilities/auth/auth.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:social_network_utilities/utilities/utilities.dart';

enum APIAction { get, post, delete, put }

final Hidden_Form_Headers = {
  HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
};

class APIService {
  final String tokenRefreshUrl;

  static List<int> safeStatus = const [200, 201];

  APIService({required this.tokenRefreshUrl});

  Future<http.Response> _get({required String url, String? token}) async {
    return await http.get(Uri.parse(url), headers: {
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
    });
  }

  Future<http.Response> _post(
      {required String url,
      String? token,
      required Map? body,
      required Map<String, String>? headers}) async {
    return await http.post(Uri.parse(url),
        headers: headers ??
            {
              if (token != null)
                HttpHeaders.authorizationHeader: 'Bearer ${token}',
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
        body: jsonEncode(body));
  }

  Future<http.Response> _put(
      {required String url, String? token, required Map? body}) async {
    return await http.put(Uri.parse(url),
        headers: {
          if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
  }

  Future<http.Response> _delete({required String url, String? token}) async {
    return await http.delete(Uri.parse(url), headers: {
      if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    });
  }

  static Future<dynamic> _decodeResponse(
      http.Response response, BuildContext? context,
      {bool showErrors = true}) async {
    try {
      final decoded = json.decode(utf8.decode(response.bodyBytes));
      if (!safeStatus.contains(response.statusCode) &&
          showErrors &&
          context != null) {
        for (List errors in decoded.values) {
          for (var error in errors) {
            await showSocialUtilSnackbar(
                context: context,
                message: error,
                type: DisplayMessageType.Danger);
          }
        }
      }
      return decoded;
    } catch (e) {
      if (showErrors && context != null)
        await showSocialUtilSnackbar(
            context: context,
            message: LanguageService().data.errors.somethingWentWrong,
            type: DisplayMessageType.Danger);
      return null;
    }
  }

  Future<bool> _refreshToken(BuildContext? context, AuthService auth) async {
    String? token = await auth.refresh;

    if (token == null) return false;

    final response = await _post(
      url: tokenRefreshUrl,
      body: {'token': token},
      headers: null,
    );
    final items = await _decodeResponse(response, context);
    if (response.statusCode == 401) return false;

    try {
      auth.setCredentials(AuthCredentials.fromJson(items));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<http.Response> _actionAndResponse(
      {required String url,
      required String? accessToken,
      required Map? body,
      required Map<String, String>? headers,
      required APIAction action}) async {
    switch (action) {
      case APIAction.get:
        return _get(url: url, token: accessToken);
      case APIAction.post:
        return _post(
            url: url, body: body, token: accessToken, headers: headers);
      case APIAction.delete:
        return _delete(url: url, token: accessToken);
      case APIAction.put:
        return _put(url: url, body: body, token: accessToken);
    }
  }

  Future<dynamic> actionAndGetResponseItems(
      {BuildContext? context,
      required String url,
      required AuthService authService,
      Map? body,
      Map<String, String>? headers,
      bool showDecodeErrors = true,
      APIAction action = APIAction.get}) async {
    final authCred = await authService.credentials;
    http.Response? response;

    print("auth cred: ${authCred?.toJson()}");

    if (authCred == null) {
      response = await _actionAndResponse(
          url: url,
          accessToken: null,
          body: body,
          action: action,
          headers: headers);
    } else {
      response = await _actionAndResponse(
          url: url,
          accessToken: (await authService.credentials)?.accessToken,
          body: body,
          headers: headers,
          action: action);
      if (!safeStatus.contains(response.statusCode)) {
        if (!await _refreshToken(context, authService)) {
          response = await _actionAndResponse(
              url: url,
              accessToken: null,
              body: body,
              action: action,
              headers: headers);
        } else {
          response = await _actionAndResponse(
              url: url,
              headers: headers,
              accessToken: (await authService.credentials)?.accessToken,
              body: body,
              action: action);
        }

        if (!safeStatus.contains(response.statusCode)) {
          if (context != null)
            await showSocialUtilSnackbar(
                context: context,
                message: LanguageService().data.alerts.loggedOut);
          authService.clear();
        }
      }
    }

    print("body: $body");

    print("url: $url");
    print("response (${response.statusCode}): ${response.body}");

    return await _decodeResponse(response, context,
        showErrors: showDecodeErrors);
  }
}
