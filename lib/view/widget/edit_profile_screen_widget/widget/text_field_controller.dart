import 'package:get/get.dart';

class ProfileTextFieldController extends GetxController {
  Rx<String> address = ''.obs;
  Rx<String> bio = ''.obs;
  Rx<String> about = ''.obs;
  Rx<String> age = " ".obs;

  void onAddressChange(String? value) {
    if (value != null) {
      address.value = value;
    }
  }

  void onBioChange(String? value) {
    if (value != null) {
      bio.value = value;
    }
  }

  void onAboutChange(String? value) {
    if (value != null) {
      about.value = value;
    }
  }

  void onAgeChange(String? value) {
    if (value != null) {
      age.value = value;
    }
  }
}
