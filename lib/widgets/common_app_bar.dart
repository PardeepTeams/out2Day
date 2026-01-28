import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import '../utils/colors.dart';

class CommonAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBack;


  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: MyColors.black,
          fontFamily: "semibold",
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      leading: showBack?InkWell(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
        color: MyColors.black,),
      ):null,

    );
  }
}
