import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

abstract class ForgetPasswordScreenController extends GetxController {
  void goBack();
  void resetBtnClick();
}

class ForgetPasswordScreenControllerIMP extends ForgetPasswordScreenController {
  late TextEditingController emailController;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    emailController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  void goBack() {
    Get.back();
  }

  @override
  void resetBtnClick() async {
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
      emailController.clear();
      Get.back();
      Get.snackbar("SUCCESS ", "Email sent Successfully...",
          snackPosition: SnackPosition.BOTTOM);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("ERROR !", '${e.message}',
          snackPosition: SnackPosition.BOTTOM);
      Get.back();
    }
  }
}
