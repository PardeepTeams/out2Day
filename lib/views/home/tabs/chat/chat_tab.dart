import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_home_app_bar.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/chat_controller.dart';
import '../../../../models/chat_user.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_styles.dart';

class ChatTab extends StatelessWidget {
  ChatTab({super.key});

  final ChatController controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonHomeAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: mediumTextLarge(
              AppStrings.recentMatch,
              MyColors.baseColor
            ),
          ),

          const SizedBox(height: 6),
          SizedBox(
            height: 60,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentMatches.length,
              itemBuilder: (context, index) {
                return _recentMatchItem(controller.recentMatches[index]);
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: mediumTextLarge(
                AppStrings.messages,
                MyColors.baseColor
            ),
          ),
          const SizedBox(height: 6),
          Expanded(child: Obx(() {
            if (controller.chats.isEmpty) {
              return Center(child: regularText(AppStrings.noChats));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              itemCount: controller.chats.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (_, index) {
                final chat = controller.chats[index];

                return InkWell(
                  onTap: () => controller.openChat(index),
                  borderRadius: BorderRadius.circular(16),
                  child: _messageTile(chat)
                );
              },
            );
          }))
        ],
      )
      ,
    );
  }

/*  Widget _recentMatchItem(UserData data) {
    return InkWell(
      onTap: (){
        controller.openRecentChat(data);
      },
      child:Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: data.profile??"",
                fit: BoxFit.cover,
                width: 64,
                height: 64,

                // 🔹 Animation settings: Slow karan layi (1.5 seconds)
                fadeInDuration: const Duration(milliseconds: 1500),
                fadeOutDuration: const Duration(milliseconds: 1500),
                fadeInCurve: Curves.easeIn, // Smooth shuruat layi

                // 🔹 Loading Spinner
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),

                // 🔹 Error icon je image load na hove
                errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey
                ),
              ),
            ),
          )
      *//*    if (data['online'])
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),*//*
        ],
      ),
    ));
  }*/


  Widget _recentMatchItem(Map<String,Object> data) {
    return InkWell(
        onTap: (){
        //  controller.openRecentChat(data);
        },
        child:Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: data["image"].toString()??"",
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,

                    // 🔹 Animation settings: Slow karan layi (1.5 seconds)
                    fadeInDuration: const Duration(milliseconds: 1500),
                    fadeOutDuration: const Duration(milliseconds: 1500),
                    fadeInCurve: Curves.easeIn, // Smooth shuruat layi

                    // 🔹 Loading Spinner
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),

                    // 🔹 Error icon je image load na hove
                    errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey
                    ),
                  ),
                ),
              )
              /*    if (data['online'])
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),*/
            ],
          ),
        ));
  }

  Widget _messageTile(ChatUser data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: data.image,
                    fit: BoxFit.cover,
                    width: 64,
                    height: 64,

                    // 🔹 Animation settings: Slow karan layi (1.5 seconds)
                    fadeInDuration: const Duration(milliseconds: 1500),
                    fadeOutDuration: const Duration(milliseconds: 1500),
                    fadeInCurve: Curves.easeIn, // Smooth shuruat layi

                    // 🔹 Loading Spinner
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),

                    // 🔹 Error icon je image load na hove
                    errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey
                    ),
                  ),
                ),
              )
            /*  if (data['online'])
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),*/
            ],
          ),

          const SizedBox(width: 12),

          /// NAME & MESSAGE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mediumTextLarge(
                  data.name,
                  MyColors.baseColor
                ),
                const SizedBox(height: 4),
                regularText2(
                  data.lastMessage,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// TIME & UNREAD
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              lightText(
                data.time,
              ),
              const SizedBox(height: 6),
              if (data.unreadCount> 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: whiteRegularText2(
                    data.unreadCount.toString(),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
