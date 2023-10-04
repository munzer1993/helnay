import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/check_internet.dart';

class Crud {
  Future<Either<StatusRequest, Map>> postData({
    required String linkUrl,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (await checkInternet()) {
        var response = await http.post(Uri.parse(linkUrl),
            body: jsonEncode(data),
            headers: {
              AppLink.aApiKeyName: AppLink.aApiKey,
              "Content-Type": "application/json"
            });
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responsebody = jsonDecode(response.body);
          if (kDebugMode) {
            print(response.statusCode);
          }
          return Right(responsebody);
        } else if (response.statusCode == 400) {
          if (kDebugMode) {
            print(response.statusCode);
          }
          return const Left(StatusRequest.exeptions);
        } else {
          if (kDebugMode) {
            print(response.statusCode);
          }
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (_) {
      return const Left(StatusRequest.serverExption);
    }
  }
}
