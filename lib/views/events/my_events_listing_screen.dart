import 'package:Out2Do/api/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/my_events_controller.dart';
import '../../models/event_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../widgets/dialog_helper.dart';
import 'add_edit_event_screen.dart';
import 'events_details_screen.dart';

class MyEventsScreen extends StatelessWidget {
  MyEventsScreen({super.key});

  final MyEventsController controller = Get.put(MyEventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Obx(
        () {
          if(controller.isLoading.value){
            return Center(
              child: CircularProgressIndicator(
                color: MyColors.baseColor,
              ),
            );
          }


          return Column(
          children: [
            _searchBar(),

            Expanded(
              child: controller.filteredEvents.isEmpty?
              const Center(
                child: Text(
                  "No events found",
                  style: TextStyle(fontFamily: "medium"),
                ),
              ):
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredEvents.length,
                itemBuilder: (_, index) {
                  bool isLast = false;
                  if(controller.filteredEvents.length-1 == index){
                    isLast = true;
                  }
                  final event = controller.filteredEvents[index];
                  return _eventCard(event,index +1,isLast);
                },
              ),
            ),
          ],
        );},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.baseColor,
        child: const Icon(Icons.add, color: MyColors.white),
        onPressed: () {
          Get.to(() => AddEditEventScreen(isEdit: false))?.then((value) {
            // Eh code ohdon chalega jadon user AddEditEventScreen ton wapis aayega
            controller.loadMyEvents();
          });
        },
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
  Widget _eventCard(EventModel event, int count, bool isLast) {
    return InkWell(
      onTap: () {
        Get.to(() => EventDetailsScreen(event: event,myEvents: true,));
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
                placeholder: (_, __) =>
                    Container(color: MyColors.greyLight),
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

              /// 🏷 TITLE BADGE

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
                        _statusBadge(event.status!),
                        const SizedBox(width: 8),
                        _glassBadge(
                          "${formatToDdMmmYy(event.eventDate)}",
                        ),
                      ],
                    ),

                  ],
                ),
              ),


              /// ✏️ EDIT + 🗑 DELETE (NEW)
              Positioned(
                top: 54,
                right: 14,
                child: Column(
                  children: [
                    _iconAction(
                      icon: Icons.edit,
                      color: MyColors.baseColor,
                      onTap: () {
                        controller.fillForm(event);
                        Get.to(() => AddEditEventScreen(isEdit: true, event: event,))?.then((value) {
                          // Eh code ohdon chalega jadon user AddEditEventScreen ton wapis aayega
                          controller.loadMyEvents();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    _iconAction(
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: () {
                        DialogHelper.showIosDialog(
                          title: AppStrings.deleteTitle,
                          message: AppStrings.deleteMsg,
                          confirmText: AppStrings.delete,
                          isDeleteAction: true,
                          onConfirm: () {
                            controller.deleteEvent(event);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// 📝 TEXT CONTENT (UNCHANGED)
              Positioned(
                left: 16,
                right: 70,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.description??"",
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

                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.white70),
                        const SizedBox(width: 6),
                        Text(
                          formatTimeTo12Hour(event.eventTime),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: CachedNetworkImage(
                             // imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
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
                            ),
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
                              style: TextStyle(
                                color: MyColors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
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



  Widget _iconAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }


/*  Widget _eventCard(EventModel event,bool isLast) {
    return InkWell(
      onTap: () {
        Get.to(() => EventDetailsScreen(event: event));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: isLast?60:18),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// EVENT IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: CachedNetworkImage(
                    // 👈 Image.network ki jagah
                    imageUrl: event.images[0],
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 190,
                      color: MyColors.greyLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: MyColors.baseColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 190,
                      color: MyColors.greyLight,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                /// DATE
                Positioned(
                  top: 12,
                  left: 12,
                  child: _badge(
                    "${event.date.day} ${_month(event.date.month)}",
                    MyColors.baseColor,
                  ),
                ),

                /// ❤️ INTERESTED
                Positioned(
                  top: 12,
                  right: 12,
                  child: _statusBadge(event.status),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mediumText(event.title, null),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: MyColors.baseColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: regularText(event.location)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Column(
                  //  mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                       children: [ InkWell(
                         child: const Icon(
                           Icons.edit,
                           size: 20,
                           color: MyColors.baseColor,
                         ),
                         onTap: () {
                           controller.fillForm(event);
                           Get.to(
                                 () => AddEditEventScreen(isEdit: true, event: event),
                           );
                         },
                       ),

                         const SizedBox(width: 10),
                         InkWell(
                           child: const Icon(
                             Icons.delete,
                             size: 20,
                             color: Colors.red,
                           ),
                           onTap: () {
                             DialogHelper.showIosDialog(
                               title: AppStrings.deleteTitle,
                               message: AppStrings.deleteMsg,
                               confirmText: AppStrings.delete,
                               isDeleteAction: true,
                               onConfirm: () {
                                 controller.deleteEvent(event);
                               },
                             );
                           },
                         ),],
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 16, color: MyColors.baseColor),
                          const SizedBox(width: 8),
                          regularText(event.time ?? "Time not set"),
                        ],
                      ),
                    ],
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  Widget _statusBadge(int status) {
    Color color;
    String text;

    switch (status) {
      case 1:
        color = MyColors.green;
        text = "Approved";
        break;
      case 2:
        color = MyColors.red;
        text = "Rejected";
        break;
      default:
        color = MyColors.orange;
        text = "Pending";
    }

    return _badge(text, color);
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: mediumText(text, MyColors.white),
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
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }
}
