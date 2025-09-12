import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/drop_down_field.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/payment_option_widget.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/text_form_field.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/time_selecter.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/treatment_dialog.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/treatment_widget.dart';

import 'package:provider/provider.dart';
import 'package:noviindus_task/core/utils/date_convert.dart';

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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController executiveController = TextEditingController();
  final TextEditingController paymentController = TextEditingController(
    text: 'Cash',
  );
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController discountController = TextEditingController(
    text: '0',
  );
  final TextEditingController advanceController = TextEditingController(
    text: '0',
  );

  final List<String> locations = ['Center A', 'Center B', 'Center C'];
  String? selectedLocation;

  Branch? selectedBranch;

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

    final Color background = Theme.of(context).scaffoldBackgroundColor;
    final Color cardColor = Colors.white;
    final BorderRadius cardRadius = BorderRadius.circular(16);
    final BoxShadow cardShadow = BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: SizeConfig.screenHeight / 12),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: ColorConfig.iconColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Icon(
                    Icons.notifications_none_outlined,
                    color: ColorConfig.iconColor,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),

            const Divider(height: 1),

            SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        RoundedTextField(
                          controller: nameController,
                          label: 'Name',
                          hint: 'Enter Your full name',
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 10),

                        RoundedTextField(
                          controller: executiveController,
                          label: 'Whatsapp Number',
                          hint: 'Enter you whatsapp number',
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 10),
                        RoundedTextField(
                          controller: addressController,
                          label: 'Address',
                          hint: 'Enter Your address',
                          keyboardType: TextInputType.text,
                        ),

                        const SizedBox(height: 14),

                        RoundedDropdownField<String>(
                          label: 'Location ',
                          hint: 'Choose preferred location',
                          value: selectedLocation,
                          items: locations
                              .map(
                                (l) =>
                                    DropdownMenuItem(value: l, child: Text(l)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedLocation = v),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Select a location'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        RoundedDropdownField<Branch>(
                          label: 'Branch',
                          hint: 'Select branch',
                          value: selectedBranch,
                          items: branches.map((b) {
                            return DropdownMenuItem<Branch>(
                              value: b,
                              child: Text(b.name),
                            );
                          }).toList(),
                          onChanged: (Branch? b) =>
                              setState(() => selectedBranch = b),
                          validator: (Branch? v) =>
                              v == null ? 'Select branch' : null,
                        ),
                        const SizedBox(height: 16),

                        TreatmentListWidget(
                          selectedTreatments: selectedTreatments,
                          onAdd: () => openTreatmentDialog(),
                          onEdit: (treatmentId) async {
                            final tProv = context.read<TreatmentProvider>();
                            final result = await showTreatmentDialog(
                              context: context,
                              treatments: tProv.treatments,
                              initialTreatmentId: treatmentId,
                              initialMale:
                                  selectedTreatments[treatmentId]?.male ?? 0,
                              initialFemale:
                                  selectedTreatments[treatmentId]?.female ?? 0,
                            );
                            if (result != null) {
                              setState(() {
                                selectedTreatments[result.treatment.id] =
                                    TreatmentCounts(
                                      treatment: result.treatment,
                                      male: result.maleCount,
                                      female: result.femaleCount,
                                    );
                              });
                            }
                          },
                          onRemove: (id) =>
                              setState(() => selectedTreatments.remove(id)),
                        ),

                        const SizedBox(height: 16),
                        const PaymentOptionWidget(),
                        const SizedBox(height: 16),
                        RoundedTextField(
                          controller: addressController,
                          label: 'Advance Amount',
                          hint: '',
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 16),
                        RoundedTextField(
                          controller: addressController,
                          label: 'Balance Amount',
                          hint: '',
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 12),

                        RoundedTextField(
                          controller: dateController,
                          label: 'Appointment Date',
                          hint: '',
                          isDate: true,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Please pick a date'
                              : null,
                        ),

                        const SizedBox(height: 18),
                        TreatmentTimePicker(
                          onChanged: (hour, minute) {
                            print('Selected: $hour:$minute');
                          },
                        ),

                        const SizedBox(height: 18),

                        regProv.status == SubmitStatus.submitting
                            ? const Center(child: CircularProgressIndicator())
                            : Container(
                                padding: const EdgeInsets.all(12),
                                color: Colors.white,
                                child: SizedBox(
                                  height: 52,
                                  width: SizeConfig.screenWidth,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green[800],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPatientScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Register Now',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: ColorConfig.textWhite,
                                      ),
                                    ),
                                  ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
