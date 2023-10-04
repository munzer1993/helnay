import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';

class HomeBottomNaBarWidgetDataSource {
  Crud curd;
  HomeBottomNaBarWidgetDataSource(this.curd);

  getDataUsers() async {
    var response = await curd.postData(
      linkUrl: AppLink.getExplorePageProfileList,
      data: {'user_id': user__ID.toString()},
    );
    return response.fold((l) => l, (r) => r);
  }

  getProfileData({int? userID}) async {
    var response = await curd.postData(linkUrl: AppLink.getProfile, data: {
      "user_id": userID.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
