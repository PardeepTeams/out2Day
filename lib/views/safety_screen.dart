import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/safety_controller.dart';
import '../models/safety_advice_response.dart';

class SafeDatingScreen extends StatelessWidget {
  SafeDatingScreen({super.key});

  final SafetyController controller = Get.put(SafetyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: CommonAppBar(title: AppStrings.safty),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: MyColors.baseColor));
        }

        // Agar data khali hai
        if (controller.adviceCategories.isEmpty) {
          return const Center(child: Text("No safety advice found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Banner Section
              _buildBanner(),

              const SizedBox(height: 24),

              /// 🔹 Dynamic Sections (Categories)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.adviceCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.adviceCategories[index];
                  return _sectionWidget(category);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.black.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // SVG Image (Ensure path is correct in controller)
          Obx(() => SvgPicture.asset(
            controller.bannerImage.value,
            height: 120,
            placeholderBuilder: (context) => const SizedBox(height: 120, child: Icon(Icons.security, size: 50)),
          )),
          const SizedBox(height: 12),
          Obx(() => Text(
            controller.bannerTitle.value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.black),
          )),
          const SizedBox(height: 4),
          Obx(() => Text(
            controller.bannerSubtitle.value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          )),
        ],
      ),
    );
  }

  Widget _sectionWidget(SafetyCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4), // Screen margin layi
          child: Row(
            children: [
              Icon(
                category.name!.contains("Personal") ? Icons.lock_outline : Icons.groups_outlined,
                size: 20,
                color: MyColors.baseColor,
              ),
              const SizedBox(width: 8),
              Text(
                category.name ?? "",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        /// 🔹 Horizontal Scrollable List
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // 👈 Horizontal scroll enable kitta
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 2.0), // Side padding
          child: IntrinsicHeight( // 👈 Saare cards di height barabar rakhan layi
            child: Row(
              children: category.tips!.map((tip) {
                return Container(
                  width: MediaQuery.of(Get.context!).size.width * 0.44, // 👈 Card di width (70% screen)
                  margin: const EdgeInsets.only(right: 12.0), // Cards de vich gap
                  child: _infoCard(tip),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24), // Agli section ton pehle gap
      ],
    );
  }

  /// 🔹 Card Widget (Slightly adjusted)
  Widget _infoCard(SafetyTip tip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Content nu center vich rakhega
        children: [
          Text(
            tip.title ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MyColors.black),
          ),
          const SizedBox(height: 6),
          Text(
            tip.description ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.2),
          ),
        ],
      ),
    );
  }
}
