import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meal_categories_controller.dart';
import '../../../core/theme/theme_helper.dart';

class MealCategoriesView extends GetView<MealCategoriesController> {
  const MealCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Meal Categories',
          style: TextStyle(color: context.textPrimary),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categories.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: context.accent),
          );
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: context.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No categories available',
                  style: TextStyle(color: context.textSecondary, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Icon(
                  Icons.circle,
                  size: 8,
                  color: category.isDefault
                      ? context.accent
                      : context.textSecondary,
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: category.isDefault
                    ? Container(
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (!controller.isAdmin.value) return const SizedBox.shrink();

        return FloatingActionButton(
          onPressed: _showAddCategoryDialog,
          backgroundColor: context.accent,
          child: const Icon(Icons.add, color: Colors.black),
        );
      }),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    final context = Get.context!;

    Get.dialog(
      AlertDialog(
        backgroundColor: context.cardColor,
        title: Text(
          'Add Category',
          style: TextStyle(color: context.textPrimary),
        ),
        content: TextField(
          controller: nameController,
          style: TextStyle(color: context.textPrimary),
          decoration: InputDecoration(
            labelText: 'Category Name',
            labelStyle: TextStyle(color: context.textSecondary),
            hintText: 'e.g., Pre-Workout',
            hintStyle: TextStyle(color: context.textTertiary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: context.accent),
            ),
          ),
          maxLength: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.createCategory(nameController.text);
            },
            child: Text('Create', style: TextStyle(color: context.accent)),
          ),
        ],
      ),
    );
  }
}
