import 'package:Out2Do/controller/firebase_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/chat_messages_controller.dart';
import '../../../../models/chat_messages.dart';
import '../../../../models/messages_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_styles.dart';


class ChatMessagesScreen extends StatelessWidget {
  ChatMessagesScreen({super.key});

  final ChatMessagesController controller = Get.put(ChatMessagesController());
  final FirebaseStatusController statusController = Get.put(FirebaseStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: MyColors.baseColor),
          onPressed: () => Get.back(),
        ),
        title:InkWell(
          onTap: (){
            Get.toNamed(AppRoutes.userProfileDetail,/*arguments: {'id': 3}*/)?.then((value) {
              // controller.refreshHome();
            });
          },
          child:  Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage:  (controller.receiver.value?.additionalImagesThumb!.first ?? "").isNotEmpty
                    ? NetworkImage(
                    controller.receiver.value?.additionalImagesThumb!.first ?? "")
                    : const AssetImage("assets/app_icon/app_logo.png"),
              ),
              const SizedBox(width: 10),
              semiboldText(
                controller.receiver.value!.firstName??"",
              ),
            ],
          ) ,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: MyColors.black),
            onSelected: (value) {
              if (value == 'block') {
                controller.blockUser();
              } else if (value == 'report') {

              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (BuildContext context) => [
              // 🚫 Block Option
              const PopupMenuItem<String>(
                value: 'block',
                child: Row(
                  children: [
                    Icon(Icons.block, color: MyColors.black, size: 20),
                    SizedBox(width: 10),
                    Text("Block User", style: TextStyle(
                      fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "medium",
                        color: MyColors.black)),
                  ],
                ),
              ),
              // 🚩 Report Option
              const PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report_gmailerrorred, color: MyColors.black, size: 20),
                    SizedBox(width: 10),
                    Text("Report User",style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        fontFamily: "medium",
                        color: MyColors.black)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      /// BODY
      body: Column(
        children: [
          /// MESSAGE LIST
          Expanded(
            child: Obx(() => ListView.builder(
              reverse: true,
              controller: controller.scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: controller.messagesList.length,
              itemBuilder: (_, index) {
                final msg = controller.messagesList[index];
                return Column(
                  children: [
                  //  if (index == 0) _dateDivider("Today"),
                    _chatBubble(msg),
                  ],
                );
              },
            )),
          ),

          Obx(() => controller.isBlocked.value
              ? const SizedBox.shrink() // Agar block hai taan khali jagah (kujh nahi dikhega)
              : _inputBar()             // Agar block nahi hai taan bar dikhega
          ),
        ],
      ),
    );
  }

  /// DATE DIVIDER
  Widget _dateDivider(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: MyColors.grey,
                fontWeight: FontWeight.w400,
                fontFamily: "regular"
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  /// CHAT BUBBLE
  Widget _chatBubble(MessagesModel msg) {
    bool isMe = msg.sender == controller.sender.value?.id;
    return Align(
      alignment:isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: !isMe?BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.baseColor
            ):null,
            margin: const EdgeInsets.symmetric(vertical: 4),
            constraints: const BoxConstraints(maxWidth: 280),
            padding: isMe?EdgeInsets.zero:EdgeInsets.symmetric(horizontal: 7,vertical: 7),
            child:isMe?
            regularText(
              msg.message!,
            ):whiteRegularText(msg.message!),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: lightText(
            //  msg.time
              getFormattedMessageTime(timestamp: msg.timestamp ?? 0),
            ),
          ),
        ],
      ),
    );
  }

  /// INPUT BAR
  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
         /* IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {},
          ),*/

          Expanded(
            child: TextField(
              controller: controller.textController,
              style: TextStyle(
                fontFamily: "regular",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: MyColors.black
              ),
              decoration: InputDecoration(
                hintText: "Message...",
                filled: true,
                fillColor: MyColors.greyFilled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: MyColors.baseColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: MyColors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
