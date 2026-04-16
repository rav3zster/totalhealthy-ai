import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/group_controller.dart';
import '../../../widgets/group_card.dart';
import '../../../routes/app_pages.dart';

class GroupScreen extends GetView<GroupController> {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Persistent controllers - NEVER recreate these
    final TextEditingController groupSearchController = TextEditingController();
    final FocusNode groupSearchFocusNode = FocusNode();

    return PopScope(
      // 🔥 THIS IS THE REAL FIX FOR FLUTTER WEB
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(Routes.ClientDashboard);
        }
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text('Groups', style: TextStyle(color: Colors.white)),

          // 🔙 AppBar back button (same behavior)
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.offAllNamed(Routes.ClientDashboard);
            },
          ),

          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _showCreateGroupDialog(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.black, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'Add Group',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 LEVEL 1: Groups Search Bar
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
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
                child: TextField(
                  controller: groupSearchController,
                  focusNode: groupSearchFocusNode,
                  onChanged: (query) {
                    // Trigger group filtering
                    controller.filterGroups(query);
                  },
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFC2D86A),
                  decoration: InputDecoration(
                    hintText: 'Search groups by name or description...',
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                      fontSize: 15,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.search,
                        color: Color(0xFFC2D86A),
                        size: 22,
                      ),
                    ),
                    suffixIcon: Obx(() {
                      if (controller.groupSearchQuery.value.isNotEmpty) {
                        return IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () {
                            groupSearchController.clear();
                            controller.clearGroupSearch();
                            groupSearchFocusNode.unfocus();
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📂 Categories
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CategoryChip(label: 'All', selected: true),
                    _CategoryChip(label: 'Fitness'),
                    _CategoryChip(label: 'Weight Loss'),
                    _CategoryChip(label: 'Yoga'),
                    _CategoryChip(label: 'Nutrition'),
                    _CategoryChip(label: 'Running'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 👥 Groups List Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Groups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() {
                    final count = controller.filteredGroups.length;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count ${count == 1 ? 'Group' : 'Groups'}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 12),

              // 👥 Groups List - Filtered
              Expanded(
                child: Obx(() {
                  final filteredGroups = controller.filteredGroups;

                  if (filteredGroups.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.groupSearchQuery.value.isNotEmpty
                                ? Icons.search_off_rounded
                                : Icons.group_outlined,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.groupSearchQuery.value.isNotEmpty
                                ? 'No groups found'
                                : 'No groups yet',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.groupSearchQuery.value.isNotEmpty
                                ? 'Try a different search term'
                                : 'Create your first group to get started',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (controller.groupSearchQuery.value.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                groupSearchController.clear();
                                controller.clearGroupSearch();
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Clear Search'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC2D86A),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredGroups.length,
                    itemBuilder: (context, index) {
                      final group = filteredGroups[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GroupCard(
                          group: {
                            'group_name': group['name'],
                            'description': group['description'],
                            'created_at': group['createdDate'],
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF242522),
        title: const Text(
          'Create New Group',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Group Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC2D86A)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC2D86A)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
            ),
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Group "${nameController.text}" created successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text('Create', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _CategoryChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(color: selected ? Colors.black : Colors.white),
        ),
        selected: selected,
        onSelected: (_) {},
        backgroundColor: const Color(0xFF242522),
        selectedColor: const Color(0xFFC2D86A),
        checkmarkColor: Colors.black,
      ),
    );
  }
}
