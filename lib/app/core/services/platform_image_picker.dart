import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// Platform-safe image picker.
/// Uses file_picker on web, image_picker on mobile.
class PlatformImagePicker {
  static Future<PickedImageResult?> pickImage() async {
    if (kIsWeb) {
      return _pickWeb();
    } else {
      return _pickMobile();
    }
  }

  static Future<PickedImageResult?> _pickWeb() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.first;
    return PickedImageResult(bytes: file.bytes, name: file.name, path: null);
  }

  static Future<PickedImageResult?> _pickMobile() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile == null) return null;
    return PickedImageResult(bytes: null, name: xFile.name, path: xFile.path);
  }
}

class PickedImageResult {
  final Uint8List? bytes; // web
  final String? path; // mobile
  final String name;

  const PickedImageResult({
    required this.bytes,
    required this.path,
    required this.name,
  });

  bool get isWeb => bytes != null;
  bool get hasMobilePath => path != null;
}
