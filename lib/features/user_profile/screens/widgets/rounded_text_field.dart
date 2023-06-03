import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  const RoundedTextField({
    super.key,
    required this.controller,
    required this.hintText,
    int? maxLength,
  }) : _maxLength = maxLength;

  final TextEditingController controller;
  final String hintText;
  final int? _maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: _maxLength,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(18.0),
      ),
    );
  }
}
