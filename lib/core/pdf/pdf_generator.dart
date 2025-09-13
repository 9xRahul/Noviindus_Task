import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';

class PatientInvoiceGenerator {
  Future<Uint8List> buildPdfBytes({
    required Map<String, String> fields,
    required List<Map<String, dynamic>> treatments,
  }) async {
    final pdf = pw.Document(pageMode: PdfPageMode.outlines);
    final baseFont = await PdfGoogleFonts.openSansRegular();
    final baseFontBold = await PdfGoogleFonts.openSansBold();

    final logoBytes = await rootBundle.load('assets/img/logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    final fadeLogoBytes = await rootBundle.load('assets/img/fade.png');
    final fadeLogoImage = pw.MemoryImage(fadeLogoBytes.buffer.asUint8List());

    print(fields['total_amount']);

    final pageTheme = pw.PageTheme(
      margin: const pw.EdgeInsets.all(24),
      theme: pw.ThemeData.withFont(base: baseFont, bold: baseFontBold),
      buildBackground: (context) {
        return pw.FullPage(
          ignoreMargins: true,
          child: pw.Center(
            child: pw.Opacity(
              opacity: 1,
              child: pw.Image(
                fadeLogoImage,
                fit: pw.BoxFit.contain,
                width: 300,
              ),
            ),
          ),
        );
      },
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pageTheme,
        build: (context) {
          return [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: 70,
                  height: 70,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    image: pw.DecorationImage(
                      image: logoImage,
                      fit: pw.BoxFit.cover,
                    ),
                    border: pw.Border.all(color: PdfColors.green, width: 2),
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'KUMARAKOM',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      'Cheepunkal P.O. Kumarakom, Kerala',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'e-mail: unknown@gmail.com',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Mob: +91 9876543210 | +91 9786543210',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 4),

                    pw.Text(
                      'GST No: 32AABCU9603R1ZW',
                      style: pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 12),
            pw.Divider(),

            pw.SizedBox(height: 6),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Patient Details',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.green,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      _kvRow('Name', fields['name'] ?? ''),
                      _kvRow('Address', fields['address'] ?? ''),
                      _kvRow('WhatsApp Number', fields['phone'] ?? ''),
                    ],
                  ),
                ),

                pw.SizedBox(width: 18),
                pw.Expanded(
                  flex: 1,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 20),
                      _kvRow('Booked On', fields['bookedon'] ?? ''),
                      _kvRow('Treatment Date', fields['treatmentdate'] ?? ''),
                      _kvRow(
                        'Treatment Time',
                        "${fields['hour']}:${fields['min']}",
                      ),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),
            pw.Divider(),

            pw.SizedBox(height: 6),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 4,
                    child: pw.Text(
                      'Treatment',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Price',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Male',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Female',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Total',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            for (final t in treatments)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                child: pw.Row(
                  children: [
                    pw.Expanded(flex: 4, child: pw.Text(t['name'] ?? '')),
                    pw.Expanded(flex: 2, child: pw.Text('${t['price'] ?? ''}')),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        '${t['male'] ?? ''}',
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        '${t['female'] ?? ''}',
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        '${t['total'] ?? ''}',
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

            pw.Divider(),

            pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 220,
                padding: const pw.EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _kvAmountRow(
                      'Total Amount',
                      '${fields['total_amount'] ?? '0'}',
                    ),
                    _kvAmountRow(
                      'Discount',
                      '${fields['discount_amount'] ?? '0'}',
                    ),
                    _kvAmountRow(
                      'Advance',
                      '${fields['advance_amount'] ?? '0'}',
                    ),
                    pw.Divider(),
                    _kvAmountRow(
                      'Balance',
                      '${fields['balance_amount'] ?? '0'}',
                      isBold: true,
                    ),
                    pw.SizedBox(height: 50),
                    pw.Text(
                      'Thank you for choosing us',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.green,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Your well-being is our commitment, and we\'re honored you\'ve entrusted us with your health journey',
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            pw.SizedBox(height: 200),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: List.generate(50, (_) {
                return pw.Container(width: 3, height: 1, color: PdfColors.grey);
              }),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              '“Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment”',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<String> savePdfToFile({
    required Uint8List bytes,
    String? suggestedFilename,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = suggestedFilename ?? 'patient_invoice_$timestamp.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  pw.Widget _kvRow(String key, String value) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "$key",
              style: pw.TextStyle(fontSize: 9, color: PdfColors.black),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(value, style: pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  pw.Widget _kvAmountRow(String key, String value, {bool isBold = false}) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            key,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
