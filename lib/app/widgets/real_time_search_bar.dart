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
    this.showFilterIcon = true,
    this.onFilterTap,
  });

  @override
  State<SimpleRealTimeSearchBar> createState() =>
      _SimpleRealTimeSearchBarState();
}

class _SimpleRealTimeSearchBarState extends State<SimpleRealTimeSearchBar> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.searchQuery.value);
    _focusNode = FocusNode();

    // Listen to focus changes
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
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

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MealFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                print(
                  '🔤 WIDGET DEBUG - TextField onChanged called with: "$value"',
                );
                // DON'T set searchQuery.value here - let the controller do it
                // widget.searchQuery.value = value;
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
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFC2D86A).withValues(alpha: 0.2),
                            const Color(0xFFC2D86A).withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  )
                : widget.showFilterIcon
                ? GestureDetector(
                    onTap:
                        widget.onFilterTap ?? () => _showFilterDialog(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFC2D86A).withValues(alpha: 0.2),
                            const Color(0xFFC2D86A).withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFFC2D86A),
                        size: 20,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// Meal Filter Dialog Widget
class _MealFilterDialog extends StatefulWidget {
  @override
  State<_MealFilterDialog> createState() => _MealFilterDialogState();
}

class _MealFilterDialogState extends State<_MealFilterDialog> {
  // Filter options
  final List<String> categories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Morning Snacks',
    'Preworkout',
    'Post Workout',
  ];

  final List<String> sortOptions = [
    'Name (A-Z)',
    'Name (Z-A)',
    'Calories (Low to High)',
    'Calories (High to Low)',
    'Protein (High to Low)',
    'Recently Added',
  ];

  Set<String> selectedCategories = {};
  String selectedSort = 'Recently Added';
  RangeValues calorieRange = const RangeValues(0, 1000);
  RangeValues proteinRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Meals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Categories Section
              const Text(
                'Meal Categories',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategories.remove(category);
                        } else {
                          selectedCategories.add(category);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFC2D86A)
                              : Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Sort By Section
              const Text(
                'Sort By',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...sortOptions.map((option) {
                final isSelected = selectedSort == option;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSort = option;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                const Color(0xFFC2D86A).withValues(alpha: 0.2),
                                const Color(0xFFC2D86A).withValues(alpha: 0.1),
                              ],
                            )
                          : null,
                      color: isSelected ? null : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFC2D86A)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? const Color(0xFFC2D86A)
                              : Colors.white54,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Calorie Range Section
              const Text(
                'Calorie Range',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${calorieRange.start.round()} cal',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${calorieRange.end.round()} cal',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFC2D86A),
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                  thumbColor: const Color(0xFFC2D86A),
                  overlayColor: const Color(0xFFC2D86A).withValues(alpha: 0.2),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: RangeSlider(
                  values: calorieRange,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  onChanged: (values) {
                    setState(() {
                      calorieRange = values;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Protein Range Section
              const Text(
                'Protein Range',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${proteinRange.start.round()}g',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '${proteinRange.end.round()}g',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFC2D86A),
                  inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                  thumbColor: const Color(0xFFC2D86A),
                  overlayColor: const Color(0xFFC2D86A).withValues(alpha: 0.2),
                  rangeThumbShape: const RoundRangeSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: RangeSlider(
                  values: proteinRange,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (values) {
                    setState(() {
                      proteinRange = values;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategories.clear();
                          selectedSort = 'Recently Added';
                          calorieRange = const RangeValues(0, 1000);
                          proteinRange = const RangeValues(0, 100);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters
                        Navigator.pop(context);
                        Get.snackbar(
                          'Filters Applied',
                          '${selectedCategories.length} categories, sorted by $selectedSort',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF2A2A2A),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFC2D86A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
