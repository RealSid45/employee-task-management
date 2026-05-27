import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isPassword;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
    );
  }
}
