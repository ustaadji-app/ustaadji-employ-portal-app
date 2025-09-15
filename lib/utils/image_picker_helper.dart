import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<List<File>> pickImagesFromGallery({
  required BuildContext context,
  required List<File> currentImages,
  int maxImages = 3,
}) async {
  final ImagePicker picker = ImagePicker();
  final remaining = maxImages - currentImages.length;

  if (remaining <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You can select only $maxImages images.")),
    );
    return currentImages;
  }

  final List<XFile>? pickedFiles = await picker.pickMultiImage();
  if (pickedFiles == null || pickedFiles.isEmpty) return currentImages;

  final selectedFiles = pickedFiles.map((xfile) => File(xfile.path)).toList();

  // Limit to remaining images
  final limitedSelection = selectedFiles.take(remaining).toList();

  currentImages.addAll(limitedSelection);

  return currentImages;
}
