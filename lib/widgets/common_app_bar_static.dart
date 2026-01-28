import 'package:Out2Do/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class CommonHomeAppBarStatic extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showGridToggle;
  final RxBool? isGridView;
  final VoidCallback? onGridToggle;
  final int notificationCount;

  const CommonHomeAppBarStatic({
    super.key,
    required this.title,
    this.showGridToggle = false,
    this.isGridView,
    this.onGridToggle,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.white,
      elevation: 0,
      titleSpacing: 10,
      centerTitle: false,
      title: SvgPicture.asset(
        "assets/logo_outdo.svg",
        width: 120,
      ),
      actions: [
        Obx(() => Container(
          width: 45,
          height: 45,
          child: InkWell(
            onTap: onGridToggle,
            child: Center(
              child: SvgPicture.asset(
                // ✅ Condition: Je grid view hai taan swipe wala icon dikhao,
                // nahi taan grid wala icon
                isGridView!.value
                    ? "assets/non_grid.svg" // Tuhade swipe view da icon
                    : "assets/grid_icon.svg",  // Tuhade grid view da icon
                width: 40,
                height: 40,
              ),
            ),
          ),
        )),
      /*  Container(
          width: 45,
          height: 45,
          child:  *//*Obx(() =>*//* InkWell(
            onTap: (){},
            child: Center(
            //  padding: const EdgeInsets.only(left: 4,right: 8),
              child: SvgPicture.asset(
                "assets/filter_icon.svg",
                width: 40,
                height: 40,
              ),
            ),
          ),

        ),*/
        Container(
          width: 45,
          height: 45,
          child:  /*Obx(() =>*/ InkWell(
            onTap: (){
              Get.toNamed(AppRoutes.notifications)?.then((value) {
                // controller.refreshHome();
              });
            },
            child: Center(
              //  padding: const EdgeInsets.only(left: 4,right: 8),
              child: SvgPicture.asset(
                "assets/notification.svg",
                width: 40,
                height: 40,
              ),
            ),
          ),

        ),
        SizedBox(
          width: 10,
        )


        /// 🔳 Filter Icon

    ],
    );
  }
}
