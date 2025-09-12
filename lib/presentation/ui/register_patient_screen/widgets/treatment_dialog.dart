// lib/widgets/treatment_dialog.dart
import 'package:flutter/material.dart';
import 'package:noviindus_task/data/models/TreatmentModel.dart';

/// Result returned from the dialog
class TreatmentDialogResult {
  final Treatment treatment;
  final int maleCount;
  final int femaleCount;

  TreatmentDialogResult({
    required this.treatment,
    required this.maleCount,
    required this.femaleCount,
  });
}

/// Show a dialog to pick a single Treatment and set male/female counts.
/// Accepts your app's Treatment model (lib/data/models/TreatmentModel.dart).
Future<TreatmentDialogResult?> showTreatmentDialog({
  required BuildContext context,
  required List<Treatment> treatments,
  int initialMale = 0,
  int initialFemale = 0,
  int? initialTreatmentId,
}) {
  return showDialog<TreatmentDialogResult>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: TreatmentDialogContent(
        treatments: treatments,
        initialMale: initialMale,
        initialFemale: initialFemale,
        initialTreatmentId: initialTreatmentId,
      ),
    ),
  );
}

class TreatmentDialogContent extends StatefulWidget {
  final List<Treatment> treatments;
  final int initialMale;
  final int initialFemale;
  final int? initialTreatmentId;

  const TreatmentDialogContent({
    Key? key,
    required this.treatments,
    this.initialMale = 0,
    this.initialFemale = 0,
    this.initialTreatmentId,
  }) : super(key: key);

  @override
  State<TreatmentDialogContent> createState() => _TreatmentDialogContentState();
}

class _TreatmentDialogContentState extends State<TreatmentDialogContent> {
  Treatment? selectedTreatment;
  late int male;
  late int female;
  late TextEditingController maleController;
  late TextEditingController femaleController;

  @override
  void initState() {
    super.initState();

    male = widget.initialMale;
    female = widget.initialFemale;
    maleController = TextEditingController(text: '$male');
    femaleController = TextEditingController(text: '$female');

    if (widget.treatments.isNotEmpty) {
      if (widget.initialTreatmentId != null) {
        selectedTreatment = widget.treatments.firstWhere(
          (t) => t.id == widget.initialTreatmentId,
          orElse: () => widget.treatments.first,
        );
      } else {
        selectedTreatment = widget.treatments.first;
      }
    } else {
      selectedTreatment = null;
    }
  }

  @override
  void dispose() {
    maleController.dispose();
    femaleController.dispose();
    super.dispose();
  }

  void _incMale() {
    setState(() {
      male++;
      maleController.text = '$male';
    });
  }

  void _decMale() {
    setState(() {
      if (male > 0) male--;
      maleController.text = '$male';
    });
  }

  void _incFemale() {
    setState(() {
      female++;
      femaleController.text = '$female';
    });
  }

  void _decFemale() {
    setState(() {
      if (female > 0) female--;
      femaleController.text = '$female';
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color green = const Color(0xFF0B6A3E);
    final Color borderGrey = Colors.grey.shade300;
    final Color lightGrey = Colors.grey.shade100;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose Treatment',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderGrey),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<Treatment>(
                value: selectedTreatment,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                icon: Icon(Icons.keyboard_arrow_down, color: green),
                onChanged: (val) => setState(() => selectedTreatment = val),
                items: widget.treatments
                    .map(
                      (t) => DropdownMenuItem<Treatment>(
                        value: t,
                        child: Text(t.name),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Patients',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),

            // Male row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderGrey),
                  ),
                  child: const Text('Male'),
                ),
                const SizedBox(width: 16),
                Material(
                  color: green,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _decMale,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 56,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGrey),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: maleController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    onChanged: (s) {
                      final v = int.tryParse(s) ?? 0;
                      setState(() => male = v);
                      maleController.selection = TextSelection.fromPosition(
                        TextPosition(offset: maleController.text.length),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: green,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _incMale,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Female row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderGrey),
                  ),
                  child: const Text('Female'),
                ),
                const SizedBox(width: 16),
                Material(
                  color: green,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _decFemale,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 56,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderGrey),
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: femaleController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    onChanged: (s) {
                      final v = int.tryParse(s) ?? 0;
                      setState(() => female = v);
                      femaleController.selection = TextSelection.fromPosition(
                        TextPosition(offset: femaleController.text.length),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: green,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _incFemale,
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (selectedTreatment == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a treatment'),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop(
                    TreatmentDialogResult(
                      treatment: selectedTreatment!,
                      maleCount: male,
                      femaleCount: female,
                    ),
                  );
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
