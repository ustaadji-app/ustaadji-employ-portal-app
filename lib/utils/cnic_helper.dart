// utils/cnic_helper.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum CnicSide { front, back }

class CnicScannerHelper {
  static const List<String> _frontKeywords = [
    'PAKISTAN',
    'NATIONAL IDENTITY CARD',
    'IDENTITY NUMBER',
    'DATE OF ISSUE',
    'DATE OF EXPIRY',
    'DATE OF BIRTH',
  ];

  static Future<File?> scanCnic(BuildContext context, CnicSide side) async {
    try {
      // 1) Camera permission
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        _showSnack(context, "Camera permission is required");
        return null;
      }

      // 2) Document scanner
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

      // 3) OCR
      final rawText = await _getOcrText(file);
      debugPrint("📝 OCR raw text:\n$rawText");

      // 4) Normalize text
      final normText = _normalizeForMatch(rawText);

      bool isValid = false;

      if (side == CnicSide.front) {
        // Front: check for front keywords
        for (final k in _frontKeywords) {
          final nk = _normalizeForMatch(k);
          if (nk.isNotEmpty && normText.contains(nk)) {
            isValid = true;
            break;
          }
        }
      } else {
        // Back: just check if OCR detected some text
        if (normText.isNotEmpty) {
          isValid = true;
        }
      }

      if (!isValid) {
        _showSnack(
          context,
          side == CnicSide.front
              ? "This doesn’t look like CNIC FRONT. Please retake."
              : "This doesn’t look like CNIC BACK. Please retake.",
        );
        return null;
      }

      return file; // ✅ valid
    } catch (e) {
      debugPrint("❌ CNIC Scan Error: $e");
      _showSnack(context, "Scan failed: $e");
      return null;
    }
  }

  /// OCR
  static Future<String> _getOcrText(File file) async {
    final inputImage = InputImage.fromFile(file);
    final recognizer = TextRecognizer();
    final recognized = await recognizer.processImage(inputImage);
    await recognizer.close();
    return recognized.text;
  }

  /// Normalize
  static String _normalizeForMatch(String s) {
    if (s.isEmpty) return '';
    s = s.replaceAll('\u200C', '').replaceAll('\u200D', '');
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
