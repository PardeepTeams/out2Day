import 'package:Out2Do/utils/common_styles.dart';
import 'package:Out2Do/widgets/common_button.dart';
import 'package:Out2Do/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/report_controller.dart';
import '../../utils/colors.dart';
import '../utils/app_strings.dart';
import '../widgets/common_app_bar.dart';

class ReportUserScreen extends StatelessWidget {
  final String userName;
  final String userId;

  const ReportUserScreen({super.key, required this.userName, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Controller ko initialize karna
    final ReportController controller = Get.put(ReportController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: AppStrings.reportUser),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            semiboldText(
              "Help us understand the issue with $userName",
            ),
            const SizedBox(height: 10),
            mediumText("Select a reason for reporting this profile:",null),
            const SizedBox(height: 20),

            // Reasons List with Obx for reactive UI
            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.reportReasons.map((reason) {
                bool isSelected = controller.selectedReason.value == reason;
                return ChoiceChip(
                  label: Text(reason),
                  selected: isSelected,
                  showCheckmark: false,
                  onSelected: (val) => controller.selectReason(reason),
                  selectedColor: MyColors.baseColor,
                  labelStyle: TextStyle(
                    fontSize: 14,fontWeight: FontWeight.w400,
                      fontFamily: "regular",
                      color: isSelected ? MyColors.white : MyColors.black),
                  backgroundColor: Colors.grey[100],
                );
              }).toList(),
            )),

            const SizedBox(height: 30),
             mediumText("Extra Details", null),
            const SizedBox(height: 10),

          CommonTextField(controller:  controller.detailsController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              hintText: "Tell us more.."),


            const SizedBox(height: 40),

            // Submit Button
            CommonButton(
              title: "Submit Report",
              onTap: () {
                if (controller.selectedReason.isNotEmpty) {
                  controller.submitReport(userId);
                } else {
                  Get.snackbar("Error", "Please select a reason");
                }
              },
            ),
          ],
        ),
      ),
    );
  }


}