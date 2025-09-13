
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/core/utils/date_convert.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';
import 'package:noviindus_task/domain/entities/branch.dart';
import 'package:noviindus_task/presentation/providers/treatment_provider.dart';
import 'package:noviindus_task/presentation/providers/branch_provider.dart';
import 'package:noviindus_task/presentation/providers/register_provider.dart';
import 'package:noviindus_task/presentation/providers/patient_provider.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/drop_down_field.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/payment_option_widget.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/text_form_field.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/time_selecter.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/treatment_dialog.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/treatment_widget.dart';
import 'package:noviindus_task/presentation/ui/register_patient_screen/widgets/send_data_to_generate_pdf.dart';

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
  final TextEditingController balanceController = TextEditingController();

  String treatmentHour = "0";
  String treatmentMin = "0";
  final List<String> locations = ['Center A', 'Center B', 'Center C'];
  String? selectedLocation;

  Branch? selectedBranch;

  final Map<int, TreatmentCounts> selectedTreatments = {};
  bool initialLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadInitial());

    
    totalController.addListener(updateBalance);
    discountController.addListener(updateBalance);
    advanceController.addListener(updateBalance);
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

  void updateBalance() {
    final total = int.tryParse(totalController.text.trim()) ?? 0;
    final disc = int.tryParse(discountController.text.trim()) ?? 0;
    final adv = int.tryParse(advanceController.text.trim()) ?? 0;

    final bal = total - disc - adv;
    balanceController.text = bal.toString(); 
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
    balanceController.dispose();
    dateController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final TreatmentProvider tProv = context.watch<TreatmentProvider>();
    final BranchProvider bProv = context.watch<BranchProvider>();
    final RegisterProvider regProv = context.watch<RegisterProvider>();

    final branches = bProv.branches;
    if (branches.isNotEmpty) syncSelectedBranchInstance(branches);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    onPressed: () => Navigator.pop(context),
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

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    RoundedTextField(
                      controller: nameController,
                      label: 'Name',
                      hint: 'Enter your full name',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    RoundedTextField(
                      controller: executiveController,
                      label: 'Executive',
                      hint: 'Enter executive name',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    RoundedTextField(
                      controller: phoneController,
                      label: 'Whatsapp Number',
                      hint: 'Enter your whatsapp number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    RoundedTextField(
                      controller: addressController,
                      label: 'Address',
                      hint: 'Enter your address',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 14),
                    RoundedDropdownField<String>(
                      label: 'Location',
                      hint: 'Choose preferred location',
                      value: selectedLocation,
                      items: locations
                          .map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => selectedLocation = v ?? locations[0]),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Select a location' : null,
                    ),
                    const SizedBox(height: 14),
                    RoundedDropdownField<Branch>(
                      label: 'Branch',
                      hint: 'Select branch',
                      value: selectedBranch,
                      items: branches
                          .map(
                            (b) =>
                                DropdownMenuItem(value: b, child: Text(b.name)),
                          )
                          .toList(),
                      onChanged: (Branch? b) =>
                          setState(() => selectedBranch = b),
                      validator: (Branch? v) =>
                          v == null ? 'Select branch' : null,
                    ),
                    const SizedBox(height: 16),
                    TreatmentListWidget(
                      selectedTreatments: selectedTreatments,
                      onAdd: () => openTreatmentDialog(),
                      onEdit: (id) async {
                        final tProv = context.read<TreatmentProvider>();
                        final result = await showTreatmentDialog(
                          context: context,
                          treatments: tProv.treatments,
                          initialTreatmentId: id,
                          initialMale: selectedTreatments[id]?.male ?? 0,
                          initialFemale: selectedTreatments[id]?.female ?? 0,
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
                    RoundedTextField(
                      controller: totalController,
                      label: 'Total Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    RoundedTextField(
                      controller: discountController,
                      label: 'Discount Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    const PaymentOptionWidget(),
                    const SizedBox(height: 16),
                    RoundedTextField(
                      controller: advanceController,
                      label: 'Advance Amount',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    RoundedTextField(
                      controller: balanceController,
                      label: 'Balance Amount',

                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    RoundedTextField(
                      controller: dateController,
                      label: 'Appointment Date',
                      isDate: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Please pick a date' : null,
                    ),
                    const SizedBox(height: 18),
                    TreatmentTimePicker(
                      onChanged: (h, m) {
                        treatmentHour = h.toString();
                        treatmentMin = m.toString();
                      },
                    ),
                    const SizedBox(height: 18),
                    regProv.status == SubmitStatus.submitting
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: SizeConfig.screenWidth,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                final success = await handleRegisterSave(
                                  context: context,
                                  formKey: formKey,
                                  nameController: nameController,
                                  executiveController: executiveController,
                                  paymentController: paymentController,
                                  phoneController: phoneController,
                                  addressController: addressController,
                                  totalController: totalController,
                                  dateController: dateController,
                                  balanceController: balanceController,
                                  discountController: discountController,
                                  advanceController: advanceController,
                                  selectedTreatments: selectedTreatments,
                                  selectedBranch: selectedBranch,
                                  selectedLocation: selectedLocation,
                                  treatmentHour: treatmentHour,
                                  treatmentMin: treatmentMin,
                                  suggestedFileNamePrefix: 'invoice',
                                );
                                if (!success) {}
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                  color: ColorConfig.textWhite,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
