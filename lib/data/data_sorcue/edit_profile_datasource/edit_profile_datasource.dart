import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/models/users/update_profile_model.dart';

class EditProfileDataSource {
  Crud crud;
  EditProfileDataSource(this.crud);
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());

  getInterest() async {
    var response = await crud.postData(linkUrl: AppLink.getInterests, data: {});
    return response.fold((l) => l, (r) => r);
  }

  Future<UpdateProfile> updateProfile(
      {List<File>? images,
      String? live,
      String? bio,
      List<String>? interest,
      String? age,
      String? latitude,
      String? longitude,
      String? instagram,
      String? facebook,
      String? youtube,
      String? fullName,
      List<String>? deleteImageIds,
      int? gender,
      String? about}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppLink.updateProfile),
    );
    request.headers.addAll({
      AppLink.aApiKeyName: AppLink.aApiKey,
    });
    request.fields['user_id'] = user__ID.toString();
    if (live != null) {
      request.fields['live'] = live;
    }
    if (bio != null) {
      request.fields['bio'] = bio;
    }
    if (age != null) {
      request.fields['age'] = age;
    }
    if (fullName != null) {
      request.fields['fullname'] = fullName;
    }
    if (instagram != null) {
      request.fields['instagram'] = instagram;
    }
    if (facebook != null) {
      request.fields['facebook'] = facebook;
    }
    if (youtube != null) {
      request.fields['youtube'] = youtube;
    }
    if (latitude != null) {
      request.fields['lattitude'] = latitude;
    }
    if (longitude != null) {
      request.fields['longitude'] = longitude;
    }
    if (interest != null) {
      request.fields['interests'] = interest.join(",");
    }
    if (gender != null) {
      request.fields['gender'] = gender.toString();
    }
    if (about != null) {
      request.fields['about'] = about;
    }
    List<http.MultipartFile> newList = <http.MultipartFile>[];
    Map<String, String> map = {};

    if (deleteImageIds != null) {
      for (int i = 0; i < deleteImageIds.length; i++) {
        map['${'deleteimageids[]'}[$i]'] = deleteImageIds[i];
        // request.fields[ConstRes.aDeleteImagesId] = deleteImageIds[i];
      }
    }
    request.fields.addAll(map);
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        File imageFile = images[i];
        var multipartFile = http.MultipartFile('image[]',
            imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
            filename: imageFile.path.split('/').last);
        newList.add(multipartFile);
      }
    }
    request.files.addAll(newList);
    // if (image != null) {
    //   request.files.add(http.MultipartFile(
    //       'image', image.readAsBytes().asStream(), image.lengthSync(),
    //       filename: image.path.split("/").last));
    // }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    // print(respStr);
    final responseJson = jsonDecode(respStr);
    UpdateProfile updateProfile = UpdateProfile.fromJson(responseJson);
    await constantDataSource.saveUser(updateProfile.data);
    constantDataSource.updateFirebase();
    return updateProfile;
  }
}
