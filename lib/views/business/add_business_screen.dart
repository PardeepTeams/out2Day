import 'dart:io';
import 'package:Out2Do/models/business_model.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:Out2Do/widgets/common_button.dart';
import 'package:Out2Do/widgets/common_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../controller/add_business_controller.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import 'dart:typed_data';
import '../../utils/google_web_autocomplete.dart';
import '../../utils/location_delegate.dart';

class AddBusinessScreen extends StatefulWidget { // 👈 Stateful kitta taaki data reset na hove
  final bool isEdit;
  final BusinessModel? model;
  const AddBusinessScreen({super.key, required this.isEdit, this.model});

  @override
  State<AddBusinessScreen> createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final AddBusinessController controller = Get.put(AddBusinessController());

  @override
  void initState() {
    super.initState();
    // 👈 InitState vich data fill kitta taaki rebuild te images reset na hon
    if (widget.isEdit && widget.model != null) {
      controller.fillBusinessData(widget.model!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonAppBar(
        title: widget.isEdit ? AppStrings.editBusiness : AppStrings.addBusiness,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            regularText(AppStrings.businessName),
            commonTextFieldSmallGap(),
            CommonTextField(controller: controller.nameCtrl,
                textCapitalization : TextCapitalization.words,
                hintText: AppStrings.businessName),
            commonTextFieldLargeGap(),

            regularText(AppStrings.businessCategory),
            commonTextFieldSmallGap(),
            CommonTextField(controller: controller.categoryCtrl,
                textCapitalization : TextCapitalization.sentences,
                hintText: AppStrings.businessCategory),
            commonTextFieldLargeGap(),

            regularText(AppStrings.businessLocation),
            commonTextFieldSmallGap(),

            kIsWeb?
            GoogleWebAutocomplete(
              controller: controller.locationCtrl,
              onSelected: (placeDescription, placeId) {;
              LocationDelegate().getDetails(placeId, controller);
              },  hint: AppStrings.locationLabel,
            ):
            googlePlacesTextField(
              controller: controller.locationCtrl,
              hint: AppStrings.locationLabel,
              onLocationClick: (Prediction p1) {
                FocusScope.of(context).unfocus();
                dismissKeyboard(context);
                controller.getLocationDetails(p1);
              }, // 👈 Updated
            ),

           /* kIsWeb?
            GoogleWebAutocomplete(
              controller: controller.locationCtrl,
              onSelected: (placeDescription, placeId) {
                print("Selected: $placeDescription");
                print("Place ID: $placeId");
                controller.getLocationDetailsWeb(placeId);
              },  hint: AppStrings.locationLabel,
            ):*/
         /*   googlePlacesTextField(
                controller: controller.locationCtrl,
                hint: AppStrings.businessLocation,
                onLocationClick: (p1) => controller.getLocationDetails(p1)),*/


            commonTextFieldLargeGap(),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      regularText(AppStrings.activityStartTime),
                      commonTextFieldSmallGap(),
                      CommonTextField(
                        controller: controller.startTimeCtrl,
                        hintText: AppStrings.activityStartTime,
                        readOnly: true,
                        onTap: () => controller.showIosTimePicker(context,false),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      regularText(AppStrings.activityEndTime),
                      commonTextFieldSmallGap(),
                      CommonTextField(
                        controller: controller.endTimeCtrl,
                        hintText: AppStrings.activityEndTime,
                        readOnly: true,
                        onTap: () => controller.showIosTimePicker(context,true),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            commonTextFieldLargeGap(),

            regularText(AppStrings.activityPrice),
            commonTextFieldSmallGap(),
            CommonTextField(controller: controller.priceCtrl,
                keyboardType: TextInputType.number,
                hintText: AppStrings.activityPrice),

            commonTextFieldLargeGap(),

            regularText(AppStrings.businessURL),
            commonTextFieldSmallGap(),
            CommonTextField(controller: controller.webUrlCtrl, hintText: AppStrings.businessURL),
            commonTextFieldLargeGap(),

            regularText(AppStrings.businessDescription),
            commonTextFieldSmallGap(),
            CommonTextField(controller: controller.descriptionCtrl,
                keyboardType: TextInputType.multiline, // 👈 Ye iOS Web ke liye mandatory hai
                textInputAction: TextInputAction.newline,
                hintText: AppStrings.businessDescription, maxLines: 4),
            commonTextFieldLargeGap(),

            _imageSection(),
            commonButtonGap(),

            CommonButton(
                title: AppStrings.btnSubmit,
                onTap: () {
                  dismissKeyboard(context);
                  if (widget.isEdit) {
                    controller.updateBusiness(context, widget.model!.id!);
                  } else {
                    controller.submitBusiness(context);
                  }
                })
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        regularText(AppStrings.businessImages),
        commonTextFieldSmallGap(),
        Obx(() => SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              if (controller.totalImages < 5) _addImageTile(),

              // 1. Network Images
              ...List.generate(controller.networkImages.length, (index) =>
                  _imageTile(isNetwork: true, imagePath: controller.networkImages[index],
                      onDelete: () => controller.removeNetworkImage(index))),

              // 2. Web Bytes Images
              ...List.generate(controller.webImages.length, (index) =>
                  _imageTile(isNetwork: false, webBytes: controller.webImages[index],
                      onDelete: () => controller.removeWebImage(index))),

              // 3. Local File Images
              ...List.generate(controller.selectedImages.length, (index) =>
                  _imageTile(isNetwork: false, imagePath: controller.selectedImages[index].path,
                      onDelete: () => controller.removeImage(index))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _addImageTile() {
    return InkWell(
      onTap: () => showImageSourceSheet(onImageSelected: (s) => controller.pickImage(s)),
      child: Container(
        width: 90, margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: MyColors.baseColor)),
        child: const Icon(Icons.add, color: MyColors.baseColor),
      ),
    );
  }

  Widget _imageTile({required bool isNetwork, String? imagePath, Uint8List? webBytes, required VoidCallback onDelete}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: isNetwork
                ? Image.network(imagePath!, width: 90, height: 90, fit: BoxFit.cover)
                : (kIsWeb ? Image.memory(webBytes!, width: 90, height: 90, fit: BoxFit.cover)
                : Image.file(File(imagePath!), width: 90, height: 90, fit: BoxFit.cover)),
          ),
          Positioned(
            top: 5, right: 5,
            child: InkWell(onTap: onDelete, child: const CircleAvatar(radius: 10, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 12, color: Colors.white))),
          ),
        ],
      ),
    );
  }
}
