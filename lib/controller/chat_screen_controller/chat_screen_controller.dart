// ignore_for_file: unused_field, unused_element

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/core/constant/component.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:project/core/constant/statusrequest.dart';
import 'package:project/core/func/internet/handel_data.dart';
import 'package:project/core/routes/router.dart';
import 'package:project/core/server/my_server.dart';
import 'package:project/data/data_sorcue/chat_screen_datasource/cha_screen_datasource.dart';
import 'package:project/data/data_sorcue/constant_datasource.dart';
import 'package:project/data/data_sorcue/message_screen_datasource/message_screen_datasource.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/data/models/user_block_list_model/user_bloc_list_model.dart';
import 'package:project/data/models/users/register_model.dart';
import 'package:project/view/screen/image_view_page_screen/image_view_page_screen.dart';
import 'package:project/view/widget/chat_list_bottomnavbar_widget/compent/image_video_msg_sheet.dart';
import 'package:project/view/widget/chat_list_bottomnavbar_widget/compent/item_selection_dialog_android.dart';
import 'package:project/view/widget/chat_list_bottomnavbar_widget/compent/item_selection_dialog_ios.dart';
import 'package:project/view/widget/chat_screen_widget/unblock_user_dialog_widget.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

abstract class ChatScreenControlle extends GetxController {
  void goBack();
  void onUserTap();
  void onLongPress(ChatMessage? data);
  void onDeleteBtnClick();
  void unblockDialog();
  void onImageTap(ChatMessage? imageData);
  void sendMessage();
  void onSendBtnTap();
  void onMessageSent();
  Future<void> onMoreBtnTap(String value);
  void onPlusTap();
  void onSendBtnClick(String msg, String? image);
  void getChatMsgDialog({required Function(bool isSelected) onContinueTap});
}

class ChatScreenControlleIMP extends ChatScreenControlle {
  var db = FirebaseFirestore.instance;
  late DocumentReference documentSender;
  late DocumentReference documentReceiver;
  late CollectionReference drChatMessages;
  StatusRequest? statusRequest;
  final ImagePicker picker = ImagePicker();
  final _transformationController = TransformationController();

  static bool isScreen = false;
  late TextEditingController messageTextEditingController;
  FocusNode messageFoucs = FocusNode();
  TapDownDetails _doubleTapDetails = TapDownDetails();
  ScrollController scrollController = ScrollController();
  File? chatImage;
  File? cameraImage;
  MyServices myServices = Get.find();
  ChatDataSource chatDataSource = ChatDataSource(Get.find());
  XFile? _pickedFile;
  String? imagePath = '';
  String selectedItem = 'IMAGE';
  String blockUnblock = 'Block';
  List<ChatMessage> chatData = [];
  String deletedId = '';
  StreamSubscription<QuerySnapshot<ChatMessage>>? chatStream;
  StreamSubscription<DocumentSnapshot<Conversation>>? conUserStream;

  Conversation? conversation;
  ChatUser? receiverUser;
  RegistrationUserData? registrationUserData;
  RegistrationUserData? conversationUserData;
  Map<String, List<ChatMessage>>? grouped;
  int startingNumber = 30;
  UserBlockList? _userBlockList;
  List<String> notDeletedIdentity = [];
  List<String> timeStamp = [];
  bool isLongPress = false;
  int? walletCoin = 0;
  bool isSelected = false;
  bool isBlock = false;
  bool isBlockOther = false;
  MessageDataSource messageDataSource = MessageDataSource(Get.find());
  ConstantDataSource constantDataSource = ConstantDataSource(Get.find());

  @override
  void onInit() {
    messageTextEditingController = TextEditingController();
    isScreen = true;
    conversation = Get.arguments;
    getValueFromPrefs();
    scrollToGetChat();
    super.onInit();
  }

  @override
  void dispose() {
    messageTextEditingController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    messageTextEditingController.dispose();
    super.onClose();
  }

