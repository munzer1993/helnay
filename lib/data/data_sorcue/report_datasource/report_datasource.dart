import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';

class ReportDataSource {
  Crud crud;
  ReportDataSource(this.crud);

  addReport(String reason, String description, int? id) async {
    var response = await crud.postData(linkUrl: AppLink.addReport, data: {
      'reason': reason,
      'description': description,
      'user_id': id.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
