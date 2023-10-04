// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project/controller/message_bottomnavbar_widget_controller/message_bottom_navbar_widget_conreoller.dart';
import 'package:project/core/constant/app_photo.dart';
import 'package:project/data/models/chat_and_live_model/chat.dart';
import 'package:project/view/widget/chat_list_bottomnavbar_widget/compent/chat_list_bottomnavbar_widget.dart';

class MessageBottomNavBarWidget extends StatelessWidget {
  const MessageBottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageBottomNavBarWidgetControllerIMP>(
      init: MessageBottomNavBarWidgetControllerIMP(),
      builder: (controller) => Column(
        children: [
          Expanded(
              child: controller.userList.isEmpty
                  ? Lottie.asset(AppPhotoLink.noData, fit: BoxFit.contain)
                  : ListView.separated(
                      separatorBuilder: (contex, index) => Divider(
                        color: Theme.of(context).primaryColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                      itemCount: controller.userList.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Conversation? conversation = controller.userList[index];
                        ChatUser? chatUser = conversation?.user;
                        return InkWell(
                          onTap: () {
                            controller.onUserTap(conversation);
                          },
                          onLongPress: () {
                            controller.onLongPress(conversation);
                          },
                          child: ChatListViewBottomNavBarWidget(
                            name: chatUser?.username ?? '',
                            age: chatUser?.age ?? '',
                            msg: conversation!.lastMsg!.isEmpty
                                ? ''
                                : conversation.lastMsg,
                            time: conversation.time.toString(),
                            image: chatUser?.image ?? '',
                            newMsg: chatUser?.isNewMsg ?? false,
                            tickMark: chatUser?.isHost,
                          ),
                        );
                      },
                    )),
        ],
      ),
    );
  }
}
