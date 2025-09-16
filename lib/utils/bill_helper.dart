import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum BillSide { front, back }

class BillScannerHelper {
  // General keywords
  static const List<String> _frontKeywords = [
    'KE',
    'PLOT NO',
    'CNIC NO',
    'ACCOUNT NO',
    'USER NAME',
    'DISPATCH ID',
    'AMOUNT DUE',
    'CURRENT MONTH',
    'DUE DATE',
  ];

  static const List<String> _backKeywords = [
    'REACH K-ELECTRIC LIMITED',
    'BILLING DETAILS',
    'CUSTOMER.CARE@KE.COM.PK',
    'WWW.KE.COM.PK',
  ];

  static const List<String> _frontUnique = [
    'USER NAME',
    'AMOUNT DUE',
    'DISPATCH ID',
  ];

  static const List<String> _backUnique = [
    'CUSTOMER.CARE@KE.COM.PK',
    'WWW.KE.COM.PK',
  ];

  static Future<File?> scanBill(BuildContext context, BillSide side) async {
    try {
      // 1) Camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        _showSnack(context, "Camera permission is required");
        return null;
      }

      // 2) Open document scanner
      final scanner = DocumentScanner(
        options: DocumentScannerOptions(
          documentFormat: DocumentFormat.jpeg,
          pageLimit: 1,
        ),
      );
      final result = await scanner.scanDocument();
      if (result == null || result.images.isEmpty) {
        _showSnack(context, "No document captured");
        return null;
      }

      final file = File(result.images.first);

      // 3) OCR text extraction
      final rawText = await _getOcrText(file);
      debugPrint("📝 OCR raw text:\n$rawText");

      final normText = _normalize(rawText);

      // 4) Validate keywords
      final keywords = side == BillSide.front ? _frontKeywords : _backKeywords;
      final uniqueKeywords =
          side == BillSide.front ? _frontUnique : _backUnique;

      int matches = 0;
      for (final k in keywords) {
        if (normText.contains(_normalize(k))) matches++;
      }

      // require at least 2 general keyword matches
      if (matches < 2) {
        _showSnack(
          context,
          side == BillSide.front
              ? "This doesn’t look like BILL FRONT. Please retake."
              : "This doesn’t look like BILL BACK. Please retake.",
        );
        return null;
      }

      // must contain at least 1 unique keyword
      bool hasUnique = uniqueKeywords.any(
        (k) => normText.contains(_normalize(k)),
      );
      if (!hasUnique) {
        _showSnack(
          context,
          side == BillSide.front
              ? "This doesn’t look like BILL FRONT. Please retake."
              : "This doesn’t look like BILL BACK. Please retake.",
        );
        return null;
      }

      return file; // ✅ valid bill side
    } catch (e) {
      debugPrint("❌ Bill Scan Error: $e");
      _showSnack(context, "Scan failed: $e");
      return null;
    }
  }

  // OCR helper
  static Future<String> _getOcrText(File file) async {
    final inputImage = InputImage.fromFile(file);
    final recognizer = TextRecognizer();
    final recognized = await recognizer.processImage(inputImage);
    await recognizer.close();
    return recognized.text ?? '';
  }

  // Normalize text
  static String _normalize(String s) {
    if (s.isEmpty) return '';
    s = s.replaceAll(RegExp(r'[^\w\s]', unicode: true), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s.toLowerCase();
  }

  static void _showSnack(BuildContext ctx, String msg) {
    if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
