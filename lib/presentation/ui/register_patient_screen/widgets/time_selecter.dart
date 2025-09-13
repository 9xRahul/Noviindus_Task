import 'package:flutter/material.dart';

class TreatmentTimePicker extends StatefulWidget {
  final void Function(int hour, int minute)? onChanged;

  const TreatmentTimePicker({Key? key, this.onChanged}) : super(key: key);

  @override
  State<TreatmentTimePicker> createState() => _TreatmentTimePickerState();
}

class _TreatmentTimePickerState extends State<TreatmentTimePicker> {
  int? selectedHour;
  int? selectedMinute;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);
    final fill = Colors.grey.shade100;
    final borderColor = Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatment Time',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: borderRadius,
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: DropdownButtonFormField<int>(
                  value: selectedHour,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  hint: const Text('Hour'),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  items: List.generate(12, (i) {
                    final h = i + 1;
                    return DropdownMenuItem(
                      value: h,
                      child: Text(h.toString()),
                    );
                  }),
                  onChanged: (val) {
                    setState(() => selectedHour = val);
                    if (val != null && selectedMinute != null) {
                      widget.onChanged?.call(selectedHour!, selectedMinute!);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: borderRadius,
                  border: Border.all(color: borderColor),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: DropdownButtonFormField<int>(
                  value: selectedMinute,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  hint: const Text('Minutes'),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.green,
                  ),
                  items: List.generate(60, (i) {
                    return DropdownMenuItem(
                      value: i,
                      child: Text(i.toString().padLeft(2, '0')),
                    );
                  }),
                  onChanged: (val) {
                    setState(() => selectedMinute = val);
                    if (selectedHour != null && val != null) {
                      widget.onChanged?.call(selectedHour!, selectedMinute!);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
