import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../models/business_model.dart';
import '../models/my_business_model.dart';
import '../models/user_model.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';

class BusinessController extends GetxController {
  RxList<BusinessModel> allBusinesses = <BusinessModel>[].obs;
  RxList<BusinessModel> myBusinesses = <BusinessModel>[].obs;

  RxList<BusinessModel> filteredMyBusinesses = <BusinessModel>[].obs;
  RxList<BusinessModel> filteredBusinesses = <BusinessModel>[].obs;

  final searchCtrl = TextEditingController();
  final searchAllCtrl = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
 //   loadBusinesses();

    searchCtrl.addListener(() {

      filterMyBusinesses(searchCtrl.text);
    });

    searchAllCtrl.addListener(() {

      filterAllBusinesses(searchAllCtrl.text);
    });

  }

  void loadBusinesses() async {
    allBusinesses.assignAll([
      BusinessModel(
        id: 1,
        businessName: "Adult Dance Classes",
        category: "Cafe",
        description: "Best coffee in town",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: 'https://cafemocha.com',
      ),
      BusinessModel(
        id: 1,
        businessName: "Music Classes",
        category: "Cafe",
        description: "Best coffee in town",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: 'https://cafemocha.com',
      ),
      BusinessModel(
        id: 2,
        businessName: "Aerobics Classes",
        category: "Fitness",
        description: "Premium fitness center",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: "https://cafemocha.com",
      ),
      BusinessModel(
        id: 2,
        businessName: "Yuma Coaching Classes",
        category: "Fitness",
        description: "Premium fitness center",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: "https://cafemocha.com",
      ),
    ]);
    filteredBusinesses.assignAll(allBusinesses);
  /*  allBusinesses.clear();
    try {
      isLoading.value = true;
      BusinessResponseModel response = await ApiService().fetchAllBusinesses();

      if (response.status == 1 && response.allBusinesses != null) {
        isLoading.value = false;
        allBusinesses.assignAll(response.allBusinesses!);
        filteredBusinesses.assignAll(allBusinesses);
      }else{
        isLoading.value = false;
        showCommonSnackbar(title: "Error", message: response.message!);
      }
    } catch (e) {
      isLoading.value = false;
      print("MyEventsError $e");
      showCommonSnackbar(title: "Error", message: e.toString());
    }*/


  }

  void loadMyBusiness() async {
    myBusinesses.clear();
    myBusinesses.assignAll([
      BusinessModel(
        id: 1,
        businessName: "Adult Dance Classes",
        category: "Cafe",
        description: "Best coffee in town",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: 'https://cafemocha.com',
      ),
      BusinessModel(
        id: 1,
        businessName: "Music Classes",
        category: "Cafe",
        description: "Best coffee in town",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 0,
        webLink: 'https://cafemocha.com',
      ),
      BusinessModel(
        id: 2,
        businessName: "Aerobics Classes",
        category: "Fitness",
        description: "Premium fitness center",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 2,
        webLink: "https://cafemocha.com",
      ),
      BusinessModel(
        id: 2,
        businessName: "Yuma Coaching Classes",
        category: "Fitness",
        description: "Premium fitness center",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: "https://cafemocha.com",
      ),
    ]);
    filteredMyBusinesses.assignAll(myBusinesses);
/*    try {
      isLoading.value = true;
      MyBusinessResponseModel response = await ApiService().fetcMyBusinesses();

      if (response.status == 1 && response.allBusinesses != null) {
        isLoading.value = false;
        myBusinesses.assignAll(response.allBusinesses!);
        filteredMyBusinesses.assignAll(myBusinesses);
      }else{
        isLoading.value = false;
        showCommonSnackbar(title: "Error", message: response.message!);
      }
    } catch (e) {
      isLoading.value = false;
      print("MyEventsError $e");
      showCommonSnackbar(title: "Error", message: e.toString());
    }*/
  }

  void filterMyBusinesses(String query) {
    if (query.isEmpty) {
      filteredMyBusinesses.assignAll(myBusinesses);
    } else {
      filteredMyBusinesses.assignAll(
        myBusinesses.where(
              (e) =>
          e.businessName!.toLowerCase().contains(query.toLowerCase()) ||
          e.city!.toLowerCase().contains(query.toLowerCase()) ||
          e.country!.toLowerCase().contains(query.toLowerCase()) ||
          e.description!.toLowerCase().contains(query.toLowerCase()) ||
              e.address!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void filterAllBusinesses(String query) {
    if (query.isEmpty) {
      filteredBusinesses.assignAll(allBusinesses);
    } else {
      filteredBusinesses.assignAll(
        allBusinesses.where(
              (e) =>
              e.businessName!.toLowerCase().contains(query.toLowerCase()) ||
                  e.city!.toLowerCase().contains(query.toLowerCase()) ||
                  e.country!.toLowerCase().contains(query.toLowerCase()) ||
                  e.description!.toLowerCase().contains(query.toLowerCase()) ||
                  e.address!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void deleteBusiness(BusinessModel business) async{
    myBusinesses.remove(business);
    filteredMyBusinesses.remove(business);
   /* try {
      // 1. Loading dikhao
      MyProgressBar.showLoadingDialog(context: Get.context!);

      UserModel response = await ApiService().removeBusinessApi(business.id!);

      // 2. Loading band karo
      MyProgressBar.hideLoadingDialog(context: Get.context!);

      if (response.status == 1) {
        // ✅ Success Message
        showCommonSnackbar(
            title: "Success",
            message: response.message ?? "Event removed successfully"
        );
        myBusinesses.remove(business);
        filteredMyBusinesses.remove(business);
      } else {
        // ❌ Backend Error Message
        showCommonSnackbar(
            title: "Error",
            message: response.message ?? "Failed to remove event"
        );
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Error", message: e.toString());
    }*/
  }

  String statusText(int status) {
    switch (status) {
      case 1:
        return AppStrings.approved;
      case 2:
        return AppStrings.rejected;
      default:
        return AppStrings.pending;
    }
  }

  Color statusColor(int status) {
    switch (status) {
      case 1:
        return MyColors.green;
      case 2:
        return MyColors.red;
      default:
        return MyColors.orange;
    }
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}
