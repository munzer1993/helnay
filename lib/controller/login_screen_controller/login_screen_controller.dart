// ignore_for_file: unrelated_type_equality_checks, await_only_futures

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/constant/loader.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/signup_screen_datasorcue/signup_datasource.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class LoginScreencontroller extends GetxController {
  void goToRegisterScreen();
  void goToForrgetPasswordScreen();
  void login();
  Future<UserCredential?> signIn(
      {required String email, required String password});
  void onGoogleTap();
  void onAppleTap();
}

class LoginScreencontrollerIMP extends LoginScreencontroller {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isShowPassword = true;
  IconData iconDate = CupertinoIcons.eye_slash_fill;
  StatusRequest? statusRequest;
  MyServices myServices = Get.find();
  SignupDataSource signupDataSource = SignupDataSource(Get.find());
  RegistrationUserData? registrationUserData;
  RegistrationUserData? _registrationUserData;
  double? long;
  double? lat;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    long = Get.arguments['long'];
    lat = Get.arguments['lat'];
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  changeShowPassword() {
    if (isShowPassword == true) {
      isShowPassword = false;
      iconDate = CupertinoIcons.eye_solid;
    } else {
      isShowPassword = true;
      iconDate = CupertinoIcons.eye_slash_fill;
    }
    update();
  }

  @override
  void goToForrgetPasswordScreen() {
    Get.toNamed(AppRoutes.forgetPasswordScreen);
  }

  @override
  void goToRegisterScreen() {
    Get.toNamed(AppRoutes.registerScreen);
  }

  @override
  login() async {
    signIn(email: emailController.text, password: passwordController.text)
        .then((value) async {
      if (emailController.text == value?.user?.email) {
        if (value?.user?.emailVerified == true) {
          if (kDebugMode) {
            print(tokenID);
          }
          statusRequest = StatusRequest.loading;
          Loader().lottieLoader();
          var response = await signupDataSource.signUpData(
              email: emailController.text,
              fullName: "",
              deviceToken: tokenID,
              loginType: 4);
          statusRequest = handlingData(response);
          if (statusRequest == StatusRequest.success) {
            statusRequest = StatusRequest.success;
            Get.back();
            _registrationUserData =
                RegistrationUserData.fromJson(response['data']);
            user__ID = _registrationUserData!.id!;
            await myServices.sharedPreferences.setBool("isLogin", true);
            await myServices.sharedPreferences
                .setString("registrationUser", jsonEncode(response['data']));
            if (_registrationUserData?.age == null) {
              Get.toNamed(AppRoutes.startDataUserInteryScreen,
                  arguments: {'long': long, 'lat': lat});
            } else if (_registrationUserData?.images == null ||
                _registrationUserData!.images!.isEmpty) {
              Get.toNamed(AppRoutes.selectPhotoScreen);
            } else {
              Get.toNamed(AppRoutes.homeScreen);
            }
          } else {
            Get.back();
            statusRequest = StatusRequest.failure;
            update();
          }
        } else {
          Get.back();
          Get.snackbar(
              "Success !!", "please Verfiry Your e-mail check your inbox",
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        update();
      }
    });
  }

  @override
  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      return await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error !!", '${e.message}',
          snackPosition: SnackPosition.BOTTOM);

      return null;
    }
  }

  Future<UserCredential?> signInWithApple() async {
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final credential = OAuthProvider('apple.com').credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
    );

    final user = await auth.signInWithCredential(credential);

    final fullName = appleIdCredential.givenName;

    final familyName = appleIdCredential.familyName;

    if (fullName != null || familyName != null) {
      String name = '$fullName $familyName';
      await user.user?.updateDisplayName(name);
      await myServices.sharedPreferences.setString("fullName", name);
      update();
    }
    // await user.user?.updateDisplayName(familyName);
    return user;
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    //final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleSignInAccount?.authentication;

    // Create a new credential
    if (googleAuth == null ||
        googleAuth.accessToken == null ||
        googleAuth.idToken == null) {
      Get.back();
      return null;
    }
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final user = await auth.signInWithCredential(credential);
    return user;
  }

  void registerNewUsers({
    required String? email,
    required String? name,
    required int loginType,
  }) async {
    statusRequest = StatusRequest.loading;
    Loader().lottieLoader();
    var response = await signupDataSource.signUpData(
        email: email,
        fullName: name,
        deviceToken: tokenID,
        loginType: loginType);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      Get.back();
      registrationUserData = RegistrationUserData.fromJson(response['data']);
      AppLink.aUserId = registrationUserData!.id!;
      user__ID = registrationUserData!.id!;
      await myServices.sharedPreferences
          .setString("registrationUser", jsonEncode(registrationUserData));
      await myServices.sharedPreferences.setBool("isLogin", true);
      await myServices.sharedPreferences
          .setString("latitude", registrationUserData!.lattitude!);
      await myServices.sharedPreferences
          .setString("longitude", registrationUserData!.longitude!);
      if (registrationUserData != null) {
        await myServices.sharedPreferences
            .setString("registrationUser", jsonEncode(registrationUserData));
        if (registrationUserData?.age == null) {
          Get.toNamed(AppRoutes.startDataUserInteryScreen,
              arguments: {'long': long, 'lat': lat});
        } else if (registrationUserData?.images == null ||
            registrationUserData!.images!.isEmpty) {
          Get.toNamed(AppRoutes.selectPhotoScreen);
        } else {
          Get.toNamed(AppRoutes.homeScreen);
        }
      } else {
        Get.back();
        Get.snackbar("ERROR !", "You have do something Wrong",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      statusRequest = StatusRequest.failure;
      Get.back();
      update();
    }
  }

  @override
  void onGoogleTap() {
    Loader().lottieLoader();
    signInWithGoogle().then((value) async {
      if (value == null) {
        Get.back();
        return;
      }
      // if (value?.user?.email == null||value!.user!.email!.isEmpty) return;
      Get.back();
      registerNewUsers(
          email: value.user?.email,
          name: value.user?.displayName,
          loginType: 1);
    });
  }

  @override
  void onAppleTap() {
    Loader().lottieLoader();
    signInWithApple().then((value) async {
      if (value == null) {
        return;
      }
      String appleFullName =
          await myServices.sharedPreferences.getString("fullName") ?? '';
      Get.back();
      registerNewUsers(
          email: value.user?.email, name: appleFullName, loginType: 2);

      update();
    });
  }
}
