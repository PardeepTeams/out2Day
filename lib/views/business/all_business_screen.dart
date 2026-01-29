import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein
import '../../controller/business_controller.dart';
import '../../models/business_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import 'business_details_screen.dart';
import 'package:intl/intl.dart';
class AllBusinessesScreen extends StatelessWidget {
  AllBusinessesScreen({super.key});

  final BusinessController controller = Get.put(BusinessController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Obx(() {
              // 1. Loading State Check
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: MyColors.baseColor,
                  ),
                );
              }

              // 2. Empty List Check
              if (controller.filteredBusinesses.isEmpty) {
                return const Center(
                  child: Text(
                    "No business found",
                    style: TextStyle(
                      fontFamily: "medium",
                      fontSize: 16,
                      color: MyColors.greyText2,
                    ),
                  ),
                );
              }

              // 3. Data Available (Grid View)
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                   itemCount:controller.filteredBusinesses.length ,
                  itemBuilder: (_, index) {
                bool isLast = index == controller.filteredBusinesses.length - 1;
                return _businessCard(controller.filteredBusinesses[index], isLast);
              } );
            }),
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
          controller: controller.searchAllCtrl,
          style: const TextStyle(fontFamily: "regular"),
          decoration: const InputDecoration(
            hintText: "Search Business",
            hintStyle: TextStyle(fontFamily: "regular"),
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _businessCard(BusinessModel business,bool isLast) {
    return InkWell(
      onTap: (){
        Get.to(() => BusinessDetailsScreen(business: business,myBusiness: false,));
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
                imageUrl: business.businessImages!.first,
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

             /* /// 🏷 EVENT COUNT
              Positioned(
                top: 14,
                left: 14,
                right: 14, // Poori width cover karega
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Name left te, Status right te
                  children: [
                    /// 🏷 BUSINESS NAME (Flexible Logic)
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: MyColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          business.businessName!,
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

                    const SizedBox(width: 10), // Gap bachaun layi

                    /// 🟢 STATUS + PRICE
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _glassBadge("\$200"),
                      ],
                    ),
                  ],
                ),
              ),*/

              /// 📝 TEXT CONTENT
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child:// Column(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                //  children: [
                    /// 👤 USER INFO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                      /*  CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
                              fit: BoxFit.cover,
                              //  imageUrl: "${event.userDetail!.profile!}",
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
                        ),*/


                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 2,
                                ),
                                Expanded(child:  Text(
                                  business.businessName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: MyColors.white,
                                    fontSize: 16,
                                    fontFamily: "medium",
                                    fontWeight: FontWeight.w500,
                                    height: 1.3,
                                  ),
                                ),)

                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Expanded(child:    Text(
                                  business.address!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: MyColors.white70,
                                    fontSize: 14,
                                    fontFamily: "regular",
                                    fontWeight: FontWeight.w400,
                                    height: 1.3,
                                  ),
                                ),)

                              ],
                            ),

                            /// ⏰ TIME
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 6),
                                Expanded(child:  Text(
                                  "${formatToUITime(business.startTime)} - ${formatToUITime(business.endTime)}",
                                  //  formatTimeTo12Hour(event.eventTime),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: MyColors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "regular",
                                  ),
                                ))
                               ,
                              ],
                            ),
                          ],
                        )),

                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _glassBadge("\$200"),
                          ],
                        ),
                      ],
                    ),
              //    ],
             //   ),
              ),
            ],
          ),
        ),
      )


      /*Container(
      margin:  EdgeInsets.only(bottom: isLast?60:16),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          image(business),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// NAME + ACTIONS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mediumTextSingleLine(business.businessName??"", null),
                          regularTextSingleLine(business.address??""),
                        ],
                      ),
                    ),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        regularTextSingleLine("9:00 AM - 7:00 PM"),
                        regularTextSingleLine("\$200"),
                      ],))

                    /// ✏️ EDIT + 🗑 DELETE

                  ],
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    )*/
    );
  }

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
 /* Widget _businessGridCard(BusinessModel business,bool isLast) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BusinessDetailsScreen(business: business,myBusiness: false,));
      },
      child: Container(
        decoration: cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE + ICONS
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.circular(16),
                    ),
                    child: Image.network(
                      business.businessImages!.first,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// TOP ICON ROW
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// LEFT ICON
                         CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(
                              business.userDetail!.profile!
                           // "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                          ),
                        )

                        /// RIGHT ICONS
                      *//*  Row(
                          children: [
                            _iconWrapper(
                              icon: Icons.edit,
                              onTap: () {
                                controller.editBusiness(business);
                              },
                            ),
                            const SizedBox(width: 6),
                            _iconWrapper(
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () {
                                controller.deleteBusiness(business.id);
                              },
                            ),
                          ],
                        ),*//*
                      ],
                    ),
                  ),
                  
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        mediumText(
                          business.businessName??"",
                          MyColors.white,
                        ),
                        const SizedBox(height: 2),
                        whiteRegularText(
                          business.city??"",
                        ),
                      ],
                    ),
                  ),)
                ],
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }*/

  // 🔘 ICON UI
  Widget _iconWrapper({
    required IconData icon,
    required VoidCallback onTap,
    Color color = MyColors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
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
