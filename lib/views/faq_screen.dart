import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:Out2Do/widgets/common_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../utils/common_styles.dart';
import '../controller/faq_controller.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});

  final FaqController controller = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonAppBar(title: AppStrings.faqs),
      body: Obx(() {
        if(controller.isLoading.value){
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.baseColor,
            ),
          );
        }
        return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.faqList.length,
        itemBuilder: (context, index) {
          return _faqTile(
            index: index,
            question: controller.faqList[index].title!,
            answer: controller.faqList[index].description!,
          );
        },
      );
      }
    ),
    );
  }

  /// 🔹 FAQ TILE
  Widget _faqTile({
    required int index,
    required String question,
    required String answer,
  }) {
    return Obx(() {
      final isExpanded = controller.expandedIndex.value == index;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded
                ? MyColors.baseColor
                : MyColors.greyLight,
          ),
          boxShadow: [
            BoxShadow(
              color: MyColors.baseColor.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.toggleFaq(index),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// QUESTION ROW
              Row(
                children: [
                  Expanded(
                    child: mediumText(
                      question,
                     null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: MyColors.baseColor,
                      size: 26,
                    ),
                  ),
                ],
              ),

              /// ANSWER
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: regularText(
                    answer,
                  ),
                ),
                secondChild: const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }
}
