// ignore_for_file: unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class MessageBottomNavBarWidgetController extends GetxController {
  void onUserTap(Conversation? conversation);
  void goBack();
  void onLongPress(Conversation? conversation);
  void getChatUsers();
}

class MessageBottomNavBarWidgetControllerIMP
    extends MessageBottomNavBarWidgetController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Conversation?> userList = [];
  Conversation? conversation;
  bool isLoading = false;
  StreamSubscription<QuerySnapshot<Conversation>>? subscription;
  RegistrationUserData? userData;
  RegistrationUserData? _registrationUserData;
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());
  StatusRequest? statusRequest;

  @override
  void onInit() {
    getProfileApi();
    getChatUsers();
    super.onInit();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void getProfileApi() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      userData = RegistrationUserData.fromJson(response['data']);
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onUserTap(Conversation? conversation) {
    userData?.isBlock == 1
        ? CustomDialogWidget(
            text: "Back",
            title: "User Blocked",
            descriptions:
                "We Sorry to tell you that this user is blocked from admins",
            iconLogo: CupertinoIcons.person_crop_circle_fill_badge_xmark,
            callback: goBack,
          )
        : Get.toNamed(AppRoutes.chatScreen, arguments: conversation);
  }

  @override
  void goBack() {
    Get.back();
  }

  void updateFirebase() async {
    _registrationUserData = await constantDataSource.getUserData();
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

  @override
  void getChatUsers() async {
    isLoading = true;
    await constantDataSource.getUserData().then((value) => {
          subscription = db
              .collection('userchatlist')
              .doc(value?.identity)
              .collection('userlist')
              .orderBy('time', descending: true)
              .withConverter(
                  fromFirestore: Conversation.fromFirestore,
                  toFirestore: (Conversation value, options) =>
                      value.toFirestore())
              .snapshots()
              .listen((element) {
            userList = [];
            for (int i = 0; i < element.docs.length; i++) {
              if (element.docs[i].data().isDeleted == false) {
                userList.add(element.docs[i].data());
                update();
              }
            }
            isLoading = false;
            update();
          }),
        });
  }

  @override
  void onLongPress(Conversation? conversation) {
    HapticFeedback.vibrate();
    Get.dialog(
      ConfirmationDialog(
        aspectRatio: 1 / 0.6,
        clickText1: "Delete Chat",
        clickText2: 'CANCEL',
        heading: 'Delete this chat',
        subDescription:
            'Message will only be removed from this device\nAre you sure?',
        onNoBtnClick: goBack,
        onYesBtnClick: () {
          db
              .collection('userchatlist')
              .doc(userData?.identity)
              .collection('userlist')
              .doc(conversation?.user?.userIdentity)
              .update({
            'isDeleted': true,
            'deletedId': '${DateTime.now().millisecondsSinceEpoch}',
            'block': false,
            'blockFromOther': false,
          }).then((value) {
            Get.back();
          });
        },
        horizontalPadding: 65,
      ),
    );
    update();
  }
}