  Future<void> getValueFromPrefs() async {
    constantDataSource.getUserData().then((value) {
      registrationUserData = value;
      blockUnblock = conversation?.block == true ? 'UnBlock' : 'Block';
      isBlock = conversation?.block == true ? true : false;
      isBlockOther = conversation?.blockFromOther == true ? true : false;
      getProfileAPi();
      initFireBaseData();
    });
    statusRequest = StatusRequest.loading;
    var response =
        await constantDataSource.getProfile(userID: conversation?.user?.userid);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      conversationUserData = RegistrationUserData.fromJson(response['data']);
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  Future<void> getProfileAPi() async {
    statusRequest = StatusRequest.loading;
    var response = await constantDataSource.getProfile(userID: user__ID);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      statusRequest = StatusRequest.success;
      update();
      registrationUserData = RegistrationUserData.fromJson(response['data']);
      walletCoin = registrationUserData?.wallet;
      isSelected =
          await messageDataSource.getDialog("isMessageDialog") ?? false;
      blockUnblock = registrationUserData?.blockedUsers
                  ?.contains('${conversation?.user?.userid}') ==
              true
          ? 'Unblock'
          : 'Block';
      await constantDataSource.saveUser(registrationUserData);
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  /// initialise firebase value
  void initFireBaseData() {
    documentReceiver = db
        .collection('userchatlist')
        .doc(conversation?.user?.userIdentity)
        .collection('userlist')
        .doc(registrationUserData?.identity);
    documentSender = db
        .collection('userchatlist')
        .doc(registrationUserData?.identity)
        .collection('userlist')
        .doc(conversation?.user?.userIdentity);

    documentSender
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then(
      (value) async {
        if (value.data() != null && value.data()?.conversationId != null) {
          conversation?.setConversationId(value.data()?.conversationId);
        }
        drChatMessages = db
            .collection('chat')
            .doc(conversation?.conversationId)
            .collection('chat');
        getChat();
      },
    );
  }

  void scrollToGetChat() {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        getChat();
      }
    });
  }

  @override
  void goBack() {
    Get.back();
  }

  @override
  void onUserTap() {
    Get.toNamed(AppRoutes.userDetailsScreen,
        arguments: conversation?.user?.userid);
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
    }
  }

  void onCancelBtnClick() {
    timeStamp = [];
    update();
  }

  // chat item delete method
  void chatDeleteDialog() {
    Get.dialog(
      ConfirmationDialog(
        aspectRatio: 1 / 0.7,
        clickText1: 'Delete',
        clickText2: 'cancel',
        heading: '"Delete message"',
        subDescription: '"Are you sure you want to delete this message ?"',
        onNoBtnClick: goBack,
        onYesBtnClick: onDeleteBtnClick,
        horizontalPadding: 65,
      ),
    );
  }

  @override
  void onDeleteBtnClick() {
    for (int i = 0; i < timeStamp.length; i++) {
      drChatMessages.doc(timeStamp[i]).update(
        {
          'not_deleted_identities': FieldValue.arrayRemove(
            ['${registrationUserData?.identity}'],
          )
        },
      );
      chatData.removeWhere(
        (element) => element.time.toString() == timeStamp[i],
      );
    }
    timeStamp = [];
    Get.back();
    update();
  }

  /// long press to select chat method
  @override
  void onLongPress(ChatMessage? data) {
    if (!timeStamp.contains('${data?.time?.round()}')) {
      timeStamp.add('${data?.time?.round()}');
    } else {
      timeStamp.remove('${data?.time?.round()}');
    }
    isLongPress = true;
    update();
  }

  @override
  void unblockDialog() {
    Get.dialog(UnblockUserDialog(
      onCancelBtnClick: goBack,
      unblockUser: unBlockUser,
      name: conversation?.user?.username,
    ));
  }

  Future<void> blockUser() async {
    statusRequest = StatusRequest.loading;
    var response =
        await messageDataSource.userBlockList(conversation?.user?.userid);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      _userBlockList = UserBlockList.fromJson(response);
      await messageDataSource.saveUser(_userBlockList!.data);
      await db
          .collection('userchatlist')
          .doc(registrationUserData?.identity)
          .collection('userlist')
          .doc(conversation?.user?.userIdentity)
          .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              })
          .update({
        'block': true,
      });
      await db
          .collection('userchatlist')
          .doc(conversation?.user?.userIdentity)
          .collection('userlist')
          .doc(registrationUserData?.identity)
          .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              })
          .update({
        'blockFromOther': true,
      });
      blockUnblock = 'unBlock';
      isBlock = true;
      isBlockOther = true;
      update();
      statusRequest = StatusRequest.success;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  Future<void> unBlockUser() async {
    statusRequest = StatusRequest.loading;
    var response =
        await messageDataSource.userBlockList(conversation?.user?.userid);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      _userBlockList = UserBlockList.fromJson(response);
      await messageDataSource.saveUser(_userBlockList!.data);
      await db
          .collection('userchatlist')
          .doc(registrationUserData?.identity)
          .collection('userlist')
          .doc(conversation?.user?.userIdentity)
          .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              })
          .update({
        'block': false,
      });
      await db
          .collection('userchatlist')
          .doc(conversation?.user?.userIdentity)
          .collection('userlist')
          .doc(registrationUserData?.identity)
          .withConverter(
              fromFirestore: Conversation.fromFirestore,
              toFirestore: (Conversation value, options) {
                return value.toFirestore();
              })
          .update({
        'blockFromOther': false,
      });
      blockUnblock = 'block';
      isBlock = false;
      isBlockOther = false;
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onImageTap(ChatMessage? imageData) {
    Get.to(
      () => ImageViewPage(
        userData: imageData,
        onBack: goBack,
        transformationController: _transformationController,
        handleDoubleTap: _handleDoubleTap,
        handleDoubleTapDown: _handleDoubleTapDown,
      ),
    )?.then((value) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // Status bar color
        //statusBarColor: ColorRes.transparent,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ));
      _transformationController.value = Matrix4.identity();
    });
  }

  @override
  void sendMessage() {
    firebaseMsgUpdate(
            msgType: 'msg',
            textMessage: messageTextEditingController.text.trim())
        .then((value) {
      messageTextEditingController.clear();
    });
  }

  @override
  void onSendBtnTap() {
    if (conversation?.blockFromOther == true) {
      Get.snackbar("ERROR !!", 'This User Block You',
          snackPosition: SnackPosition.BOTTOM);
      messageTextEditingController.clear();
      return;
    }
    if (registrationUserData?.isFake != 1) {
      if (messageTextEditingController.text.trim() != '') {
        if (reverseSwipePrice <= walletCoin! && walletCoin != 0) {
          !isSelected
              ? getChatMsgDialog(onContinueTap: onTextMsgContinueClick)
              : onMessageSent();
        } else {
          emptyDialog();
        }
      }
    } else {
      firebaseMsgUpdate(
              msgType: 'msg',
              textMessage: messageTextEditingController.text.trim())
          .then((value) {
        messageTextEditingController.clear();
      });
    }
  }

  Future<void> minusCoinApi() async {
    await chatDataSource.minusCoinFromWallet(messagePrice);
  }

  void onTextMsgContinueClick(bool isSelected) {
    myServices.sharedPreferences.setBool('isMessageDialog', isSelected);
    minusCoinApi().then(
      (value) {
        goBack();
        firebaseMsgUpdate(
          msgType: 'msg',
          textMessage: messageTextEditingController.text.trim(),
        );
        messageTextEditingController.clear();
      },
    );
  }

  @override
  void onMessageSent() {
    String text = messageTextEditingController.text;
    messageTextEditingController.clear();
    minusCoinApi().then(
      (value) async {
        getProfileAPi();
        firebaseMsgUpdate(msgType: 'msg', textMessage: text.trim());
      },
    );
  }

  @override
  void onPlusTap() {
    minusCoinApi().then(
      (value) {
        getProfileAPi();
        onAddBtnTap();
      },
    );
  }

  /// send a image method
  @override
  void onSendBtnClick(String msg, String? image) {
    firebaseMsgUpdate(image: image, msgType: 'image', textMessage: msg);
    Get.back();
  }

  void plusBotn() {
    onAddBtnTap();
  }

  void onPlusBtnClick() {
    if (registrationUserData?.isFake != 1) {
      if (reverseSwipePrice <= walletCoin! && walletCoin != 0) {
        !isSelected
            ? getChatMsgDialog(onContinueTap: onPlusContinueClick)
            : onPlusTap();
      } else {
        emptyDialog();
      }
    } else {
      onAddBtnTap();
    }
  }

  void onPlusContinueClick(bool isSelected) {
    myServices.sharedPreferences.setBool('isMessageDialog', isSelected);
    minusCoinApi().then(
      (value) {
        goBack();
        onAddBtnTap();
      },
    );
  }

  // Add btn to choose photo or video method
  void onAddBtnTap() {
    messageFoucs.unfocus();
    if (conversation?.blockFromOther == true) {
      Get.snackbar("ERROR !!", 'This User Block You',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Platform.isIOS
        ? Get.bottomSheet(
            ItemSelectionDialogIos(
              onCloseBtnClickIos: goBack,
              onImageBtnClickIos: () {
                itemSelectImage();
              },
              onVideoBtnClickIos: itemSelectVideo,
            ),
          )
        : showModalBottomSheet(
            context: Get.context!,
            //backgroundColor: ColorRes.transparent,
            builder: (BuildContext context) {
              return ItemSelectionDialogAndroid(
                onCloseBtnClick: goBack,
                onImageBtnClick: itemSelectImage,
                onVideoBtnClick: itemSelectVideo,
              );
            },
          );
  }

  /// selected video or image method
  void itemSelectImage() async {
    selectedItem = 'Image';
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (photo == null || photo.path.isEmpty) return;
    cameraImage = File(photo.path);
    chatDataSource.getStoreFileGivePath(image: cameraImage).then(
      (value) {
        if (value.status == true) {
          Get.back();
          Get.bottomSheet(
              ImageVideoMsgSheet(
                  image: value.path,
                  onSendBtnClick: onSendBtnClick,
                  selectedItem: selectedItem),
              isScrollControlled: true);
        }
        update();
      },
    );
  }

  void itemSelectVideo() async {
    selectedItem = 'VIDEO';
    _pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60),
    );

    if (_pickedFile == null || _pickedFile!.path.isEmpty) return;

    /// calculating file size
    final videoFile = File(_pickedFile?.path ?? '');
    int sizeInBytes = videoFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);

    if (sizeInMb <= 15) {
      VideoThumbnail.thumbnailFile(
        video: _pickedFile!.path,
      ).then(
        (value) {
          Get.back();
          Get.bottomSheet(
            ImageVideoMsgSheet(
              image: value,
              selectedItem: selectedItem,
              onSendBtnClick: (msg, image) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return Lottie.asset(AppPhotoLink.loading);
                  },
                );
                chatDataSource
                    .getStoreFileGivePath(
                  image: File(image ?? ''),
                )
                    .then(
                  (value) {
                    imagePath = value.path;
                    chatDataSource.getStoreFileGivePath(image: videoFile).then(
                      (value) {
                        firebaseMsgUpdate(
                            video: value.path,
                            msgType: 'video',
                            textMessage: msg,
                            image: imagePath);
                        Get.back();
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
            isScrollControlled: true,
          );
        },
      );
    } else {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return VideoUploadDialog(
            cancelBtnTap: goBack,
            selectAnother: () {
              Get.back();
              itemSelectVideo();
            },
          );
        },
      );
    }
  }

  ///  video preview screen navigate
  void onVideoItemClick(ChatMessage? data) {
    Get.toNamed(AppRoutes.vedioPerivewScreen, arguments: data?.video)
        ?.then((value) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          // statusBarColor: Theme.of(context),
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      );
    });
  }

  void prefCameraTap() {
    minusCoinApi().then(
      (value) {
        getProfileAPi();
        onCameraTap();
      },
    );
  }

  void onCamera() {
    onCameraTap();
  }

  void onCameraContinueClick(bool isSelected) {
    myServices.sharedPreferences.setBool('isMessageDialog', isSelected);
    minusCoinApi().then(
      (value) {
        goBack();
        onCameraTap();
      },
    );
  }

  /// camera button tap
  Future<void> onCameraTap() async {
    if (conversation?.blockFromOther == true) {
      Get.snackbar("ERROR!!", 'This User Block You',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);

      if (photo == null || photo.path.isEmpty) return;
      chatImage = File(photo.path);
      chatDataSource.getStoreFileGivePath(image: chatImage).then(
        (value) {
          if (value.status == true) {
            firebaseMsgUpdate(image: value.path, msgType: 'image');
          }
          update();
        },
      );
    } on PlatformException catch (e) {
      Get.snackbar("ERROR", '${e.message}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  ///User chat method
  void getChat() async {
    await documentReceiver
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then(
      (value) {
        receiverUser = value.data()?.user;
      },
    );

    await documentSender
        .withConverter(
          fromFirestore: Conversation.fromFirestore,
          toFirestore: (Conversation value, options) {
            return value.toFirestore();
          },
        )
        .get()
        .then((value) {
      deletedId = value.data()?.deletedId.toString() ?? '';
      update();
    });

    chatStream = drChatMessages
        .where('not_deleted_identities',
            arrayContains: registrationUserData?.identity)
        .where('time',
            isGreaterThan: deletedId.isEmpty ? 0.0 : double.parse(deletedId))
        .orderBy('time', descending: true)
        .limit(startingNumber)
        .withConverter(
          fromFirestore: ChatMessage.fromFirestore,
          toFirestore: (ChatMessage value, options) {
            return value.toFirestore();
          },
        )
        .snapshots()
        .listen(
      (element) async {
        chatData = [];
        for (int i = 0; i < element.docs.length; i++) {
          chatData.add(element.docs[i].data());
        }
        grouped = groupBy<ChatMessage, String>(
          chatData,
          (message) {
            final now = DateTime.now();
            DateTime time =
                DateTime.fromMillisecondsSinceEpoch(message.time!.toInt());
            if (DateFormat("dd MMM yyyy").format(DateTime.now()) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Today';
            }
            if (DateFormat("dd MMM yyyy")
                    .format(DateTime(now.year, now.month, now.day - 1)) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Yesterday';
            } else {
              return DateFormat("dd MMM yyyy").format(time);
            }
          },
        );
        startingNumber += 45;
        update();
      },
    );
  }

  ///Firebase message update method
  Future<void> firebaseMsgUpdate(
      {required String msgType,
      String? textMessage,
      String? image,
      String? video}) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    notDeletedIdentity = [];
    notDeletedIdentity.addAll(
      [
        '${registrationUserData?.identity}',
        '${conversation?.user?.userIdentity}'
      ],
    );

    drChatMessages
        .doc(
          time.toString(),
        )
        .set(
          ChatMessage(
            notDeletedIdentities: notDeletedIdentity,
            senderUser: ChatUser(
              username: registrationUserData?.fullname,
              date: time.toDouble(),
              isHost: false,
              isNewMsg: true,
              userid: registrationUserData?.id,
              userIdentity: registrationUserData?.identity,
              image: registrationUserData?.images?[0].image,
              city: registrationUserData?.live,
              age: registrationUserData?.age.toString(),
            ),
            msgType: msgType,
            msg: textMessage,
            image: image,
            video: video,
            id: conversation?.user?.userid?.toString(),
            time: time.toDouble(),
          ).toJson(),
        );

    if (chatData.isEmpty && deletedId.isEmpty) {
      Map con = conversation?.toJson() ?? {};
      con['lastMsg'] = msgType == 'image'
          ? '🖼️ ${'image'}'
          : msgType == 'video'
              ? '🎥 ${'video'}'
              : textMessage;
      documentSender.set(con);
      documentReceiver.set(
        Conversation(
          block: false,
          blockFromOther: false,
          conversationId: conversation?.conversationId,
          deletedId: '',
          isDeleted: false,
          isMute: false,
          lastMsg: msgType == 'image'
              ? '🖼️ ${'image'}'
              : msgType == 'video'
                  ? '🎥 ${'video'}'
                  : textMessage,
          newMsg: textMessage,
          time: DateTime.now().millisecondsSinceEpoch.toDouble(),
          user: ChatUser(
            username: registrationUserData?.fullname,
            date: DateTime.now().millisecondsSinceEpoch.toDouble(),
            isHost: registrationUserData?.isVerified == 2 ? true : false,
            isNewMsg: true,
            userid: registrationUserData?.id,
            userIdentity: registrationUserData?.identity,
            image: registrationUserData?.images?[0].image,
            city: registrationUserData?.live,
            age: registrationUserData?.age.toString(),
          ),
        ).toJson(),
      );
    } else {
      receiverUser?.isNewMsg = true;
      documentReceiver.update(
        {
          'isDeleted': false,
          'time': DateTime.now().millisecondsSinceEpoch.toDouble(),
          'lastMsg': msgType == 'image'
              ? '🖼️ ${'image'}'
              : msgType == 'video'
                  ? '🎥 ${'video'}'
                  : textMessage,
          'user': receiverUser?.toJson(),
        },
      );
      documentSender.update(
        {
          'isDeleted': false,
          'time': DateTime.now().millisecondsSinceEpoch.toDouble(),
          'lastMsg': msgType == 'image'
              ? '🖼️ ${'image'}'
              : msgType == 'video'
                  ? '🎥 ${'video'}'
                  : textMessage
        },
      );
    }

    conversationUserData?.isNotification == 1
        ? chatDataSource.pushNotification(
            authorization: AppLink.authKey,
            title: registrationUserData?.fullname ?? '',
            body: msgType == 'image'
                ? '🖼️ ${'image'}'
                : msgType == 'video'
                    ? '🎥 ${'video'}'
                    : '$textMessage',
            token: '${conversationUserData?.deviceToken}')
        : null;
  }

  void emptyDialog() {
    if (kDebugMode) {
      print('Empity');
    }
/*     Get.dialog(
      EmptyWalletDialog(
        onCancelTap: onBackBtnTap,
        onContinueTap: () {
          Get.back();
          Get.bottomSheet(
            const BottomDiamondShop(),
          );
        },
        walletCoin: walletCoin,
      ),
    ); */
  }

  @override
  void getChatMsgDialog({required Function(bool isSelected) onContinueTap}) {
    Get.dialog(
      ReverseSwipeDialog(
          onCancelTap: goBack,
          onContinueTap: onContinueTap,
          isCheckBoxVisible: true,
          walletCoin: walletCoin,
          title1: 'message'.toUpperCase(),
          title2: 'price'.toUpperCase(),
          dialogDisc:
              '"Message price will cost you $messagePrice coins per Msg, Please confirm if you to continue or not"',
          coinPrice: '$messagePrice'),
    ).then((value) {
      getProfileAPi();
    });
  }

  @override
  Future<void> onMoreBtnTap(String value) async {
    if (value == 'Block') {
      blockUser();
    }
    if (value == 'Unblock') {
      unBlockUser();
    }

    if (value == 'Report') {
      Get.toNamed(AppRoutes.reportUsersScreen, arguments: {
        'reportName': conversation?.user?.username,
        'reportImage': conversation?.user?.image,
        'reportAge': conversation?.user?.age,
        'reportAddress': conversation?.user?.city
      });
    }
  }
}
