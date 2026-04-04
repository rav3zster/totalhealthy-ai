import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';

/// Drop this widget anywhere to let the user scan food from camera/gallery.
/// [onResult] is called with the parsed nutritional data on success.
class FoodScanButton extends StatefulWidget {
  final void Function(Map<String, dynamic> result) onResult;
  const FoodScanButton({super.key, required this.onResult});

  @override
  State<FoodScanButton> createState() => _FoodScanButtonState();
}

class _FoodScanButtonState extends State<FoodScanButton> {
  bool _scanning = false;

  Future<void> _scan(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (file == null) return;

    setState(() => _scanning = true);
    try {
      final bytes = await File(file.path).readAsBytes();
      final b64 = base64Encode(bytes);
      final ext = file.path.split('.').last.toLowerCase();
      final mime = ext == 'png' ? 'image/png' : 'image/jpeg';

      final result = await AiService.instance.scanFood(
        base64Image: b64,
        mimeType: mime,
      );

      if (result != null) {
        widget.onResult(result);
      } else {
        _showError('Could not identify food. Please enter details manually.');
      }
    } catch (e) {
      _showError('Scan failed. Please try again.');
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSourcePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Food',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'AI will identify the food and fill in nutrition data',
                style: TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 20),
              _SourceTile(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                onTap: () {
                  Navigator.pop(context);
                  _scan(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
              _SourceTile(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                onTap: () {
                  Navigator.pop(context);
                  _scan(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _scanning ? null : _showSourcePicker,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(
            0xFFC2D86A,
          ).withValues(alpha: _scanning ? 0.08 : 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(
              0xFFC2D86A,
            ).withValues(alpha: _scanning ? 0.2 : 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_scanning)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFC2D86A),
                ),
              )
            else
              const Icon(
                Icons.camera_alt_rounded,
                color: Color(0xFFC2D86A),
                size: 18,
              ),
            const SizedBox(width: 8),
            Text(
              _scanning ? 'Scanning...' : 'Scan Food with AI',
              style: TextStyle(
                color: const Color(
                  0xFFC2D86A,
                ).withValues(alpha: _scanning ? 0.6 : 1.0),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFC2D86A), size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
