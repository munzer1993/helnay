import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';

class NotificationDataSource {
  Crud crud;
  NotificationDataSource(this.crud);
  adminNotifiation(int start) async {
    var response = await crud.postData(
        linkUrl: AppLink.getAdminNotification,
        data: {"start": start.toString(), "count": '15'});
    return response.fold((l) => l, (r) => r);
  }

  getUserNotification(int start) async {
    var response = await crud.postData(
        linkUrl: AppLink.getUserNotification,
        data: {
          "user_id": user__ID.toString(),
          "start": start.toString(),
          'count': '15'
        });
    return response.fold((l) => l, (r) => r);
  }
}
