import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/connect_controller.dart';
import '../../../../../utils/colors.dart';

class MatchDialog extends StatelessWidget {
  final UserData profile;

  const MatchDialog({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack, // Pop effect
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MyColors.white,
                MyColors.baseColor.withOpacity(0.65),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 💖 Animated Heart Icon (Scaling & Rotating)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                builder: (context, val, child) {
                  return Transform.scale(scale: val, child: child);
                },
                child: Image.asset("assets/like.png"),
              ),

             // const SizedBox(height: 20),

              const Text(
                "IT'S A MATCH!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: "semibold",
                  letterSpacing: 1.5,
                  color: MyColors.baseColor,
                ),
              ),

              const SizedBox(height: 30),

              /// 🧑‍🤝‍🧑 Overlapping Avatars Animation
              _buildOverlappingImages(),

              const SizedBox(height: 30),

              Text(
                "You and ${profile.firstName??""} liked each other!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "regular",
                  color: MyColors.white,
                ),
              ),

              const SizedBox(height: 40),

              /// 🚀 Action Buttons
              _buildButton("Send a Message", MyColors.baseColor, MyColors.white, () {
                Get.back();
                Get.toNamed(AppRoutes.chatMessages);
                // Navigate to Chat logic here
              }),

              const SizedBox(height: 12),

              _buildButton("Keep Swiping", MyColors.white, MyColors.baseColor, () {
                Get.back();
              }, isBorder: true),
            ],
          ),
        ),
      ),
    );
  }

  /// Overlapping Circle Avatars with Slide Animation
  Widget _buildOverlappingImages() {
    return SizedBox(
      height: 110,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Match Profile (Slides from Right)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 50.0, end: 35.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Positioned(
                right: value,
                child: _avatarCircle(profile.profile!),
              );
            },
          ),
          // Your Profile (Slides from Left - Static for now)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 50.0, end: 35.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Positioned(
                left: value,
                child: _avatarCircle("https://picsum.photos/200"), // Dummy User Image
              );
            },
          ),
          // Small Heart in Center
          const Center(
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Icon(Icons.thumb_up, color: MyColors.baseColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarCircle(String url) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: CircleAvatar(
        radius: 45,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildButton(String text, Color bg, Color textColor, VoidCallback onTap, {bool isBorder = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          side: isBorder ? const BorderSide(color: MyColors.baseColor) : null,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16,
              fontFamily: "regular",
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}