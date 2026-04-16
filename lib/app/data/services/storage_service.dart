import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
    bucket: 'totalhealthy-fd278.firebasestorage.app',
  );

  /// Uploads a file to Firebase Storage and returns the download URL
  /// [file] is the file to upload
  /// [folder] is the folder path in storage (e.g., 'profile_images')
  /// [fileName] is the optional filename. If not provided, it uses the original filename with a timestamp.
  Future<String> uploadFile({
    required File file,
    required String folder,
    String? fileName,
  }) async {
    try {
      final String extension = path.extension(file.path);

      // Ensure the fileName has the correct extension if provided
      String finalFileName;
      if (fileName != null) {
        finalFileName = fileName.endsWith(extension)
            ? fileName
            : '$fileName$extension';
      } else {
        finalFileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
      }

      final Reference ref = _storage.ref().child(folder).child(finalFileName);

      // Add metadata for better handling in Storage
      final metadata = SettableMetadata(
        contentType: extension.toLowerCase().contains('png')
            ? 'image/png'
            : 'image/jpeg',
      );

      final UploadTask uploadTask = ref.putFile(file, metadata);
      await uploadTask;

      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading file to Firebase Storage: $e');
      if (e.toString().contains('object-not-found')) {
        throw Exception(
          'Storage not initialized. Please enable Storage in Firebase Console and click "Get Started".',
        );
      }
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Deletes a file from Firebase Storage using its URL
  Future<void> deleteFile(String url) async {
    try {
      if (url.isEmpty || !url.startsWith('http')) return;
      final Reference ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting file from Firebase Storage: $e');
    }
  }
}
