// lib/screens/register_patient_screen.dart
import 'package:flutter/material.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/treatment_dialog.dart';

import 'package:provider/provider.dart';
import 'package:noviindus_task/core/utils/date_convert.dart'; // keep if you have format helper

import 'package:noviindus_task/domain/entities/branch.dart';
import 'package:noviindus_task/presentation/providers/treatment_provider.dart';
import 'package:noviindus_task/presentation/providers/branch_provider.dart';
import 'package:noviindus_task/presentation/providers/register_provider.dart';
import 'package:noviindus_task/presentation/providers/patient_provider.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({Key? key}) : super(key: key);

  @override
  State<RegisterPatientScreen> createState() => RegisterPatientScreenState();
}

class RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController executiveController = TextEditingController();
  final TextEditingController paymentController = TextEditingController(
    text: 'Cash',
  );
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController advanceController = TextEditingController(
    text: '0',
  );

  // static locations
  final List<String> locations = ['Center A', 'Center B', 'Center C'];
  String? selectedLocation;

  // branch selection
  Branch? selectedBranch;

  // selected treatments store: key = treatment id
  final Map<int, TreatmentCounts> selectedTreatments = {};

  bool initialLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadInitial());
  }

  Future<void> loadInitial() async {
    if (initialLoaded) return;
    initialLoaded = true;
    final tProv = context.read<TreatmentProvider?>();
    final bProv = context.read<BranchProvider?>();
    try {
      await Future.wait([
        if (tProv != null) tProv.loadTreatments(),
        if (bProv != null) bProv.loadBranches(),
      ]);
      setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    nameController.dispose();
    executiveController.dispose();
    paymentController.dispose();
    phoneController.dispose();
    addressController.dispose();
    totalController.dispose();
    discountController.dispose();
    advanceController.dispose();
    super.dispose();
  }

  String computeBalance() {
    final total = double.tryParse(totalController.text.trim()) ?? 0.0;
    final disc = double.tryParse(discountController.text.trim()) ?? 0.0;
    final adv = double.tryParse(advanceController.text.trim()) ?? 0.0;
    return (total - disc - adv).toStringAsFixed(2);
  }

  void syncSelectedBranchInstance(List<Branch> branches) {
    if (selectedBranch == null) return;
    final match = branches.firstWhere(
      (b) => b.id == selectedBranch!.id,
      orElse: () => branches.first,
    );
    if (!identical(match, selectedBranch)) selectedBranch = match;
  }

  Future<void> openTreatmentDialog() async {
    final tProv = context.read<TreatmentProvider>();
    final treatments = tProv.treatments;
    final result = await showTreatmentDialog(
      context: context,
      treatments: treatments,
    );
    if (result != null) {
      setState(() {
        // replace previous selection of same treatment id (user updated)
        selectedTreatments[result.treatment.id] = TreatmentCounts(
          treatment: result.treatment,
          male: result.maleCount,
          female: result.femaleCount,
        );
      });
    }
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedTreatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one treatment')),
      );
      return;
    }
    if (selectedLocation == null || selectedLocation!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a location')));
      return;
    }

    final regProv = context.read<RegisterProvider>();
    final patientProv = context.read<PatientProvider?>();

    final dateStr = formatDateTimeForApi(DateTime.now());

    final maleIds = <String>[];
    final femaleIds = <String>[];
    selectedTreatments.forEach((id, counts) {
      if (counts.male > 0) maleIds.add(id.toString());
      if (counts.female > 0) femaleIds.add(id.toString());
    });
    final treatmentIds = selectedTreatments.keys
        .map((e) => e.toString())
        .join(',');

    final fields = <String, String>{
      'name': nameController.text.trim(),
      'excecutive': executiveController.text.trim(),
      'payment': paymentController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'total_amount': totalController.text.trim(),
      'discount_amount': discountController.text.trim(),
      'advance_amount': advanceController.text.trim(),
      'balance_amount': computeBalance(),
      'date_nd_time': dateStr,
      'id': '',
      'male': maleIds.join(','),
      'female': femaleIds.join(','),
      'branch': selectedBranch?.id.toString() ?? '',
      'treatments': treatmentIds,
    };

    final ok = await regProv.submit(fields);
    if (ok) {
      try {
        await patientProv?.loadPatients(force: true);
      } catch (_) {}
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registered successfully')));
      Navigator.of(context).pop(true);
    } else {
      final err = regProv.error ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TreatmentProvider tProv = context.watch<TreatmentProvider>();
    final BranchProvider bProv = context.watch<BranchProvider>();
    final RegisterProvider regProv = context.watch<RegisterProvider>();

    final treatments = tProv.treatments;
    final branches = bProv.branches;

    if (branches.isNotEmpty) syncSelectedBranchInstance(branches);

    return Scaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: executiveController,
                decoration: const InputDecoration(labelText: 'Executive'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: paymentController,
                decoration: const InputDecoration(labelText: 'Payment'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              // static location
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Location (static)',
                ),
                value: selectedLocation,
                hint: const Text('Choose preferred location'),
                items: locations
                    .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                    .toList(),
                onChanged: (v) => setState(() => selectedLocation = v),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Select a location' : null,
              ),
              const SizedBox(height: 14),

              // branch dropdown
              if (bProv.loading)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<Branch>(
                  decoration: const InputDecoration(labelText: 'Branch'),
                  value: selectedBranch,
                  hint: const Text('Select branch'),
                  items: branches
                      .map(
                        (b) => DropdownMenuItem(value: b, child: Text(b.name)),
                      )
                      .toList(),
                  onChanged: (b) => setState(() => selectedBranch = b),
                  validator: (v) => v == null ? 'Select branch' : null,
                ),
              if (bProv.error != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Branch load error: ${bProv.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 16),

              // add treatment button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: openTreatmentDialog,
                      icon: const Icon(Icons.medical_services_outlined),
                      label: const Text('Add Treatment'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // chips list
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedTreatments.entries.map((e) {
                  final tc = e.value;
                  return Chip(
                    label: Text(
                      '${tc.treatment.name} (M:${tc.male} F:${tc.female})',
                    ),
                    onDeleted: () =>
                        setState(() => selectedTreatments.remove(e.key)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // financials
              TextFormField(
                controller: totalController,
                decoration: const InputDecoration(labelText: 'Total Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: discountController,
                decoration: const InputDecoration(labelText: 'Discount Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: advanceController,
                decoration: const InputDecoration(labelText: 'Advance Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  const Text(
                    'Balance: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Text(computeBalance()),
                ],
              ),
              const SizedBox(height: 18),

              regProv.status == SubmitStatus.submitting
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Submit & Generate PDF'),
                      ),
                    ),

              if (regProv.status == SubmitStatus.failure &&
                  regProv.error != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Error: ${regProv.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
