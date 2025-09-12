import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String hint,
  required String label,
  bool obscure = false,
  TextInputType textInputType = TextInputType.text,
  required Color borderGrey,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: textInputType,
        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: ColorConfig.borderGrey,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderGrey, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.green.shade700, width: 1.5),
          ),
        ),
      ),
    ],
  );
}
