import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefix;
  final TextInputType keyboardType;
  final int? maxLength;
  final bool readOnly; // Name change for clarity
  final VoidCallback? onTap; // 👈 Naya onTap callback
  final int? maxLines;
  final TextCapitalization textCapitalization;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefix,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.readOnly = false, // Default keyboard khulega
    this.onTap,
    this.maxLines =1,// 👈 Initialized here
    this.textCapitalization = TextCapitalization.none
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      readOnly: readOnly, // Agar true hai toh sirf onTap chalega
      onTap: onTap, // 👈 TextField ke onTap se connect kiya
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: MyColors.black,
        fontFamily: "regular",
      ),
      decoration: InputDecoration(
        counterText: "",
        hintText: hintText,
        filled: true,
        fillColor: MyColors.white,
        prefixIcon: prefix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
        ),
      ),
    );
  }
}