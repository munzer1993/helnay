import 'package:project/data/models/users/register_model.dart';

/// status : true
/// message : "Update successful"
/// data : {"id":14,"is_block":1,"gender":1,"savedprofile":null,"likedprofile":null,"interests":[{"image":"uploads/gZCZRzfg7e6kB4cYzKgV8lRcBHLdNRwTZPyHRPYF.png","title":"Travel"},{"image":"uploads/hERepjzwQi40NcCcnk1kJOT3sc5Tkf80rsLpgmnp.png","title":"Chef"}],"age":25,"identity":"aniket@gmail.com","fullname":"Aniket Vaddoriya","instagram":"https://www.instagram.com/ankur_kalkani/?hl=en","youtube":"https://www.youtube.com/","facebook":"https://www.facebook.com/ankur.kalkani.912","live":"Surat, Gujrat, India","bio":"Roget's 21st Century Thesaurus, Third Edition Copyright © 2013 by the Philip Lief Group.","about":"😊😊😊","lattitude":null,"longitude":null,"login_type":4,"device_token":"fldaB6Ej6kyNr6r_FYotj2:APA91bGLlB3dOD-Ylu7w-GrbcL7jCT5qcC1lkc_BPE3c0TB4LxEK87kuZ3isJiGOuZxQAnSoeaTj3RQvh2v_zUkzyqQi3GGerWGrWAhMs-P7lJfRf_qZvL7dnbzcnCsdiRc7EdO6Art_","wallet":0,"total_collected":0,"total_streams":0,"device_type":2,"is_notification":1,"show_on_map":1,"anonymous":0,"is_video_call":1,"can_go_live":2,"images":[{"image":"uploads/VCufc66FOOuNeD8Aa5I5mZsQ9ZSImBlPznccqtqq.jpg","id":71}]}

class UpdateProfile {
  UpdateProfile({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UpdateProfile.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null
        ? RegistrationUserData.fromJson(json['data'])
        : null;
  }

  bool? _status;
  String? _message;
  RegistrationUserData? _data;

  UpdateProfile copyWith({
    bool? status,
    String? message,
    RegistrationUserData? data,
  }) =>
      UpdateProfile(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  RegistrationUserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
