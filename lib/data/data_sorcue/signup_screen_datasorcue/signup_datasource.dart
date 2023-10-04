// ignore_for_file: unused_element

import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';

class SignupDataSource {
  Crud curd;
  SignupDataSource(this.curd);

  signUpData(
      {required String? email,
      required String? fullName,
      required String? deviceToken,
      required int? loginType,
      String? password}) async {
    var response = await curd.postData(linkUrl: AppLink.registerAPI, data: {
      "fullname": fullName,
      "device_token": tokenID,
      "device_type": GetPlatform.isAndroid ? "1" : "2",
      "login_type": loginType.toString(),
      "identity": email,
      "interests": "",
    });
    return response.fold((l) => l, (r) => r);
  }
}
