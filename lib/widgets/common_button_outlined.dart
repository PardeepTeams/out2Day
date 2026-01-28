import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CommonButtonOutline extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  const CommonButtonOutline({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: MyColors.white, // White Fill
          side: const BorderSide(color: MyColors.black, width: 1.5), // Black Border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: MyColors.black,
          ),
        )
            : Text(
          title,
          style: const TextStyle(
            color: MyColors.black, // Black Text
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "semibold",
          ),
        ),
      ),
    );
  }
}