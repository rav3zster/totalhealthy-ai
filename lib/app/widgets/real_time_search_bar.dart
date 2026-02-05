import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RealTimeSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;

  const RealTimeSearchBar({
    super.key,
    required this.onSearchChanged,
    this.hintText = 'Search meals...',
    this.showFilterIcon = true,
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
                : widget.showFilterIcon
                ? GestureDetector(
                    onTap: widget.onFilterTap,
                    child: const Icon(Icons.tune, color: Colors.white54),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// Alternative simpler version without debouncing for immediate feedback
class SimpleRealTimeSearchBar extends StatelessWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final bool showFilterIcon;
  final VoidCallback? onFilterTap;
  final RxString searchQuery;

  const SimpleRealTimeSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.searchQuery,
    this.hintText = 'Search meals...',
    this.showFilterIcon = true,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                searchQuery.value = value;
                onSearchChanged(value);
              },
            ),
          ),
          Obx(
            () => searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      searchQuery.value = '';
                      onSearchChanged('');
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFC2D86A).withValues(alpha: 0.2),
                            Color(0xFFC2D86A).withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.clear, color: Colors.white, size: 16),
                    ),
                  )
                : showFilterIcon
                ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFC2D86A).withValues(alpha: 0.2),
                          Color(0xFFC2D86A).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.tune, color: Color(0xFFC2D86A), size: 20),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
