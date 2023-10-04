import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';

class OptionDataSource {
  Crud crud;
  OptionDataSource(this.crud);

  logoutUser() async {
    var response = await crud.postData(linkUrl: AppLink.logoute, data: {
      'user_id': user__ID.toString(),
    });

    return response.fold((l) => l, (r) => r);
  }

  deleteAccount(int? deleteId) async {
    var response = await crud.postData(linkUrl: AppLink.deleteMyAccount, data: {
      'user_id': deleteId.toString(),
    });

    return response.fold((l) => l, (r) => r);
  }
}
