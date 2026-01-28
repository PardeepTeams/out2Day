import 'package:flutter/material.dart';

class GoogleWebAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String description, String placeId)? onSelected;

  const GoogleWebAutocomplete({
    required this.controller,
    required this.hint,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Mobile par ye widget hide rahega
  }
}