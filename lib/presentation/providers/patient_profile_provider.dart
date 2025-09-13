
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:noviindus_task/domain/usecases/save_patient_use_case.dart';
import '../../domain/entities/patient_profile.dart';

import '../../core/pdf/pdf_generator.dart'; 
import '../../presentation/ui/pdf_preview_screen/pdf_preview_screen.dart'; 

enum SubmitStatus { idle, submitting, success, failure }

class PatientProfileProvider extends ChangeNotifier {
  final SavePatientUsecase savePatientUsecase;

  SubmitStatus _status = SubmitStatus.idle;
  SubmitStatus get status => _status;

  String? _error;
  String? get error => _error;

  PatientProfileProvider({required this.savePatientUsecase});

  Future<bool> submitPatient({
    required BuildContext context,
    required PatientProfile profile,
    Map<String, List<int>>? files,
  }) async {
    _status = SubmitStatus.submitting;
    _error = null;
    notifyListeners();

    try {
      
      final Map<String, dynamic> response = await savePatientUsecase.call(
        profile,
        files: files,
      );

      _status = SubmitStatus.success;
      notifyListeners();

      
      final fields = <String, String>{
        'name': profile.name,
        'excecutive': profile.excecutive,
        'payment': profile.payment,
        'phone': profile.phone,
        'address': profile.address,
        'total_amount': profile.totalAmount.toString(),
        'discount_amount': profile.discountAmount.toString(),
        'advance_amount': profile.advanceAmount.toString(),
        'balance_amount': profile.balanceAmount.toString(),
        'date_nd_time': profile.dateNdTime,
        'id': profile.id,
        'male': profile.male,
        'female': profile.female,
        'branch': profile.branch,
        'treatments': profile.treatments,
        
        'bookedon': DateTime.now().toString(),
      };

      
      final List<Map<String, dynamic>> treatmentsForPdf = [];
      final returned = response['data'] ?? response;
      if (returned is Map && returned.containsKey('treatments_details')) {
        for (final t in returned['treatments_details'] as List<dynamic>) {
          treatmentsForPdf.add({
            'name': t['name'] ?? 'Treatment',
            'price': t['price'] ?? 0,
            'male': t['male'] ?? 0,
            'female': t['female'] ?? 0,
            'total':
                (t['price'] ?? 0) * ((t['male'] ?? 0) + (t['female'] ?? 0)),
          });
        }
      } else {
        
        final ids = profile.treatments
            .split(',')
            .where((s) => s.trim().isNotEmpty)
            .toList();
        for (final id in ids) {
          treatmentsForPdf.add({
            'name': 'Treatment $id',
            'price': 0,
            'male': 0,
            'female': 0,
            'total': 0,
          });
        }
      }

      
      final generator = PatientInvoiceGenerator();
      final Uint8List pdfBytes = await generator.buildPdfBytes(
        fields: fields,
        treatments: treatmentsForPdf,
      );

      final savedPath = await generator.savePdfToFile(
        bytes: pdfBytes,
        suggestedFilename: 'invoice_${profile.name}.pdf',
      );

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invoice generated'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              PdfPreviewScreen(pdfBytes: pdfBytes, savedFilePath: savedPath),
        ),
      );

      return true;
    } catch (e) {
      _status = SubmitStatus.failure;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
