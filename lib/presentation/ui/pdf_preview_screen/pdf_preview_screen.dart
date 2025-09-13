import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:open_file/open_file.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List pdfBytes;
  final String savedFilePath;

  const PdfPreviewScreen({
    super.key,
    required this.pdfBytes,
    required this.savedFilePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
        actions: [
          IconButton(
            tooltip: 'Download / Open PDF',
            icon: const Icon(Icons.download),
            onPressed: () async {
              if (savedFilePath.isNotEmpty) {
                await OpenFile.open(savedFilePath);
              } else {
                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'patient_invoice.pdf',
                );
              }
            },
          ),
          IconButton(
            tooltip: 'Print / Share',
            icon: const Icon(Icons.share),
            onPressed: () async {
              await Printing.sharePdf(
                bytes: pdfBytes,
                filename: 'patient_invoice.pdf',
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        build: (format) => pdfBytes,
      ),
    );
  }
}
