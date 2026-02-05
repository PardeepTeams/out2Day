import 'dart:ui';
import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/routes/app_routes.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:Out2Do/utils/common_styles.dart';
import 'package:Out2Do/widgets/common_app_bar_static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../controller/swipe_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'connect/widgets/swipe_card.dart';
import 'home_tab/widgets/profile_list_card.dart';

class SwipeCardScreen extends StatelessWidget {
  const SwipeCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SwipeController controller = Get.put(SwipeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHomeAppBarStatic(title: "",showGridToggle: true,
        isGridView: controller.isGridView,
        onGridToggle: (){
       /* controller.profiles.clear();
        controller.profiles.assignAll(controller.gridProfiles);
        controller.profiles.refresh();*/
          controller.toggleView();
        },),
      body: Obx(() {
        if (controller.isLoading.value || controller.isSwitching.value) {
          return const Center(child: CircularProgressIndicator(
            color: MyColors.baseColor,
          ));
        }
        bool allSwiped = !controller.isGridView.value &&
            controller.commonIndex.value >= controller.profiles.length;

        if(controller.profiles.isEmpty || allSwiped){
          return Center(child: regularText(
            "No Users found"
          ),);
        }
        if(controller.isGridView.value){
          if(controller.gridProfiles.isEmpty){
            return Center(child: regularText(
                "No Users found"
            ),);
          }
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: controller.isGridView.value
              ? userGridLayout(controller)
              : _buildSwipeLayout(controller),
        );

      }),
    );
  }


  Widget _buildSwipeLayout(SwipeController controller){
    int currentIndex = controller.commonIndex.value;
    int totalProfiles = controller.profiles.length;

    // Kitne cards stack mein ek saath dikhane hain (e.g., 5 cards)
    int displayLimit = 1;
    int endIndex = (currentIndex + displayLimit) < totalProfiles
        ? currentIndex + displayLimit
        : totalProfiles;

    // Sirf zaroori profiles ki sublist nikaalein
    List<UserData> visibleProfiles = controller.profiles.sublist(currentIndex, endIndex);
    return  Align(
        alignment: Alignment.topCenter,
       child: Padding(padding: EdgeInsets.only(top: 20),
       child:
       Stack(
          alignment: Alignment.center,
          children: visibleProfiles
              .map((profile) => SwipeCard(
            profile: profile,
            controller: controller,
          ))
              .toList(),
        ))
    );
  /*  return Stack(
      children: [
        // 1. Swipeable Cards (Slightly more bottom padding for the buttons)
        Column(
          children: [
            Expanded(
              child: CardSwiper(
                controller: controller.swiperController,
                cardsCount: controller.profiles.length,
                onSwipe: controller.onSwipe,
                isLoop: false,
                numberOfCardsDisplayed: controller.profiles.length > 3 ? 3 : controller.profiles.length,
                backCardOffset: const Offset(0, 0),
                padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 10 // Space for buttons to overlap
                ),
                cardBuilder: (context, index, h, v) {
                  return _buildProfileCard(controller,controller.profiles[index]);
                },
              ),
            ),
            // Bottom empty space for navigation bar if needed
            const SizedBox(height: 60),
          ],
        ),

        // 2. Overlapping Action Buttons (Half on card, half below)
        Positioned(
          bottom: 5, // Adjust this value to control the "half-half" look
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _circularButton(
                  "assets/dislike.png",
                  Colors.black,
                      () => controller.swiperController.swipe(CardSwiperDirection.left)
              ),
              // const SizedBox(width: 25),
              _circularButton(
                  "assets/like.png",
                  Colors.black,
                      () => controller.swiperController.swipe(CardSwiperDirection.right)
              ),
            ],
          ),
        ),
      ],
    );*/
  }

  Widget _buildProfileCard(SwipeController controller, UserData profile) {
    // Safe Image URLs
    String mainImage =  (profile.additionalImages?.isNotEmpty == true ? profile.additionalImages![0] : "");
    // Yahan thumbnail ka URL pass karein jo backend se aa raha hai
    String thumbImage = profile.additionalImagesThumb![0] ?? "";

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.ewProfileDetail, arguments: {'id': profile.id, "isMy": false,"fromChat":false})?.then((value) {
          controller.fetchProfiles();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect( // 👈 Zaroori hai taaki image corners round rahein
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              // --- 🟢 BACKGROUND IMAGE WITH CACHE & THUMBNAIL ---
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: mainImage,
                  fit: BoxFit.cover,
                  // Jab tak high-res load na ho, backend wala thumbnail dikhao
                  placeholder: (context, url) => Image.network(
                    thumbImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.white),
                  ),
                ),
              ),

              // --- 🔵 DISTANCE BADGE ---
              Positioned(
                top: 20,
                left: 20,
                child: _badge("${profile.distnace!} mi", Icons.location_on_outlined),
              ),

              // --- ⚪ NAME & INFO (Glassmorphism) ---
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          semiboldTextWhite("${profile.firstName!}, ${calculateAge(profile.dob!).toString()}"),
                          whiteRegularText(profile.profession ?? ""),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
