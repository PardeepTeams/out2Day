import 'package:Out2Do/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class CommonHomeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CommonHomeAppBar({
    super.key,
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
      ],
    );
  }
}
