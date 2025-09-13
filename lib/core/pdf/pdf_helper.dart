import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:noviindus_task/core/pdf/pdf_generator.dart';
import 'package:noviindus_task/presentation/ui/pdf_preview_screen/pdf_preview_screen.dart';

class PdfHelper {
  static Future<String?> generateAndPreviewPdf({
    required BuildContext context,
    required Map<String, String> fields,
    required List<Map<String, dynamic>> treatments,
    String? suggestedFileName,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Expanded(child: Text('Generating invoice...')),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        duration: Duration(seconds: 8),
      ),
    );

    try {
      final generator = PatientInvoiceGenerator();

      final Uint8List pdfBytes = await generator.buildPdfBytes(
        fields: fields,
        treatments: treatments,
      );

      final String savedPath = await generator.savePdfToFile(
        bytes: pdfBytes,
        suggestedFilename: suggestedFileName,
      );

      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Invoice generated and saved locally.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          duration: Duration(seconds: 3),
        ),
      );

      try {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                PdfPreviewScreen(pdfBytes: pdfBytes, savedFilePath: savedPath),
          ),
        );
      } catch (_) {}

      return savedPath;
    } catch (e) {
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Failed to generate invoice: ${e.toString()}'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      );
      return null;
    }
  }
}
