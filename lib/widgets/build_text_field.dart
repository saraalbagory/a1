import 'package:flutter/material.dart';

class BuildTextField extends StatelessWidget {
  BuildTextField(TextEditingController confirmPasswordController, {
    super.key,
    required this.controller,
    required this.label,
    required this.errorMessage,
    this.isPassword = false,
    this.validator,
  });
  TextEditingController controller;
  String label;
  String errorMessage;
  bool isPassword = false;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: isPassword,
      validator: validator ?? (value) => value!.isEmpty ? errorMessage : null,
    );
  }
}
