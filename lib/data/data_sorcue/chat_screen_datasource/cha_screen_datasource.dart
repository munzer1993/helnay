import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/curd.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/wallet_model/minus_coin_from_wallet.dart';

class ChatDataSource {
  Crud crud;

  ChatDataSource(this.crud);

  Future<StoreFileGivePath> getStoreFileGivePath({File? image}) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppLink.storageFileGivePath),
    );
    request.headers.addAll({
      AppLink.aApiKeyName: AppLink.aApiKey,
    });
    if (image != null) {
      request.files.add(
        http.MultipartFile(
            'file', image.readAsBytes().asStream(), image.lengthSync(),
            filename: image.path.split("/").last),
      );
    }
    var response = await request.send();
    var respStr = await response.stream.bytesToString();
    final responseJson = jsonDecode(respStr);
    StoreFileGivePath applyForVerification =
        StoreFileGivePath.fromJson(responseJson);
    return applyForVerification;
  }

  Future pushNotification(
      {required String authorization,
      required String title,
      required String body,
      required String token}) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Authorization': 'key=$authorization',
        'content-type': 'application/json'
      },
      body: json.encode(
        {
          'notification': {
            'title': title,
            'body': body,
            "sound": "default",
            "badge": "1"
          },
          'to': '/token/$token',
        },
      ),
    );
  }

  Future<MinusCoinFromWallet> minusCoinFromWallet(int? amount) async {
    http.Response response = await http.post(
        Uri.parse(AppLink.minusCoinsFromWallet),
        headers: {AppLink.aApiKeyName: AppLink.aApiKey},
        body: {'user_id': user__ID.toString(), 'amount': amount.toString()});
    return MinusCoinFromWallet.fromJson(jsonDecode(response.body));
  }
}
