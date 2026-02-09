import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/views/business/add_business_screen.dart';
import 'package:Out2Do/views/events/add_edit_event_screen.dart';
import 'package:Out2Do/views/events/events_listings.dart';
import 'package:Out2Do/views/events/my_events_listing_screen.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:Out2Do/widgets/common_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/events_controller.dart';
import '../../controller/my_events_controller.dart';
import '../../utils/colors.dart';


class EventsTabScreen extends StatefulWidget {
  const EventsTabScreen({super.key});

  @override
  State<EventsTabScreen> createState() => _EventsTabScreenState();
}

class _EventsTabScreenState extends State<EventsTabScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<bool> showSearch = ValueNotifier(false);
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 1. 🚀 First Time Load (By default 0 index)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<EventsController>()) {
        Get.find<EventsController>().loadEvents(false);
      }
    });

    // 2. 🔄 Tab Switch Listener
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          Get.find<EventsController>().loadEvents(false);
        } else {
          // My Events Controller register hona zaroori hai
          Get.find<MyEventsController>().loadMyEvents(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonHomeAppBar(),
      body: Column(
        children: [
          _buildTabs(),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController, // 🔥 Apna controller pass karo
              children: [
                EventsListingScreen(),
                MyEventsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: MyColors.filledGrey,
        ),
        padding: const EdgeInsets.all(5),
        child: AnimatedBuilder(
          animation: _tabController,
          builder: (_, __) {
            return Row(
              children: [
                _tabItem(
                  title: "Explore",
                  isSelected: _tabController.index == 0,
                  onTap: () => _tabController.animateTo(0),
                ),
                const SizedBox(width: 8),
                _tabItem(
                  title: "My Events",
                  isSelected: _tabController.index == 1,
                  onTap: () => _tabController.animateTo(1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _tabItem({required String title, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "regular",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? MyColors.baseColor : MyColors.greyText2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

