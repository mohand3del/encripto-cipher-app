import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.maxLine,
      required this.controller,
      this.isOutputField = false, required this.hintText});

  final int maxLine;
  final TextEditingController controller;
  final bool isOutputField;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: isOutputField,
      controller: controller,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color(0xff2E3B45), // Dark background color for the field
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          borderSide: BorderSide.none, // No border outline
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 20.0), // Padding inside the field
      ),
      style: const TextStyle(
        color: Colors.white, // White text color for better contrast
      ),
      maxLines: maxLine, // Allows multiline text input
    );
  }
}
