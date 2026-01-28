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

class SwipeCardScreen extends StatelessWidget {
  const SwipeCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SwipeController controller = Get.put(SwipeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHomeAppBarStatic(title: "",showGridToggle: true,
        isGridView: controller.isGridView,
        onGridToggle: () => controller.isGridView.toggle(),),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        bool allSwiped = !controller.isGridView.value &&
            controller.commonIndex.value >= controller.profiles.length;

        if(controller.profiles.isEmpty || allSwiped){
          return Center(child: regularText(
            "No Users found"
          ),);
        }

        return controller.isGridView.value
            ? userGridLayout(controller)
            : _buildSwipeLayout(controller);
      }),
    );
  }


  Widget _buildSwipeLayout(SwipeController controller){
    return Stack(
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
                backCardOffset: const Offset(0, -30),
                padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 10 // Space for buttons to overlap
                ),
                cardBuilder: (context, index, h, v) {
                  return _buildProfileCard(controller.profiles[index]);
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
    );
  }
  Widget _buildProfileCard(UserData profile) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.ewProfileDetail,arguments: {'id': profile.id, "isMy":false})?.then((value) {
         // controller.refreshHome();
        });
      },
      child:Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: NetworkImage(profile.profile!),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Distance Badge
          Positioned(
            top: 20, left: 20,
            child: _badge("${profile.distnace!.toStringAsFixed(1)} km", Icons.location_on_outlined),
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
  }

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
      itemCount: controller.profiles.length,
      itemBuilder: (context, index) {
        return _userCard(controller,controller.profiles[index],index);
      },
    );
  }


  Widget _userCard(SwipeController controller,UserData user,int index) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.ewProfileDetail,arguments: {'id': user.id,"isMy":false})?.then((value) {
          // controller.refreshHome();
        });
      },
      child:
      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(user.profile!),
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
                          controller.cancel(index);
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
                          controller.connect(index);
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
  }
}