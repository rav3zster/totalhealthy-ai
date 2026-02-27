import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_helper.dart';

class RealTimeSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;

  const RealTimeSearchBar({
    super.key,
    required this.onSearchChanged,
    this.hintText = 'Search meals...',
    this.showFilterIcon = false, // Changed to false - filter removed
    this.onFilterTap,
  });

  @override
  State<RealTimeSearchBar> createState() => _RealTimeSearchBarState();
}

class _RealTimeSearchBarState extends State<RealTimeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final RxString _searchQuery = ''.obs;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Start new timer with 300ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final query = _controller.text.trim();
      _searchQuery.value = query;
      widget.onSearchChanged(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    _searchQuery.value = '';
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white54),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                // Update reactive variable immediately for UI feedback
                _searchQuery.value = value;
              },
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => _searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3A3A3A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white54,
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink(), // Filter icon removed
          ),
        ],
      ),
    );
  }
}

// Alternative simpler version without debouncing for immediate feedback
class SimpleRealTimeSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback? onSearchFocused;
  final VoidCallback? onSearchCleared;
  final String hintText;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;
  final RxString searchQuery;

  const SimpleRealTimeSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.searchQuery,
    this.onSearchFocused,
    this.onSearchCleared,
    this.hintText = 'Search meals...',
    this.showFilterIcon = false, // Changed to false - filter removed
    this.onFilterTap,
  });

  @override
  State<SimpleRealTimeSearchBar> createState() =>
      _SimpleRealTimeSearchBarState();
}

class _SimpleRealTimeSearchBarState extends State<SimpleRealTimeSearchBar> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  Worker? _searchWorker;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery.value);
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(_onFocusChanged);

    // CRITICAL FIX: Listen to searchQuery changes to sync with text controller
    // Store the worker to dispose of it later
    _searchWorker = ever(widget.searchQuery, (String value) {
      // Check if mounted to avoid "used after disposed" error
      if (!mounted) return;

      // Only update if value is different to avoid loops
      if (_textController.text != value) {
        // Use post frame callback to avoid build conflicts
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _textController.text = value;
            // Maintain cursor position at end
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // CRITICAL: Dispose worker first to stop listening
    _searchWorker?.dispose();

    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      // Search field is focused
      widget.onSearchFocused?.call();
    } else {
      // Search field lost focus - if empty, exit search mode
      if (_textController.text.trim().isEmpty) {
        widget.onSearchCleared?.call();
      }
    }
  }

  void _clearSearch() {
    _textController.clear();
    // DON'T set searchQuery.value here - let controller do it via callbacks
    widget.onSearchChanged('');
    widget.onSearchCleared?.call();
    _focusNode.unfocus(); // Remove focus when clearing
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: context.isLightTheme
            ? context.searchBarColor
            : Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : context.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isLightTheme
                ? Colors.black.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: context.isLightTheme
                ? context.textSecondary
                : Colors.white54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              style: TextStyle(color: context.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(color: context.textTertiary, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                print(
                  '🔤 WIDGET DEBUG - TextField onChanged called with: "$value"',
                );
                // CRITICAL FIX: Update searchQuery immediately for reactive UI (clear button, etc.)
                widget.searchQuery.value = value;
                print('🔤 WIDGET DEBUG - Calling onSearchChanged callback');
                widget.onSearchChanged(value);
                print('🔤 WIDGET DEBUG - onSearchChanged callback completed');
              },
            ),
          ),
          Obx(
            () => widget.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: context.isLightTheme
                            ? context.borderColor
                            : Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.clear,
                        color: context.textSecondary,
                        size: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink(), // Filter icon removed
          ),
        ],
      ),
    );
  }
}
