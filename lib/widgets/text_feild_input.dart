import 'package:flutter/material.dart';

class TextFeildInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final int maxLines;
  const TextFeildInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.6)), // Use theme-aware color
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: theme.colorScheme.background, // Use theme-aware color
          border: inputBorder,
          focusedBorder: inputBorder.copyWith(
            borderSide: BorderSide(color: theme.primaryColor), // Use theme-aware color
          ),
          enabledBorder: inputBorder,
          contentPadding: const EdgeInsets.all(12.0),
          prefixIcon: isPass
              ? Icon(Icons.lock, color: theme.colorScheme.onSurface.withOpacity(0.6)) // Use theme-aware color
              : null,
        ),
        keyboardType: textInputType,
        obscureText: isPass,
        maxLines: maxLines,
      ),
    );
  }
}
