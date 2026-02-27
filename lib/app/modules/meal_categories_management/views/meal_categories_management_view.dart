import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/meal_categories_management_controller.dart';
import '../../../core/theme/theme_helper.dart';

class MealCategoriesManagementView
    extends GetView<MealCategoriesManagementController> {
  const MealCategoriesManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(context),

              // Content
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.mealCategories.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: context.accent),
                    );
                  }

                  if (controller.error.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.error.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.mealCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: context.accent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: context.accent,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Meal Categories',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add meal categories to organize\nyour daily meals',
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateCategoryDialog(context),
                            icon: const Icon(Icons.add, color: Colors.black),
                            label: const Text(
                              'Add Category',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.accent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: controller.mealCategories.length,
                    itemBuilder: (context, index) {
                      final category = controller.mealCategories[index];
                      return _buildCategoryCard(context, category, index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        if (controller.mealCategories.isEmpty) return const SizedBox.shrink();

        return Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () => _showCreateCategoryDialog(context),
            backgroundColor: context.accent,
            elevation: 8,
            icon: const Icon(Icons.add_rounded, color: Colors.black, size: 24),
            label: const Text(
              'Add Category',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        gradient: context.headerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title row
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: context.textPrimary,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meal Categories',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (controller.groupCategoryName != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              controller.groupCategoryName!,
                              style: TextStyle(
                                color: context.accent.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              '${controller.mealCategories.length} ${controller.mealCategories.length == 1 ? 'category' : 'categories'}',
                              style: TextStyle(
                                color: context.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Info card
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.accent.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  color: context.accent.withValues(alpha: 0.8),
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Set meal times and enable alarms',
                    style: TextStyle(
                      color: context.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, category, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: ExpandableCategoryCard(
        category: category,
        controller: controller,
        onDelete: () => _showDeleteDialog(context, category),
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Meal Category',
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: TextStyle(color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: TextStyle(color: context.textSecondary),
                  hintText: 'e.g., Snacks, Pre-workout',
                  hintStyle: TextStyle(color: context.textTertiary),
                  filled: true,
                  fillColor: context.cardSecondary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: context.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty) {
                        Get.snackbar('Error', 'Please enter a category name');
                        return;
                      }
                      controller.createMealCategory(
                        nameController.text.trim(),
                        null,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  void _showDeleteDialog(BuildContext context, category) {
    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Delete Category',
          style: TextStyle(color: context.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: TextStyle(color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteMealCategory(category);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Expandable Category Card Widget
class ExpandableCategoryCard extends StatefulWidget {
  final dynamic category;
  final MealCategoriesManagementController controller;
  final VoidCallback onDelete;

  const ExpandableCategoryCard({
    super.key,
    required this.category,
    required this.controller,
    required this.onDelete,
  });

  @override
  State<ExpandableCategoryCard> createState() => _ExpandableCategoryCardState();
}

class _ExpandableCategoryCardState extends State<ExpandableCategoryCard> {
  bool isExpanded = false;
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    _initializeTime();
  }

  void _initializeTime() {
    final now = DateTime.now();
    final time = widget.controller.parseTimeString(widget.category.time);

    selectedDateTime = time != null
        ? DateTime(now.year, now.month, now.day, time.hour, time.minute)
        : DateTime(now.year, now.month, now.day, 7, 0);
  }

  void _saveTime() {
    final time = TimeOfDay.fromDateTime(selectedDateTime);

    widget.controller.updateMealCategoryTime(widget.category, time);

    setState(() {
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = widget.controller.parseTimeString(widget.category.time);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded
              ? context.accent.withValues(alpha: 0.6)
              : context.accent.withValues(alpha: 0.3),
          width: isExpanded ? 2.0 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded) {
                  _initializeTime();
                }
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.category.name,
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.category.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.accent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Default',
                                  style: TextStyle(
                                    color: context.accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: context.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              time != null ? time.format(context) : 'Set time',
                              style: TextStyle(
                                color: time != null
                                    ? context.textSecondary
                                    : context.textTertiary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Alarm Toggle Switch
                  Transform.scale(
                    scale: 0.9,
                    child: Switch(
                      value: widget.category.isAlarmEnabled,
                      onChanged: (value) {
                        widget.controller.toggleAlarm(widget.category, value);
                      },
                      activeThumbColor: context.accent,
                      activeTrackColor: context.accent.withValues(alpha: 0.5),
                      inactiveThumbColor: context.textTertiary,
                      inactiveTrackColor: context.cardSecondary,
                    ),
                  ),
                  if (!widget.category.isDefault) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(36, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Divider(color: context.divider, height: 1),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Time',
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 150,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                            textTheme: CupertinoTextThemeData(
                              dateTimePickerTextStyle: TextStyle(
                                color: context.textPrimary,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: selectedDateTime,
                            use24hFormat: false,
                            backgroundColor: Colors.transparent,
                            onDateTimeChanged: (DateTime newDateTime) {
                              setState(() {
                                selectedDateTime = newDateTime;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
