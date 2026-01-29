import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../controller/my_events_controller.dart';
import '../../models/event_model.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_text_field.dart';
import '../../utils/google_web_autocomplete.dart';
import '../../utils/location_delegate.dart';

class AddEditEventScreen extends StatefulWidget { // 👈 Change to StatefulWidget
  final bool isEdit;
  final EventModel? event;

  const AddEditEventScreen({super.key, required this.isEdit, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final MyEventsController controller = Get.find();

  @override
  void initState() {
    super.initState();
    // 👈 Hun form sirf ik vaar fill hoyega, rebuild te nahi
    if (widget.isEdit && widget.event != null) {
      // PostFrameCallback safe rehnda hai taaki controller ready hove
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fillForm(widget.event!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonAppBar(
        title: widget.isEdit ? AppStrings.editEvent : AppStrings.addEvent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            regularText(AppStrings.eventTitleLabel),
            commonTextFieldSmallGap(),
            CommonTextField(
              controller: controller.titleCtrl,
              textCapitalization: TextCapitalization.words,
              hintText: AppStrings.eventTitleLabel,
            ),
            commonTextFieldLargeGap(),

            regularText(AppStrings.eventLocationLabel),
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
              hint: AppStrings.eventLocationLabel,
              onLocationClick: (Prediction p1) {
                controller.getLocationDetails(p1);
              },
            ),
            commonTextFieldLargeGap(),

            /// --- Date & Time Row ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      regularText(AppStrings.eventDateLabel),
                      commonTextFieldSmallGap(),
                      CommonTextField(
                        controller: controller.dateCtrl,
                        hintText: AppStrings.selectDateHint,
                        readOnly: true,
                        onTap: () => controller.pickDate(context),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      regularText(AppStrings.eventTimeLabel),
                      commonTextFieldSmallGap(),
                      CommonTextField(
                        controller: controller.timeCtrl,
                        hintText: AppStrings.selectTimeHint,
                        readOnly: true,
                        onTap: () => controller.showIosTimePicker(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            commonTextFieldLargeGap(),
            regularText(AppStrings.eventDescLabel),
            commonTextFieldSmallGap(),
            CommonTextField(
              controller: controller.descCtrl,
              textCapitalization: TextCapitalization.sentences,
              hintText: AppStrings.eventDescLabel,
              maxLines: 4,
            ),
            commonTextFieldLargeGap(),

            regularText(AppStrings.eventImagesLabel),
            commonTextFieldSmallGap(),

            Obx(() {
              final canAdd = controller.totalImages < 5;
              return Row(
                children: [
                  if (canAdd)
                    GestureDetector(
                      onTap: () {
                        showImageSourceSheet(
                          onImageSelected: (source) => controller.pickImage(source),
                        );
                      },
                      child: Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: MyColors.baseColor),
                        ),
                        child: const Icon(Icons.add, color: MyColors.baseColor, size: 30),
                      ),
                    ),
                  if (canAdd) const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...List.generate(
                            controller.networkImages.length,
                                (index) => imageItem(
                              image: NetworkImage(controller.networkImages[index]),
                              onRemove: () => controller.removeNetworkImage(index),
                            ),
                          ),
                          ...List.generate(
                            controller.webImages.length,
                                (index) => imageItem(
                              image: MemoryImage(controller.webImages[index]),
                              onRemove: () => controller.removeWebImage(index),
                            ),
                          ),
                          ...List.generate(
                            controller.selectedImages.length,
                                (index) => imageItem(
                              image: FileImage(controller.selectedImages[index]),
                              onRemove: () => controller.removeLocalImage(index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),

            commonButtonGap(),

            CommonButton(
              title: widget.isEdit ? AppStrings.updateEvent : AppStrings.createEvent,
              onTap: () {
                if(controller.validate()){
                  widget.isEdit
                      ? controller.updateEvent(widget.event!, context)
                      : controller.addEvent(context);
                }

               /* if(controller.validate()){
                  widget.isEdit
                      ? controller.updateEvent(widget.event!, context)
                      : controller.addEvent(context);
                }*/
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget imageItem({required ImageProvider image, required VoidCallback onRemove}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            image: DecorationImage(image: image, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 4,
          right: 14,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}