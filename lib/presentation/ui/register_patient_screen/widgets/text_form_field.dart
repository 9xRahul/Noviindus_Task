import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noviindus_task/core/color_config.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hint;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool obscureText;

  final bool isDate;

  const RoundedTextField({
    Key? key,
    this.controller,
    this.initialValue,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.obscureText = false,
    this.isDate = false,
  }) : assert(
         controller == null || initialValue == null,
         'Provide controller OR initialValue, not both.',
       ),
       super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && controller != null) {
      controller!.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10.0);
    final fill = Colors.grey.shade100;
    final borderColor = Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          maxLines: maxLines,
          keyboardType: isDate ? TextInputType.none : keyboardType,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 14),
          readOnly: isDate,
          onTap: isDate
              ? () async {
                  await _pickDate(context);
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: fill,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 6.0),
                    child: SizedBox(width: 24, child: prefix),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            suffixIcon: isDate
                ? IconButton(
                    icon: Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: ColorConfig.patientCardGreen,
                    ),
                    onPressed: () => _pickDate(context),
                  )
                : suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 8.0),
                    child: suffix,
                  )
                : null,
            contentPadding: EdgeInsets.symmetric(
              vertical: maxLines > 1 ? 14 : 14,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
