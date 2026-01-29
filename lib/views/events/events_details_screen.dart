import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/event_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final bool myEvents;

  const EventDetailsScreen({super.key, required this.event,required this.myEvents});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      backgroundColor: MyColors.white,
    //  appBar: CommonAppBar(title: ''),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 360,
                  width: double.infinity,
                  child:PageView.builder(
                    itemCount: event.eventImages!.length,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    itemBuilder: (_, index) {
                      return Image.network(
                        event.eventImages![index],
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                if (widget.myEvents)
                  Positioned(
                    top: 50,
                    right: 16,
                    child: _statusBadge(event.status!),
                  ),
                /// USER + EVENT INFO (BOTTOM OF IMAGE)
                Positioned(
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
                            event.userDetail!.profile!
                         //   "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              mediumText(event.userDetail!.firstName! , MyColors.white),
                              whiteRegularText(event.userDetail!.profession!,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                 ,
                ),

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
                          event.eventImages!.length,
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

            /// ---------------- CONTENT CARD ----------------
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

                    /// TITLE
                    Text(
                      event.eventTitle!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: "semibold",
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DATE
                    _infoRow(
                      Icons.calendar_month,
                      formatToDdDayMmmYy(event.eventDate!),
                    ),

                    const SizedBox(height: 5),

                    /// TIME
                    _infoRow(
                      Icons.access_time,
                      formatTimeTo12Hour(event.eventTime),
                    ),

                    const SizedBox(height: 5),

                    /// LOCATION
                    _infoRow(
                      Icons.location_on,
                      event.address??"",
                    ),

                   /* const SizedBox(height: 10),

                    /// MAP PREVIEW
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

                    const SizedBox(height: 10),

                    /// DESCRIPTION TITLE
                    mediumText("Event Description", MyColors.black),

                    const SizedBox(height: 2),

                    /// DESCRIPTION
                    regularText(event.description??""),

                    const SizedBox(height: 28),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ICON + TEXT ROW
  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: MyColors.baseColor),
        const SizedBox(width: 10),
        Expanded(child: regularText(text)),
      ],
    );
  }

  Widget _statusBadge(int status) {
    Color bgColor;
    String text;

    switch (status) {
      case 1:
        bgColor = MyColors.green;
        text = AppStrings.approved;
        break;
      case 2:
        bgColor = MyColors.red;
        text = AppStrings.rejected;
        break;
      default:
        bgColor = MyColors.orange; // pending
        text = AppStrings.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: MyColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: "medium",
        ),
      ),
    );
  }

}
