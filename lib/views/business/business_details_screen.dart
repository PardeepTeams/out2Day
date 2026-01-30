import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/business_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein


class BusinessDetailsScreen extends StatefulWidget {
  final BusinessModel business;
  final bool myBusiness;

  const BusinessDetailsScreen({super.key, required this.business,required this.myBusiness});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
   //   appBar:CommonAppBar(title: "Business Detail"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 360,
                  width: double.infinity,
                  child:PageView.builder(
                    itemCount: widget.business.businessImages!.length,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    itemBuilder: (_, index) {
                      return CachedNetworkImage(
                        imageUrl: widget.business.businessImages![index], // Main Original Image
                        width: double.infinity,
                        fit: BoxFit.cover,

                        // 🟢 Thumbnail dikhane ke liye (Placeholder)
                        placeholder: (context, url) => Image.network(
                          widget.business.businessImagesThumb![index], // Backend se aaya hua Thumbnail URL
                          width: double.infinity,
                          fit: BoxFit.cover,
                          // Agar thumbnail bhi load ho raha ho tab tak ke liye:
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                          ),
                        ),

                        // 🔴 Agar original image load na ho paye
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),

                ),

                /// BACK BUTTON (ON IMAGE)
                Positioned(
                  top: 40,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                ),

                /// USER + EVENT INFO (BOTTOM OF IMAGE)
      /*          Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child:Container(
                    padding:  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: MyColors.black.withOpacity(0.5),
                    ),
                    child:  Row(
                      children: [
                         CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                            // widget. business.userDetail!.profile!
                            "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mediumText("Test"*//*widget.business.userDetail!.firstName!*//*, MyColors.white),
                              whiteRegularText("Software Developer"*//*widget.business.userDetail!.profession??""*//*,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  ,
                ),*/

                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0, // 🔥 IMPORTANT for center
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: MyColors.black.withOpacity(0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 🔥 ONLY DOTS WIDTH
                        children: List.generate(
                          widget.business.businessImages!.length,
                              (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: currentIndex == i ? 10 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: currentIndex == i
                                  ? MyColors.white
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
            Transform.translate(
              offset: const Offset(0, 0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                decoration: const BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(0),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE + STATUS
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.business.businessName??"",
                            style: const TextStyle(
                              fontFamily: "semibold",
                              fontSize: 22,
                            ),
                          ),
                        ),
                        if(widget.myBusiness)
                        _statusBadge(widget.business.status??0),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// CATEGORY
                    Text(
                      widget.business.category??"",
                      style: const TextStyle(
                        fontFamily: "regular",
                        fontSize: 14,
                        color: MyColors.black,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// LOCATION
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: MyColors.baseColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: regularText(widget.business.address??""),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.watch_later_outlined,
                            size: 18, color: MyColors.baseColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: regularText("${formatToUITime(widget.business.startTime)} - ${formatToUITime(widget.business.endTime)}",),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// WEBSITE
                    if (widget.business.webLink!.isNotEmpty)
                      InkWell(
                        onTap: () async {
                            final uri = Uri.parse(widget.business.webLink!);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.language,
                                size: 18, color: MyColors.baseColor),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                widget.business.webLink??"",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: "regular",
                                  fontSize: 14,
                                  color: MyColors.baseColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                  /*  const SizedBox(height: 16),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.shade200,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_pin,
                          size: 40,
                          color: MyColors.baseColor,
                        ),
                      ),
                    ),*/



                    const SizedBox(height: 24),

                    /// ABOUT
                    const Text(
                      "About Activity",
                      style: TextStyle(
                        fontFamily: "medium",
                        fontSize: 16,
                        color: MyColors.black,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.business.description??"",
                      style: const TextStyle(
                        fontFamily: "regular",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),


                    const SizedBox(height: 24),

                    /// ABOUT
                    const Text(
                      AppStrings.activityPrice,
                      style: TextStyle(
                          fontFamily: "medium",
                          fontSize: 16,
                          color: MyColors.black,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$200",
                      style: const TextStyle(
                        fontFamily: "regular",
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔖 STATUS BADGE
  Widget _statusBadge(int status) {
    Color color;
    String text;

    switch (status) {
      case 1:
        color = MyColors.green;
        text = AppStrings.approved;
        break;
      case 2:
        color = MyColors.red;
        text = AppStrings.rejected;
        break;
      default:
        color = MyColors.orange;
        text = AppStrings.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: "medium",
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }

  String formatToUITime(String? apiTime) {
    if (apiTime == null || apiTime.isEmpty) return "";
    try {
      // API format "18:00:00" ko parse karein
      DateFormat apiFormat = DateFormat("HH:mm:ss");
      DateTime parsedTime = apiFormat.parse(apiTime);

      // UI format "06:00 PM" mein convert karein
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      print("Time Parsing Error: $e");
      return "";
    }
  }
}
