// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/models/users/register_model.dart';

class MessageDataSource {
  Crud curd;
  MessageDataSource(this.curd);

  MyServices myServices = Get.find();

  Future<RegistrationUserData?> getUserData() async {
    String? data =
        await myServices.sharedPreferences.getString('registrationUser');
    if (data == null || data.isEmpty) return null;
    return RegistrationUserData.fromJson(jsonDecode(data));
  }

  Future<bool?> getDialog(String key) async {
    return myServices.sharedPreferences.getBool(key);
  }

  Future<void> saveUser(RegistrationUserData? value) async {
    if (value != null) {
      await myServices.sharedPreferences
          .setString('registrationUser', jsonEncode(value));
    }
  }

  userBlockList(int? blockProfileId) async {
    var userData = await getUserData();
    String? blockProfile = userData?.blockedUsers;
    List<int> blockProfileList = [];
    if (blockProfile != null &&
        blockProfile.isNotEmpty &&
        !blockProfile.contains(blockProfileId.toString())) {
      blockProfile += ',$blockProfileId';
    } else {
      if (blockProfile == null || blockProfile.isEmpty) {
        blockProfile = blockProfileId.toString();
      } else if (blockProfile.contains(blockProfileId.toString())) {
        for (int i = 0; i < blockProfile.split(',').length; i++) {
          blockProfileList.add(int.parse(blockProfile.split(',')[i]));
        }
        for (int i = 0; i < blockProfile.split(',').length; i++) {
          if (blockProfile.split(',')[i] == blockProfileId.toString()) {
            blockProfileList.removeAt(i);
            break;
          }
        }
        blockProfile = blockProfileList.join(",");
      }
    }
    var response = await curd.postData(linkUrl: AppLink.updateBlockList, data: {
      "user_id": user__ID.toString(),
      "blocked_users": blockProfileId,
    });
    return response.fold((l) => l, (r) => r);
  }
}
