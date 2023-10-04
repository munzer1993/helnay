// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/models/users/register_model.dart';

class UserDetailsScreenDataSource {
  Crud curd;
  UserDetailsScreenDataSource(this.curd);
  MyServices myServices = Get.find();

  Future<RegistrationUserData?> getUserData() async {
    String? data =
        await myServices.sharedPreferences.getString('registrationUser');
    if (data == null || data.isEmpty) return null;
    return RegistrationUserData.fromJson(jsonDecode(data));
  }

  updateSaveTap({int? profileId}) async {
    var userData = await getUserData();
    String? savedProfile = userData?.savedprofile;
    List<int> savedProfileList = [];
    if (savedProfile != null &&
        savedProfile.isNotEmpty &&
        !savedProfile.contains(profileId.toString())) {
      savedProfile += ',$profileId';
    } else {
      if (savedProfile == null || savedProfile.isEmpty) {
        savedProfile = profileId.toString();
      } else if (savedProfile.contains(profileId.toString())) {
        for (int i = 0; i < savedProfile.split(',').length; i++) {
          savedProfileList.add(int.parse(savedProfile.split(',')[i]));
        }
        for (int i = 0; i < savedProfile.split(',').length; i++) {
          if (savedProfile.split(',')[i] == profileId.toString()) {
            savedProfileList.removeAt(i);
            break;
          }
        }
        savedProfile = savedProfileList.join(",");
      }
    }

    var response =
        await curd.postData(linkUrl: AppLink.updateSavedProfile, data: {
      'user_id': user__ID.toString(),
      'profiles': savedProfile,
    });
    return response.fold((l) => l, (r) => r);
  }

  updateLikedProfile({int? profileId}) async {
    var userData = await getUserData();
    String? likedProfile = userData?.likedprofile;
    List<int> list = [];
    if (likedProfile != null &&
        likedProfile.isNotEmpty &&
        !likedProfile.contains(profileId.toString())) {
      likedProfile += ',$profileId';
    } else {
      if (likedProfile == null || likedProfile.isEmpty) {
        likedProfile = profileId.toString();
      } else if (likedProfile.contains(profileId.toString())) {
        for (int i = 0; i < likedProfile.split(',').length; i++) {
          list.add(int.parse(likedProfile.split(',')[i]));
        }
        for (int i = 0; i < likedProfile.split(',').length; i++) {
          if (likedProfile.split(',')[i] == profileId.toString()) {
            list.removeAt(i);
            break;
          }
        }
        likedProfile = list.join(",");
      }
    }
    var response =
        await curd.postData(linkUrl: AppLink.updateLikedProfile, data: {
      'user_id': user__ID.toString(),
      'profiles': likedProfile,
    });
    return response.fold((l) => l, (r) => r);
  }

  notifyLikeUser({required int userId, required int type}) async {
    var response = await curd.postData(linkUrl: AppLink.notifyLikedUser, data: {
      "user_id": userId.toString(),
      "data_user_id": user__ID.toString(),
      "type": type.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  getProfile({int? userID}) async {
    var response = await curd.postData(linkUrl: AppLink.getProfile, data: {
      "user_id": userID.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
