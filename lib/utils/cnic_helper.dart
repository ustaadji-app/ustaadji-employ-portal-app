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

  // back side target keyword
  static const String _backMainKeyword = 'Registrar General of Pakistan';

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

      bool hasKeyword = false;

      if (side == CnicSide.front) {
        // ✅ Front: simple contains check
        for (final k in _frontKeywords) {
          final nk = _normalizeForMatch(k);
          if (nk.isNotEmpty && normText.contains(nk)) {
            hasKeyword = true;
            break;
          }
        }
      } else {
        // ✅ Back: fuzzy match ONLY with "Registrar General of Pakistan"
        final target = _normalizeForMatch(_backMainKeyword);

        // har line separately check karo
        final lines = normText.split('\n');
        for (final line in lines) {
          final score = _similar(line, target);
          debugPrint("🔍 Back line: '$line' → score $score");
          if (score > 0.65) {
            // threshold adjust kar sakte ho
            hasKeyword = true;
            break;
          }
        }
      }

      if (!hasKeyword) {
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
    return recognized.text ?? '';
  }

  /// normalize
  static String _normalizeForMatch(String s) {
    if (s.isEmpty) return '';
    s = s.replaceAll('\u200C', '').replaceAll('\u200D', '');
    s = s.replaceAll(RegExp(r'[^\w\s]', unicode: true), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s.toLowerCase();
  }

  /// similarity (Levenshtein)
  static double _similar(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0.0;
    final dist = _levenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    return 1.0 - (dist / maxLen);
  }

  static int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    final m = List.generate(
      s.length + 1,
      (_) => List<int>.filled(t.length + 1, 0),
    );

    for (int i = 0; i <= s.length; i++) m[i][0] = i;
    for (int j = 0; j <= t.length; j++) m[0][j] = j;

    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        m[i][j] = [
          m[i - 1][j] + 1,
          m[i][j - 1] + 1,
          m[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return m[s.length][t.length];
  }

  static void _showSnack(BuildContext ctx, String msg) {
    if (ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
