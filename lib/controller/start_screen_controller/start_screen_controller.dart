// ignore_for_file: unused_field, prefer_final_fields, prefer_const_constructors, unused_local_variable

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:project/controller/chat_screen_controller/chat_screen_controller.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/models/users/register_model.dart';

abstract class StartScreenController extends GetxController {}

class StartScreenControllerIMP extends StartScreenController {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  MyServices myServices = Get.find();
  ConstantDataSource _constantDataSource = ConstantDataSource(Get.find());
  RegistrationUserData? userData;
  StatusRequest? statusRequest;
  List<Images> img = [];
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double? long, lat;
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    checkGps();
    getProf();
    saveTokenUpdate();
    Timer(const Duration(seconds: 3), () {
      if (myServices.sharedPreferences.getString("step") == "1") {
        if (myServices.sharedPreferences.getBool('isLogin') == true) {
          if (userData?.age == null) {
            Get.toNamed(AppRoutes.startDataUserInteryScreen,
                arguments: {"long": long, "lat": lat});
          } else if (userData?.images == null || userData!.images!.isEmpty) {
            Get.toNamed(AppRoutes.selectPhotoScreen);
          } else {
            Get.toNamed(AppRoutes.homeScreen);
          }
        } else {
          Get.toNamed(AppRoutes.loginScreen,
              arguments: {"long": long, "lat": lat});
        }
      } else {
        Get.toNamed(AppRoutes.onBoarding,
            arguments: {"long": long, "lat": lat});
      }
    });
    super.onInit();
  }

  void profileScreenApiCall(int user) async {
    statusRequest = StatusRequest.loading;
    var response = await _constantDataSource.getProfile(userID: user);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      userData = RegistrationUserData.fromJson(response['data']);
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
  }

  void getProf() async {
    await _constantDataSource.getUserData().then((value) async {
      if (value != null) {
        user__ID = value.id!;
        profileScreenApiCall(user__ID);
        update();
      }
    });
  }

  void saveTokenUpdate() async {
    await FirebaseMessaging.instance.subscribeToTopic("Orange");
    await FirebaseMessaging.instance.getToken().then((value) {
      tokenID = value;
    });

    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'Helnay', // id
      'Helnay', // title
      playSound: true,
      description: 'Helnay',
      enableLights: true,
      enableVibration: true,
      importance: Importance.max,
    );
    FirebaseMessaging.instance.subscribeToTopic("orange");
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        var initializationSettingsAndroid =
            const AndroidInitializationSettings('@mipmap/ic_launcher');
        var initializationSettingsIOS = const IOSInitializationSettings();
        var initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
        FlutterLocalNotificationsPlugin().initialize(initializationSettings);
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        AppleNotification? apple = message.notification?.apple;

        if (notification != null &&
            apple != null &&
            !ChatScreenControlleIMP.isScreen) {
          flutterLocalNotificationsPlugin.show(
            12,
            notification.title,
            notification.body,
            const NotificationDetails(
              iOS: IOSNotificationDetails(
                presentSound: true,
              ),
            ),
          );
        }

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null &&
            android != null &&
            !ChatScreenControlleIMP.isScreen) {
          flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id, channel.name,
                channelDescription: channel.description,
                // other properties...
              ),
            ),
          );
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('Location permissions are denied');
          }
        } else if (permission == LocationPermission.deniedForever) {
          if (kDebugMode) {
            print("'Location permissions are permanently denied");
          }
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        update();

        getLocation();
      }
    } else {
      if (kDebugMode) {
        print("GPS Service is not enabled, turn on GPS location");
      }
    }

    update();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (kDebugMode) {
      print(position.longitude);
    } //Output: 80.24599079
    if (kDebugMode) {
      print(position.latitude);
    } //Output: 29.6593457

    long = position.longitude;
    lat = position.latitude;

    await myServices.sharedPreferences.setString('latitude', lat.toString());
    await myServices.sharedPreferences.setString("longitude", long.toString());

    update();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      if (kDebugMode) {
        print(position.longitude);
      } //Output: 80.24599079
      if (kDebugMode) {
        print(position.latitude);
      } //Output: 29.6593457

      long = position.longitude;
      lat = position.latitude;

      update();
    });
  }
}
