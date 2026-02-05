import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/connect_controller.dart';
import '../../../../../utils/colors.dart';
import 'package:audioplayers/audioplayers.dart'; // 👈 Add this
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import karein

/*
class MatchDialog extends StatelessWidget {
  final UserData profile;
  final VoidCallback onKeepSwiping; // 👈 New
  final VoidCallback onSendMessage; // 👈 New

  const MatchDialog({super.key, required this.profile,
    required this.onKeepSwiping,
    required this.onSendMessage});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            onKeepSwiping(); // Agar user back kare ya bahar click kare toh controller update ho
          }
        },
        child: Dialog(
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
                onSendMessage();
                // Navigate to Chat logic here
              }),

              const SizedBox(height: 12),

              _buildButton("Keep Swiping", MyColors.white, MyColors.baseColor, () {
                onKeepSwiping();
              }, isBorder: true),
            ],
          ),
        ),
      ),
    ));
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
                child: _avatarCircle(profile.profile??profile.additionalImages![0]),
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
                child: _avatarCircle(StorageProvider.getUserData()!.profile?? StorageProvider.getUserData()!.additionalImages![0]), // Dummy User Image
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
}*/

// ... existing imports

class MatchDialog extends StatefulWidget { // 👈 Changed to StatefulWidget for sound
  final UserData profile;
  final VoidCallback onKeepSwiping;
  final VoidCallback onSendMessage;

  const MatchDialog({super.key, required this.profile,
    required this.onKeepSwiping,
    required this.onSendMessage});

  @override
  State<MatchDialog> createState() => _MatchDialogState();
}

class _MatchDialogState extends State<MatchDialog> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playMatchSound(); // 👈 Play sound on open
  }

  void _playMatchSound() async {
    try {
      await _audioPlayer.play(AssetSource('match_sound.mp3'));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) widget.onKeepSwiping();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
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
                colors: [MyColors.white, MyColors.baseColor.withOpacity(0.65)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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

                /// 🧑‍🤝‍🧑 Profiles with Center Icon Adjusted
                _buildOverlappingImages(),

                const SizedBox(height: 30),
                Text(
                  "You and ${widget.profile.firstName ?? ""} liked each other!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: "regular",
                    color: MyColors.white,
                  ),
                ),
                const SizedBox(height: 40),
                _buildButton("Send a Message", MyColors.baseColor, MyColors.white, () {
                  widget.onSendMessage();
                }),
                const SizedBox(height: 12),
                _buildButton("Keep Swiping", MyColors.white, MyColors.baseColor, () {
                  widget.onKeepSwiping();
                }, isBorder: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverlappingImages() {
    return SizedBox(
      height: 130, // 👈 Increased height to accommodate icon below
      width: 220,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Match Profile (Right side)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 70.0, end: 25.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Positioned(
                right: value,
                child: _avatarCircle(widget.profile.profile ?? widget.profile.additionalImages![0]),
              );
            },
          ),
          // Your Profile (Left side)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 70.0, end: 25.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Positioned(
                left: value,
                child: _avatarCircle(StorageProvider.getUserData()!.profile ?? StorageProvider.getUserData()!.additionalImages![0]),
              );
            },
          ),

          /// 💖 Like Icon moved DOWN
          Positioned(
            bottom: 30, // 👈 Moves the icon to the bottom center of the images
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: const Icon(Icons.thumb_up, color: MyColors.baseColor, size: 24),
            ),
          ),
        ],
      ),
    );
  }
  Widget _avatarCircle(String url) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        // 🚀 Sabse important: Durations zero karni hain taaki loader na dikhe
        placeholderFadeInDuration: Duration.zero,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,

        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 48,
          backgroundImage: imageProvider,
        ),

        // Placeholder mein hum khali circle dikhayenge bina loader ke
        // (waise bhi image cache mein hogi toh ye dikhega hi nahi)
        placeholder: (context, url) => const CircleAvatar(
          radius: 48,
          backgroundColor: Colors.white,
        ),

        errorWidget: (context, url, error) => const CircleAvatar(
          radius: 48,
          backgroundImage: AssetImage("assets/app_icon/app_logo.png"),
        ),
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
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16, fontFamily: "regular", fontWeight: FontWeight.w600)),
      ),
    );
  }
}