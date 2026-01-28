import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/connect_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/colors.dart';

class SwipeCard extends StatefulWidget {
  final ConnectProfile profile;
  final ConnectController controller;

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
          widget.controller.onSwipeRight(widget.profile);
        } else if (dx < -120) {
          widget.controller.onSwipeLeft(widget.profile);
        }
        setState(() => dx = 0);
      },
      feedback: Material( // Material add kiya taaki drag ke waqt text/style sahi dikhe
        color: Colors.transparent,
        child: _card(rotation: dx / 300),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: _card(),
    );
  }

  Widget _card({double rotation = 0}) {
    return Transform.rotate(
      angle: rotation,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.userProfileDetail)?.then((value) {
            widget.controller.refreshProfiles();
          });
        },
        child: Container(
          height: 450,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Stack( // Image aur Gradient ke liye Stack use kiya
            children: [
              /// 🖼 Cached Image Layer
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.profile.image,
                  height: 450,
                  width: 300,
                  fit: BoxFit.cover,
                  // Loading Placeholder
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: MyColors.baseColor,
                      ),
                    ),
                  ),
                  // Error Widget
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.error_outline, color: Colors.grey),
                  ),
                ),
              ),

              /// 🌫 Gradient Overlay & Text
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Text(
                  "${widget.profile.name}, ${widget.profile.age}",
                  style: const TextStyle(
                    color: MyColors.white,
                    fontSize: 22,
                    fontFamily: "regular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}