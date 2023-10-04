// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/users/register_model.dart';

class ConstantDataSource {
  Crud curd;
  ConstantDataSource(this.curd);
  MyServices myServices = Get.find();
  Conversation? conversation;
  FirebaseFirestore db = FirebaseFirestore.instance;
  RegistrationUserData? _registrationUserData;

  Future<RegistrationUserData?> getUserData() async {
    String? data =
        await myServices.sharedPreferences.getString('registrationUser');
    if (data == null || data.isEmpty) return null;
    return RegistrationUserData.fromJson(jsonDecode(data));
  }

  getProfile({int? userID}) async {
    var response = await curd.postData(linkUrl: AppLink.getProfile, data: {
      "user_id": userID.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }

  Future<void> saveUser(RegistrationUserData? value) async {
    if (value != null) {
      await myServices.sharedPreferences
          .setString('registrationUser', jsonEncode(value));
    }
  }

  void updateFirebase() async {
    _registrationUserData = await getUserData();
    db
        .collection('userchatlist')
        .doc(_registrationUserData?.identity)
        .collection('userlist')
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then((value) {
      for (var element in value.docs) {
        db
            .collection('userchatlist')
            .doc(element.data().user?.userIdentity)
            .collection('userlist')
            .doc(_registrationUserData?.identity)
            .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              },
            )
            .get()
            .then((value) {
          ChatUser? user = value.data()?.user;
          user?.username = _registrationUserData?.fullname ?? '';
          user?.age = _registrationUserData?.age != null
              ? _registrationUserData?.age.toString()
              : '';
          user?.image = _registrationUserData?.images?[0].image ?? '';
          user?.city = _registrationUserData?.live ?? '';
          db
              .collection('userchatlist')
              .doc(element.data().user?.userIdentity)
              .collection('userlist')
              .doc(_registrationUserData?.identity)
              .update({'user': user?.toJson()});
        });
      }
    });
  }
}
