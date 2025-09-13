
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noviindus_task/core/pdf/pdf_helper.dart';

import 'package:noviindus_task/core/utils/date_convert.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';
import 'package:noviindus_task/domain/entities/branch.dart';




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

  final totalText = totalController.text.trim();
  final discountText = discountController.text.trim();
  final advanceText = advanceController.text.trim();

  final totalNum = double.tryParse(totalText) ?? 0.0;
  final discNum = double.tryParse(discountText) ?? 0.0;
  final advNum = double.tryParse(advanceText) ?? 0.0;
  final balance = balanceController.text;

  
  final Map<String, String> fields = {
    'name': nameController.text.trim(),
    'excecutive': executiveController.text.trim(),
    'payment': paymentController.text.trim(),
    'phone': phoneController.text.trim(),
    'address': addressController.text.trim(),
    'total_amount': totalController.text.trim(),
    'discount_amount': discountText,
    'advance_amount': advanceText,
    'balance_amount': balance,
    'date_nd_time': dateStr,
    "bookedon": DateFormat('dd/MM/yyyy').format(DateTime.now()),
    'id': '',
    'male': maleIds.join(','),
    'female': femaleIds.join(','),
    'branch': selectedBranch?.id.toString() ?? '',
    'treatments': treatmentIds,
    'treatmentdate': dateController.text.trim(),
    'hour': treatmentHour,
    'min': treatmentMin,
  };

  
  final List<Map<String, dynamic>> treatments = [];
  selectedTreatments.forEach((id, counts) {
    final treatmentObj = counts.treatment;
    String tName = 'Treatment';
    int price = 0;

    
    try {
      final dyn = treatmentObj as dynamic;
      
      if (dyn.name != null) {
        tName = dyn.name.toString();
      } else if (dyn.title != null) {
        tName = dyn.title.toString();
      } else if (dyn.treatmentName != null) {
        tName = dyn.treatmentName.toString();
      }
      
      final pVal = (dyn.price ?? dyn.amount ?? dyn.fee ?? 0);
      if (pVal is int) {
        price = pVal;
      } else if (pVal is double) {
        price = pVal.toInt();
      } else {
        price = int.tryParse(pVal.toString()) ?? 0;
      }
    } catch (_) {
      
      tName = 'Treatment';
      price = 0;
    }

    final maleCount = counts.male;
    final femaleCount = counts.female;
    final rowTotal = price * (maleCount + femaleCount);
    treatments.add({
      'name': tName,
      'price': price,
      'male': maleCount,
      'female': femaleCount,
      'total': rowTotal,
    });
  });

  
  if (treatments.isEmpty) {
    treatments.add({
      'name': 'Panchakarma',
      'price': 230,
      'male': 4,
      'female': 4,
      'total': 230 * 8,
    });
  }

  
  try {
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
        content: Text('Invoice generated'),
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
