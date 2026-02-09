import 'package:Out2Do/views/business/add_business_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/business_controller.dart';
import '../../models/business_model.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../widgets/dialog_helper.dart';
import 'business_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein


class MyBusinessesScreen extends StatelessWidget {
  MyBusinessesScreen({super.key});

  final BusinessController controller = Get.put(BusinessController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: RefreshIndicator(child:      Obx(
                    () {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.baseColor,
                      ),
                    );
                  }

                  // 2. Empty List Check
                  // Empty List Check
                  if (controller.filteredMyBusinesses.isEmpty) {
                    // 🟢 3. Empty state mein pull-to-refresh chalane ke liye ListView zaroori hai
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: Get.height * 0.3),
                        const Center(
                          child: Text(
                            "No business found",
                            style: TextStyle(
                              fontFamily: "medium",
                              fontSize: 16,
                              color: MyColors.greyText2,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                      itemCount: controller.filteredMyBusinesses.length,
                      itemBuilder: (_, index) {
                        bool isLast = false;
                        if(controller.filteredMyBusinesses.length-1 == index){
                          isLast = true;
                        }
                        return _myBusinessCard(controller.filteredMyBusinesses[index],isLast);
                      });
                  /*GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                    itemCount: controller.filteredMyBusinesses.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,           // 👈 2 column
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.78,      // 👈 image jaisa ratio
                    ),
                    itemBuilder: (_, index) {
                      bool isLast = false;
                      if(controller.filteredMyBusinesses.length-1 == index){
                        isLast = true;
                      }
                      return _businessGridCard(controller.filteredMyBusinesses[index],isLast);
                    }

                );*/
                }
            ), onRefresh:() async {
              // 🟢 2. Controller ka fetch function call karein (Must be Future<void>)
              await controller.loadMyBusiness(false);
            },)
            

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.baseColor,
        child: const Icon(Icons.add, color: MyColors.white),
        onPressed: () {
          Get.to(() => AddBusinessScreen(isEdit: false))?.then((value) {
            // Eh code ohdon chalega jadon user AddEditEventScreen ton wapis aayega
            controller.loadMyBusiness(false);
          });
        },
      ),
    );
  }



  /// 🔍 SEARCH BAR
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 10),
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
          controller: controller.searchCtrl,
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

  /// 🏢 BUSINESS CARD
  Widget _myBusinessCard(BusinessModel business, bool isLast) {
    return InkWell(
      onTap: () {
        Get.to(() => BusinessDetailsScreen(business: business, myBusiness: true,));
      },
      child:  Container(
        margin: EdgeInsets.only(bottom: isLast ? 20 : 20),
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
                placeholder: (context, url) => Image.network(
                  business.businessImagesThumb!.first, // Agar thumbnail key alag hai toh wo use karein
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Agar thumbnail bhi load ho raha ho toh halka grey color dikhe
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: MyColors.greyLight,
                  ),
                ),

                // 🔴 Error case jab main image load na ho paye
                errorWidget: (context, url, error) => Container(
                  color: MyColors.greyLight,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
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

           /*   Positioned(
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
                        _statusBadge(business),
                        const SizedBox(width: 8),
                        _glassBadge("\$200"),
                      ],
                    ),
                  ],
                ),
              ),*/

              Positioned(
                  top: 14,
                  right: 14,
                  child:   _statusBadge(business),
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
                        Get.to(
                              () => AddBusinessScreen(
                            isEdit: true,
                            model: business,
                          ),
                        );
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
                            controller.deleteBusiness(business);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// 📝 TEXT CONTENT
              Positioned(
                left: 16,
                right: 14,
                bottom: 16,
                child:// Column(
               //   crossAxisAlignment: CrossAxisAlignment.start,
              //    children: [
                /*    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          business.address!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MyColors.white,
                            fontSize: 18,
                            fontFamily: "medium",
                            height: 1.3,
                          ),
                        ),
                      ],
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
                          "9:00 AM - 7:00 PM",
                          //  formatTimeTo12Hour(event.eventTime),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MyColors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: "regular",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),*/

                    /// 👤 USER INFO
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                     /*   CircleAvatar(
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
                        ),

                        const SizedBox(width: 10),*/
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
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
                                ) )
                              ,
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: MyColors.white70,
                                ),
                                const SizedBox(width: 6),
                                Expanded(child:   Text(
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
                                ))
                              ,
                              ],
                            ),

                            /// ⏰ TIME
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: MyColors.white70,
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
                                ), )

                              ],
                            ),
                          ],
                        )),

                        const SizedBox(width: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _glassBadge("\$200"),
                          ],
                        ),
                      ],
                    ),
            //      ],
            //    ),
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
            /// IMAGE + STATUS
            Stack(
              children: [
                image(business),

                /// 🔴 STATUS ON IMAGE (TOP RIGHT)
                Positioned(top: 12,left:12,
                    child: _statusBadge(business)),
                Positioned(
                  top: 12,
                  right: 12,
                  child:   Row(
                  children: [
                    InkWell(
                      child:  Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                    color: MyColors.baseColor,
                  ),
                )

                      ,
                      onTap: () {
                        Get.to(
                              () => AddBusinessScreen(
                            isEdit: true,
                            model: business,
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 10),
                    InkWell(
                      child:  Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child:  const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        DialogHelper.showIosDialog(
                          title: AppStrings.deleteTitle,
                          message: AppStrings.deleteMsg,
                          confirmText: AppStrings.delete,
                          isDeleteAction: true,
                          onConfirm: () {
                            controller.deleteBusiness(business);
                          },
                        );
                      },
                    ),
                  ],
                ),)
              ],
            ),

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
      ),*/
    );
  }

  /// 🟡 STATUS BADGE
  Widget _statusBadge(BusinessModel business) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: controller.statusColor(business.status??0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        controller.statusText(business.status??0),
        style: const TextStyle(
          fontFamily: "medium",
          fontSize: 12,
          color: MyColors.white,
        ),
      ),
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


  Widget _businessGridCard(BusinessModel business,bool isLast) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BusinessDetailsScreen(business: business, myBusiness: true,));


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
                          //  "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                          ),
                        ),

                        /// RIGHT ICONS
                          Row(
                          children: [
                            _iconWrapper(
                              icon: Icons.edit,
                              onTap: () {
                                Get.to(() => AddBusinessScreen(isEdit: true, model: business,))?.then((value) {
                                  controller.loadMyBusiness(false);
                                });
                              },
                            ),
                            const SizedBox(width: 6),
                            _iconWrapper(
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () {
                                DialogHelper.showIosDialog(
                                  title: AppStrings.deleteTitle,
                                  message: AppStrings.deleteMsg,
                                  confirmText: AppStrings.delete,
                                  isDeleteAction: true,
                                  onConfirm: () {
                                    controller.deleteBusiness(business);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 60,
                    left: 8,
                    child: _statusBadge(business),
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
  }

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
