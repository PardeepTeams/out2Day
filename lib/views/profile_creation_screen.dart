import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../utils/app_strings.dart';
import '../utils/colors.dart';
import '../utils/common_styles.dart';
import '../utils/google_web_autocomplete.dart';
import '../utils/location_delegate.dart';
import '../widgets/common_button.dart';
import '../widgets/common_text_field.dart';
import '../controller/profile_creation_controller.dart';

class ProfileCreationScreen extends StatelessWidget {
  ProfileCreationScreen({super.key});

  final ProfileCreationController controller = Get.put(
    ProfileCreationController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.currentStep.value == 0 && controller.isEdit,
        onPopInvokedWithResult: (canpop, result) {
          if (canpop) return;
          if (controller.currentStep == 0) {
            if (controller.isEdit) {
              Get.back();
            } else {
              exit(0);
            }
          } else {
            controller.previousStep();
          }
        },
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: MyColors.white,
            title: SvgPicture.asset("assets/logo_outdo.svg", width: 120),
            leading: controller.isEdit
                ? InkWell(
                    onTap: () {
                      if (controller.currentStep == 0) {
                        if (controller.isEdit) {
                          Get.back();
                        } else {
                          exit(0);
                        }
                      } else {
                        controller.previousStep();
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: MyColors.baseColor,
                    ),
                  )
                : null,
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColors.gradient1, MyColors.gradient2],

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller.pageScrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topStepper(),
                          Obx(() {
                            switch (controller.currentStep.value) {
                              case 0:
                                return _stepOne(context);
                              case 1:
                                return _stepTwo(context);
                              case 2:
                                return _stepThree(context);
                              default:
                                return const SizedBox();
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () =>
                          _bottomNav(isLast: controller.currentStep.value == 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Refactored Option Widget for better alignment
  Widget _genderOption(
    String title,
    IconData icon,
    ProfileCreationController controller,
    int index,
  ) {
    final isSelected = controller.genderIndex.value == index;
    return _baseSelectableCard(
      title,
      icon,
      isSelected,
      () => controller.genderIndex.value = index,
    );
  }

  Widget _customSelectableOption(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return _baseSelectableCard(title, icon, isSelected, onTap);
  }

  // Common UI for both Gender and Preference buttons
  Widget _baseSelectableCard(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? MyColors.baseColor : MyColors.white,
          border: Border.all(color: MyColors.borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? MyColors.white : MyColors.baseColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "regular",
                color: isSelected ? MyColors.white : MyColors.baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 STEP 3 – LOCATION & ETHNICITY (Updated Part)
  /// 🔹 STEP 2 – LOCATION & ETHNICITY (Fixed Version)
  Widget _stepTwo(BuildContext context) {
    // Screen width nikaalo taaki constraints sahi rahan
    double screenWidth = MediaQuery.of(context).size.width; // 32 padding hai

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(AppStrings.basicDetails),
        commonTextFieldSmallGap(),
        kIsWeb?
        GoogleWebAutocomplete(
          controller: controller.locationController,
          onSelected: (placeDescription, placeId) {;
            LocationDelegate().getDetails(placeId, controller);
          },  hint: AppStrings.locationLabel,
        ):
        googlePlacesTextField(
                controller: controller.locationController,
                hint: AppStrings.locationLabel,
                onLocationClick: (Prediction p1) {
                  FocusScope.of(context).unfocus();
                  dismissKeyboard(context);
                  controller.getLocationDetails(p1);
                }, // 👈 Updated
              ),
        commonTextFieldLargeGap(),
        mediumText(AppStrings.interestedInLabel, MyColors.black),
        commonTextFieldSmallGap(),

        // ✅ FIX: Row nu Container naal wrap karo aur width duso
        SizedBox(
          width: screenWidth,
          child: Obx(() {
            final preferenceList = controller.availablePreferences;

            return Row(
              children: preferenceList.asMap().entries.map((entry) {
                final index = entry.key;
                final preference = entry.value;

                final value = preference
                    .toLowerCase(); // 🔥 single source of truth
                final isSelected = controller.selectedPreferences.contains(
                  value,
                );
                final isLastItem = index == preferenceList.length - 1;

                final IconData icon = preference == AppStrings.male
                    ? Icons.male
                    : preference == AppStrings.female
                    ? Icons.female
                    : Icons.transgender;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: isLastItem ? 0.0 : 8.0),
                    child: _customSelectableOption(
                      preference, // UI text
                      icon,
                      isSelected,
                      () {
                        dismissKeyboard(context);
                        controller.togglePreference(value); // 🔥 lowercase only
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),

        commonTextFieldLargeGap(),
        mediumText(AppStrings.ethnicityLabel, MyColors.black),
        commonTextFieldSmallGap(),

        /// --- Ethnicity API UI ---
        Obx(() {
          if (controller.isEthnicityLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.baseColor),
            );
          }
          // ... (rest of your ethnicity logic)
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.ethnicityList.map((ethnicity) {
              final isSelected =
                  controller.selectedEthnicity.value == ethnicity.name;
              return InkWell(
                onTap: () {
                  if (ethnicity.name == "Other") {
                    controller.isOtherEthnicitySelected.value = true;
                    controller.selectedEthnicity.value = "Other";
                  } else {
                    controller.isOtherEthnicitySelected.value = false;
                    controller.otherEthnicityController.clear();
                    controller.selectedEthnicity.value = ethnicity.name ?? "";
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? MyColors.baseColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.borderColor),
                  ),
                  child: Text(
                    ethnicity.name ?? "",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : MyColors.baseColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
        commonTextFieldLargeGap(),
        Obx(() {
          if (!controller.isOtherEthnicitySelected.value) {
            return const SizedBox();
          }

          return CommonTextField(
            controller: controller.otherEthnicityController,
            hintText: AppStrings.ethnicityLabel,
            textCapitalization: TextCapitalization.words,
          );
        }),

        commonButtonGap(),
      ],
    );
  }

  /// 🔹 STEP 3 – LIFESTYLE
  Widget _stepThree(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(AppStrings.lifeStyles),
        commonTextFieldLargeGap(),
        mediumText(AppStrings.professionLabel, MyColors.black),
        commonTextFieldSmallGap(),
        Obx(() {
          if (controller.isProfessionLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.professionList.isEmpty) {
            return TextButton(
              onPressed: () => controller.getProfessions(),
              child: const Text("Retry loading professions"),
            );
          }
          // Mapping List<Profession> to Chips
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.professionList.map((profession) {
              final isSelected =
                  controller.selectedProfession.value == profession.name;
              return InkWell(
                onTap: () {
                  if (profession.name == "Other") {
                    controller.isOtherProfessionSelected.value = true;
                    controller.selectedProfession.value = "Other";
                  } else {
                    controller.isOtherProfessionSelected.value = false;
                    controller.otherProfessionController.clear();
                    controller.selectedProfession.value = profession.name ?? "";
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? MyColors.baseColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.borderColor),
                  ),
                  child: Text(
                    profession.name ?? "",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : MyColors.baseColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        commonTextFieldLargeGap(),

        mediumText(AppStrings.hobby, MyColors.black),
        commonTextFieldSmallGap(),

        /// --- Hobbies Multi-Select Chips ---
        Obx(() {
          if (controller.isHobbyLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: MyColors.baseColor),
            );
          }

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.hobbyList.map((hobby) {
              // 🔹 Check karo ki ki eh hobby selected list vich hai
              final isSelected =
                  controller.selectedHobbies.contains(hobby.name) ||
                  (hobby.name == "Other" &&
                      controller.isOtherHobbySelected.value);

              return InkWell(
                onTap: () => controller.toggleHobby(hobby.name ?? ""),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    // 🔹 Selected hon te color baseColor ho jayega
                    color: isSelected ? MyColors.baseColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: MyColors.borderColor),
                  ),
                  child: Text(
                    hobby.name ?? "",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isSelected ? Colors.white : MyColors.baseColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),

        // Other Hobby Input
        Obx(() {
          if (!controller.isOtherHobbySelected.value) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CommonTextField(
              controller: controller.otherHobbyController,
              hintText: "Enter your hobby",
              textCapitalization: TextCapitalization.words,
            ),
          );
        }),

        commonTextFieldLargeGap(),
        Obx(() {
          if (!controller.isOtherProfessionSelected.value) {
            return const SizedBox();
          }

          return CommonTextField(
            controller: controller.otherProfessionController,
            hintText: AppStrings.professionLabel,
            textCapitalization: TextCapitalization.words,
          );
        }),

        commonTextFieldLargeGap(),
        mediumText(AppStrings.drinking, MyColors.black),
        commonTextFieldSmallGap(),
        _chipGroup(controller.drinkingChips, controller.selectedDrinking),

        commonTextFieldLargeGap(),
        mediumText(AppStrings.smoking, MyColors.black),
        commonTextFieldSmallGap(),
        _chipGroup(controller.smokingChips, controller.selectedSmoking),

        commonButtonGap(),
      ],
    );
  }

  /// 🔹 CHIP GROUP
  Widget _chipGroup(List<String> items, RxString selectedValue) {
    return Obx(
      () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) {
          final isSelected = selectedValue.value == item;
          return InkWell(
            onTap: () => selectedValue.value = item,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? MyColors.baseColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: MyColors.borderColor),
              ),
              child: Text(
                item,
                style: TextStyle(
                  fontFamily: "regular",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white : MyColors.baseColor,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _bottomNav({bool isLast = false}) {
    return Obx(() {
      final step = controller.currentStep.value;

      // 🔹 STEP 0 → FULL WIDTH BUTTON
      if (step == 0) {
        return _primaryButton(AppStrings.next, () {
          controller.nextStep();
        });
      }

      // 🔹 STEP 1 & 2 → BACK + FIXED WIDTH BUTTON
      return Row(
        children: [
          /// BACK BUTTON
          GestureDetector(
            onTap: controller.previousStep,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: Colors.black,
              ),
            ),
          ),

          const Spacer(),

          /// NEXT / FINISH BUTTON
          SizedBox(
            width: 160,
            child: _primaryButton(
              isLast ? AppStrings.btnSubmit : AppStrings.next,
              () {
                if (isLast) {
                  controller.submitProfile(Get.context!);
                } else {
                  controller.nextStep();
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _primaryButton(String title, VoidCallback onTap) {
    return CommonButton(
      title: title,
      onTap: onTap,
      isLoading: controller.isLoading.value,
    );
  }

  Widget _topStepper() {
    return Obx(() {
      int currentStep = controller.currentStep.value;
      int totalSteps = 3;

      return currentStep != 0
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSteps, (index) {
                  bool isCompleted = index < currentStep;
                  bool isActive = index == currentStep;
                  bool isLast = index == totalSteps - 1;

                  return Expanded(
                    flex: isLast
                        ? 0
                        : 1, // Last circle de baad line nahi chahidi
                    child: Row(
                      children: [
                        // 🔹 Circle (Step Indicator)
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? MyColors.black
                                : MyColors.white,
                            border: Border.all(
                              color: isCompleted
                                  ? MyColors.black
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ) // Completed Step
                                : Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive
                                          ? MyColors.black
                                          : Colors
                                                .grey
                                                .shade400, // Active vs Pending dot
                                    ),
                                  ),
                          ),
                        ),

                        // 🔹 Line Connector (Sirf last step ton pehla dikhega)
                        if (!isLast)
                          Expanded(
                            child: Container(
                              height: 2,
                              color: isCompleted
                                  ? MyColors.black
                                  : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            )
          : SizedBox();
    });
  }

  /// 🔹 COMMON UI
  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: "semibold",
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: MyColors.black,
      ),
    );
  }

  /// 🔹 STEP 1 – BASIC INFO
  Widget _stepOne(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: semiboldTextLarge(
            controller.isEdit
                ? AppStrings.editProfile
                : AppStrings.createProfile,
          ),
        ),

        SizedBox(height: 5),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: regularText(AppStrings.fillDetails),
        ),
        const SizedBox(height: 20),

        /// 🔥 PROFILE IMAGE PICKER
        Obx(() {
          ImageProvider? imageProvider;

          // 1️⃣ Web picked image
          if (kIsWeb && controller.webImage.value != null) {
            imageProvider = MemoryImage(controller.webImage.value!);
          }
          // 2️⃣ Mobile picked image
          else if (!kIsWeb && controller.profileImage.value != null) {
            imageProvider = FileImage(controller.profileImage.value!);
          }
          // 3️⃣ Existing network image (Edit mode)
          else if (controller.profileImageUrl.value.isNotEmpty) {
            imageProvider = NetworkImage(controller.profileImageUrl.value);
          }

          return GestureDetector(
            onTap: () {
              dismissKeyboard(context);
              showImageSourceSheet(
                onImageSelected: (source) => controller.pickImage(source),
              );
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: MyColors.greyFilled2,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? const Icon(
                          Icons.person,
                          size: 50,
                          color: MyColors.grey4,
                        )
                      : null,
                ),

                /// 📷 Camera Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: MyColors.baseColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: MyColors.white,
                  ),
                ),
              ],
            ),
          );
        }),

        commonTextFieldLargeGap(),

        CommonTextField(
          controller: controller.nameController,
          hintText: AppStrings.nameHint,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
        ),
        commonTextFieldLargeGap(),
        CommonTextField(
          controller: controller.lastNameController,
          hintText: AppStrings.lastNameHint,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
        ),
        commonTextFieldLargeGap(),
        CommonTextField(
          controller: controller.emailController,
          hintText: AppStrings.emailHint,
          keyboardType: TextInputType.emailAddress,
          readOnly: controller.isEdit,
        ),
        commonTextFieldLargeGap(),
        CommonTextField(
          controller: controller.dobController,
          hintText: AppStrings.dobHint,
          readOnly: true,
          onTap: () {
            controller.showIosDatePicker(context);
          },
        ),
        commonTextFieldLargeGap(),
        Align(
          alignment: Alignment.centerLeft,
          child: mediumText(AppStrings.genderLabel, MyColors.black),
        ),
        commonTextFieldSmallGap(),
        Obx(
          () => Row(
            children: [
              Expanded(
                child: _genderOption(
                  AppStrings.male,
                  Icons.male,
                  controller,
                  0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _genderOption(
                  AppStrings.female,
                  Icons.female,
                  controller,
                  1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _genderOption(
                  AppStrings.other,
                  Icons.transgender,
                  controller,
                  2,
                ),
              ),
            ],
          ),
        ),
        commonTextFieldLargeGap(),
        CommonTextField(
          controller: controller.aboutController,
          hintText: AppStrings.aboutHint,
          maxLines: 4,
          //   keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.words,
        ),
        commonButtonGap(),
      ],
    );
  }
}
