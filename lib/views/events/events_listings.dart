import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../controller/events_controller.dart';
import '../../models/event_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../widgets/common_home_app_bar.dart';
import 'events_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein


class EventsListingScreen extends StatelessWidget {
  EventsListingScreen({super.key});

  final EventsController controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
   //   appBar: const CommonAppBar(title: AppStrings.events),
      body: Column(
        children: [
          _searchBar(),

          Expanded(
            child: RefreshIndicator(child: Obx(() {
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.baseColor,
                  ),
                );
              }
              if (controller.filteredEvents.isEmpty) {
                return const Center(
                  child: Text(
                    "No events found",
                    style: TextStyle(fontFamily: "medium"),
                  ),
                );
              }else{
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredEvents.length,
                  itemBuilder: (_, index) {
                    bool isLast = false;
                    if(controller.filteredEvents.length-1 == index){
                      isLast = true;
                    }
                    return _eventCard(controller.filteredEvents[index],index+1,isLast);
                  },
                );
              }


            }) , onRefresh: () async {
              // 🟢 2. Controller ka method call karein (Dhyan rahe ye async ho)
              await controller.loadEvents(false);
            },)
           ,
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right:16,top: 0,bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: MyColors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          style: const TextStyle(fontFamily: "regular"),
          decoration: const InputDecoration(
            hintText: "Search Events",
            hintStyle: TextStyle(fontFamily: "regular"),
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  /// 🎉 EVENT CARD (same as before)
  /// 🎉 IMAGE STYLE EVENT CARD
  Widget _eventCard(EventModel event, int count, bool isLast) {
    return InkWell(
      onTap: () {
        Get.to(() => EventDetailsScreen(event: event,myEvents: false,));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 90 : 20),
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              /// 🌄 IMAGE
              CachedNetworkImage(
                imageUrl: event.eventImages!.first,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: MyColors.greyLight,
                ),
              ),

              /// 🌑 GRADIENT OVERLAY
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.25),
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              /// 🏷 EVENT COUNT
              Positioned(
                top: 14,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: MyColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.eventTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Lamba hon te wrap karega
                          style: const TextStyle(
                            color: MyColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: "medium",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _glassBadge(
                          "${formatToDdMmmYy(event.eventDate)}",
                        ),
                      ],
                    ),

                  ],
                ),
              ),



              /// 📝 TEXT CONTENT
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// QUESTION / TITLE
                    Text(
                      event.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 18,
                        fontFamily: "medium",
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 6),
                    /// ⏰ TIME
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatTimeTo12Hour(event.eventTime),
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "regular",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    /// 👤 USER INFO
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "${event.userDetail!.additionalImagesThumb!.first}", // Aapka variable
                              fit: BoxFit.cover,
                              width: 64,
                              height: 64,

                              // ✅ Cache settings: Agar image cache mein hai toh bina loader ke turant dikhegi
                              placeholderFadeInDuration: Duration.zero,
                              fadeInDuration: const Duration(milliseconds: 500), // Puranay 1500ms se kam kiya taaki lag na lage

                              // ✅ Image cache management
                              memCacheWidth: 200, // Memory optimization
                              memCacheHeight: 200,

                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),/*CachedNetworkImage(
                            //  imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
                              fit: BoxFit.cover,
                              imageUrl: "${event.userDetail!.profile!}",
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
                            ),*/
                          ),
                        ),

                        const SizedBox(width: 10),
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                           //   "Test",
                              event.userDetail!.firstName??"" ,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: MyColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontFamily: "medium",
                              ),
                            ),
                            Text(
                            //  "Software Developer",
                              event.userDetail!.profession??"",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                fontFamily: "regular",
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  /// ✨ GLASS STYLE BADGE
  Widget _glassBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MyColors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: mediumText(
          text,
          MyColors.white
      ),
    );
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }
}