/*  Widget _buildProfileCard(SwipeController controller,UserData profile) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.ewProfileDetail,arguments: {'id': profile.id, "isMy":false})?.then((value) {
          controller.fetchProfiles();
        });
      },
      child:Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(profile.profile?? profile.additionalImages![0]),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Distance Badge
          Positioned(
            top: 20, left: 20,
            child: _badge("${profile.distnace!} km", Icons.location_on_outlined),
          ),

          // Name & Info (Glassmorphism)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), // Padding adjusted for buttons
              child: ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(25), bottomRight: Radius.circular(25)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20), bottomRight: Radius.circular(20)),
                      border: Border.all(color: MyColors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        semiboldTextWhite("${profile.firstName!} , ${calculateAge(profile.dob!).toString()}"),
                        whiteRegularText(profile.profession!,),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }*/

  Widget _circularButton(String icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 95,
        width: 95,
        child: Image.asset(icon),
      ),
    );
  }

  Widget _badge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: MyColors.black3),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700,
              color: MyColors.black2,
              fontFamily: "sembold",
              fontSize: 12)),
        ],
      ),
    );
  }

  Widget userGridLayout(SwipeController controller) {

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,           // 2 columns
        childAspectRatio: 0.75,      // Card di height adjust karan layi
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.gridProfiles.length,
      itemBuilder: (context, index) {
        return _userCard(controller,controller.gridProfiles[index],index);
      },
    );
  }


  Widget _userCard(SwipeController controller, UserData user, int index) {
    // Thumbnail aur Original URL nikaal rahe hain
    String originalImage = (user.additionalImages?.isNotEmpty == true ? user.additionalImages![0] : "");
    // Maan lijiye aapke model mein 'thumbnail' field hai, agar nahi hai toh main image hi placeholder rahegi
    String thumbnailImage = user.additionalImagesThumb![0] ?? "";

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.ewProfileDetail, arguments: {'id': user.id, "isMy": false,"fromChat":false})?.then((value) {
          controller.fetchProfiles();
        });
      },
      child: ClipRRect( // Taaki image corners round rahein
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              // --- 🟢 BACKGROUND IMAGE WITH THUMBNAIL ---
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: originalImage,
                  fit: BoxFit.cover,
                  // Jab tak original load ho, thumbnail network se dikhao
                  placeholder: (context, url) => Image.network(
                    thumbnailImage,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),



              Positioned(
                top: 15,
                left: 15,
                child: _badge("${user.distnace ?? "0"} Miles", Icons.location_on),
              ),



              // --- 🔵 OVERLAY CONTENT (Text + Buttons) ---
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // 1. Name aur Age
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                      ),
                    ),
                    child: Text(
                      "${user.firstName}, ${calculateAge(user.dob!).toString()}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // 2. Action Buttons (Blur Effect)
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 50,
                        color: Colors.white.withOpacity(0.2),
                        child: Row(
                          children: [
                            Expanded(
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => controller.cancelFromGrid(user),
                              ),
                            ),
                            Container(width: 1, height: 25, color: Colors.white30),
                            Expanded(
                              child: IconButton(
                                icon: const Icon(Icons.thumb_up, color: Colors.white),
                                onPressed: () => controller.connectFromGrid(user),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
/*  Widget _userCard(SwipeController controller,UserData user,int index) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.ewProfileDetail,arguments: {'id': user.id,"isMy":false})?.then((value) {
           controller.fetchProfiles();
        });
      },
      child:
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(user.profile??user.additionalImages![0]),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 1. Name aur Age (Gradient backdrop de naal)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
            child: Text(
              "${user.firstName} , ${calculateAge(user.dob!).toString()}",
              style: const TextStyle(
                color: MyColors.white,
                fontFamily: "semibold",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          // 2. Action Buttons (Blur Effect)
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glassmorphism effect
              child: Container(
                height: 50,
                color: Colors.white.withOpacity(0.2), // Light transparent color
                child: Row(
                  children: [
                    // Dislike Button
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          controller.cancelFromGrid(user);
                        },
                      ),
                    ),
                    // Vertical Divider
                    Container(width: 1, height: 25, color: Colors.white30),
                    // Like Button
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.thumb_up, color: Colors.white),
                        onPressed: () {
                          controller.connectFromGrid(user);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }*/
}