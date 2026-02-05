import 'dart:ui';
import 'package:Out2Do/models/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../api/storage_helper.dart';
import '../../../../../controller/swipe_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/common_styles.dart';
import 'match_dialog.dart';

class SwipeCard extends StatefulWidget {
  final UserData profile;
  final SwipeController controller;

  const SwipeCard({
    super.key,
    required this.profile,
    required this.controller,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  double dx = 0;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      onDragUpdate: (details) {
        setState(() => dx += details.delta.dx);
      },
      onDragEnd: (details) {
        if (dx > 120) {
           widget.controller.swipeRight(widget.profile);
        } else if (dx < -120) {
           widget.controller.swipeLeft(widget.profile);
        }
        setState(() => dx = 0);
      },
      feedback: Material(
        color: Colors.transparent,
        child: _card(rotation: dx / 300, isDragging: true),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: _card(),
    );
  }


  Widget _card({double rotation = 0, bool isDragging = false}) {
    // Buttons ka size aur overflow offset define karein
    const double buttonSize = 95.0;
    const double buttonOverflow = 45.0; // Jitna card se bahar dikhana hai

    return Transform.rotate(
      angle: rotation,
      child: SizedBox(
        // 🟢 SOLUTION: Height badha di taaki buttons "area" ke andar rahein
        height: (MediaQuery.of(context).size.height - 240) + buttonOverflow,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // 1. MAIN CARD (InkWell ke sath)
            InkWell(
              onTap: () {
               /* Get.dialog(
                  MatchDialog(profile: widget.profile, onKeepSwiping: () {
                    Get.back();
                  },
                    onSendMessage: ()async  {
                      Get.back();
                      await Future.delayed(const Duration(milliseconds: 100));
                      await Get.toNamed(
                          AppRoutes.chatMessages,
                          arguments: <String, dynamic>{
                            'sender': StorageProvider.getUserData()!.toJson(),
                            'receiver': widget.profile.toJson(),
                            "setDefault":true
                          }
                      );

                    },),
                  barrierDismissible: false,
                );*/
                Get.toNamed(AppRoutes.ewProfileDetail,
                    arguments: {'id': widget.profile.id, "isMy": false, "fromChat": false})
                    ?.then((value) {
                  widget.controller.fetchProfiles();
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height - 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Stack(
                    children: [
                      /// --- BACKGROUND IMAGE ---
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: widget.profile.additionalImages!.first,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                          errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                        ),
                      ),

                      /// --- DISTANCE BADGE ---
                      Positioned(
                        top: 15,
                        left: 15,
                        child: _badge("${widget.profile.distnace ?? "0"} Miles", Icons.location_on),
                      ),

                      /// --- GLASSMORPHISM TEXT OVERLAY ---
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
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  semiboldTextWhite("${widget.profile.firstName!}, ${calculateAge(widget.profile.dob!).toString()}"),
                                  whiteRegularText(widget.profile.profession ?? ""),
                                  const SizedBox(height: 10),
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
            ),

            /// --- 2. ACTION BUTTONS ---
            Positioned(
              // 🟢 SOLUTION: bottom: 0 rakhein taaki ye parent SizedBox ke boundary ke andar rahe
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circularButton(
                    "assets/dislike.png",
                    Colors.black,
                        () => widget.controller.cancelFromGrid(widget.profile),
                  ),
                  const SizedBox(width: 15), // Gap thoda adjust kiya
                  _circularButton(
                    "assets/like.png",
                    Colors.black,
                        () => widget.controller.connectFromGrid(widget.profile),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
/*  Widget _card({double rotation = 0, bool isDragging = false}) {
    return Transform.rotate(
      angle: rotation,
      child: InkWell(
        onTap: (){
          Get.toNamed(AppRoutes.ewProfileDetail, arguments: {'id': widget.profile.id, "isMy": false,"fromChat":false})?.then((value) {
            widget.controller.fetchProfiles();
          });
        },
        child:
      Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none, // Buttons ko card ke niche nikalne ke liye zaroori hai
        children: [
          Container(
            height: MediaQuery.of(context).size.height-300,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  /// --- BACKGROUND IMAGE ---
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: widget.profile.additionalImages!.first, // Original High-Res Image
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                   // 🟢 Smooth transition ke liye durations set karein
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 300),
                      // 🟢 Thumbnail placeholder: Jab tak original load ho rahi hai, ye dikhega
                      progressIndicatorBuilder: (context, url, downloadProgress) {
                        // Agar downloadProgress null hai (matlab cache se mil gayi), toh kuch mat dikhao
                        if (downloadProgress.progress == null) return const SizedBox();

                        // Agar download ho rahi hai (nhi hai cache mein), tab loader dikhao
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: MyColors.baseColor,
                          ),
                        );
                      },

                      // 🔴 Error handling: Agar original image na mile
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    )
                    *//*CachedNetworkImage(
                      imageUrl: widget.profile.additionalImagesThumb!.first,
                      fit: BoxFit.cover,
                    )*//*,
                  ),

                  /// --- DISTANCE BADGE ---
                  Positioned(
                    top: 15,
                    left: 15,
                    child: _badge("${widget.profile.distnace ?? "0"} Miles", Icons.location_on),
                  ),

                  /// --- GLASSMORPHISM TEXT OVERLAY ---
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
                              semiboldTextWhite("${widget.profile.firstName!}, ${calculateAge(widget.profile.dob!).toString()}"),
                              whiteRegularText(widget.profile.profession ?? ""),
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

          /// --- 2. ACTION BUTTONS (Overflowing Bottom) ---
          Positioned(
            bottom: -60, // Card ke niche half bahar nikalne ke liye
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circularButton(
                    "assets/dislike.png",
                    Colors.black,
                        () =>
                            widget.controller.cancelFromGrid(widget.profile)

                ),
                // const SizedBox(width: 25),
                _circularButton(
                    "assets/like.png",
                    Colors.black,
                        () =>  widget.controller.connectFromGrid(widget.profile)

                ),
              ],
            ),
          ),
        ],
      )),
    );
  }*/

  /// --- Helper for White Circular Buttons ---
/*  Widget _actionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85, // Image ke mutabiq bada size
        width: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 35),
      ),
    );
  }*/

  Widget _circularButton(String icon, Color color, VoidCallback onTap) {
    return Container(
        height: 95,
        width: 95,
        child: GestureDetector(
          onTap:onTap ,
          child: Image.asset(icon),
        )

      );
  }

  // --- Helper Widgets ---

  Widget _badge(String text, IconData icon) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: MyColors.baseColor),
              const SizedBox(width: 4),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 4),
        color: color.withOpacity(0.1),
      ),
      child: Icon(icon, color: color, size: 50),
    );
  }
}