import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noviindus_task/core/pdf/pdf_helper.dart';
import 'package:noviindus_task/core/utils/date_convert.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';
import 'package:noviindus_task/domain/entities/branch.dart';
import 'package:noviindus_task/presentation/providers/register_provider.dart';
import 'package:provider/provider.dart';

Future<bool> handleRegisterSave({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController nameController,
  required TextEditingController executiveController,
  required TextEditingController paymentController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required TextEditingController totalController,
  required TextEditingController dateController,
  required TextEditingController discountController,
  required TextEditingController advanceController,
  required TextEditingController balanceController,
  required Map<int, TreatmentCounts> selectedTreatments,
  required Branch? selectedBranch,
  required String? selectedLocation,
  required String treatmentHour,
  required String treatmentMin,
  String? suggestedFileNamePrefix,
}) async {
  final messenger = ScaffoldMessenger.of(context);

  
  if (!formKey.currentState!.validate()) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Please fix the errors in the form')),
    );
    return false;
  }
  if (selectedTreatments.isEmpty) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Please add at least one treatment')),
    );
    return false;
  }
  if (selectedLocation == null || selectedLocation.isEmpty) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Please select a location')),
    );
    return false;
  }

  
  final maleIds = <String>[];
  final femaleIds = <String>[];
  selectedTreatments.forEach((id, counts) {
    if (counts.male > 0) maleIds.add(id.toString());
    if (counts.female > 0) femaleIds.add(id.toString());
  });
  final treatmentIds = selectedTreatments.keys
      .map((e) => e.toString())
      .join(',');

  final dateStr = formatDateTimeForApi(DateTime.now());

  
  final Map<String, String> fields = {
    'name': nameController.text.trim(),
    'excecutive': executiveController.text.trim(),
    'payment': paymentController.text.trim(),
    'phone': phoneController.text.trim(),
    'address': addressController.text.trim(),
    'total_amount': totalController.text.trim(),
    'discount_amount': discountController.text.trim(),
    'advance_amount': advanceController.text.trim(),
    'balance_amount': balanceController.text.trim(),
    'date_nd_time': dateStr,
    'bookedon': DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'id': '',
    'male': maleIds.join(','),
    'female': femaleIds.join(','),
    'branch': selectedBranch?.id.toString() ?? '',
    'treatments': treatmentIds,
    'treatmentdate': dateController.text.trim(),
    'hour': treatmentHour,
    'min': treatmentMin,
  };

  try {
    
    final regProv = context.read<RegisterProvider>();
    final ok = await regProv.submit(fields);

    print("Buttonhit");

    if (!ok) {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    
    final List<Map<String, dynamic>> treatments = [];
    selectedTreatments.forEach((id, counts) {
      final tObj = counts.treatment;
      String tName = 'Treatment';
      int price = 0;
      try {
        final dyn = tObj as dynamic;
        if (dyn.name != null) tName = dyn.name.toString();
        final pVal = (dyn.price ?? 0);
        price = pVal is int ? pVal : int.tryParse(pVal.toString()) ?? 0;
      } catch (_) {}
      final rowTotal = price * (counts.male + counts.female);
      treatments.add({
        'name': tName,
        'price': price,
        'male': counts.male,
        'female': counts.female,
        'total': rowTotal,
      });
    });

    
    messenger.hideCurrentSnackBar();
    final savedPath = await PdfHelper.generateAndPreviewPdf(
      context: context,
      fields: fields,
      treatments: treatments,
      suggestedFileName: suggestedFileNamePrefix != null
          ? '${suggestedFileNamePrefix}_${fields['name']}.pdf'
          : 'invoice_${fields['name']}.pdf',
    );

    if (savedPath == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to generate invoice'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    messenger.showSnackBar(
      const SnackBar(
        content: Text('Patient saved & Invoice generated'),
        backgroundColor: Colors.green,
      ),
    );
    return true;
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('Unexpected error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ),
    );
    return false;
  }
}
