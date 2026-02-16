import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/meals_firestore_service.dart';
import '../../../controllers/user_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/base/controllers/auth_controller.dart';

class GroupMealChatView extends StatefulWidget {
  final String groupId;
  final bool isAdmin;

  const GroupMealChatView({
    super.key,
    required this.groupId,
    required this.isAdmin,
  });

  @override
  State<GroupMealChatView> createState() => _GroupMealChatViewState();
}

class _GroupMealChatViewState extends State<GroupMealChatView> {
  final MealsFirestoreService _mealsService = MealsFirestoreService();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat Area
        Expanded(
          child: StreamBuilder<List<MealModel>>(
            stream: _mealsService.getMealsStream(widget.groupId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final meals = snapshot.data ?? [];

              if (meals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 64,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No meals shared yet.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                      if (widget.isAdmin) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Tap \'Create Meal\' below to start',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        Text(
                          'Only the group admin can add meals.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                reverse: false, // Show newest at top if sorted by date desc
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  // Check if sender is current user (for alignment)
                  // In this context, admin creates meals, so effectively "messages" come from admin
                  final isMe = widget.isAdmin;

                  return _buildMealMessageBubble(meal, isMe);
                },
              );
            },
          ),
        ),

        // Admin Action Area (Create Meal Input)
        if (widget.isAdmin)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC2D86A).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _navigateToCreateMeal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline_rounded,
                        color: Color(0xFF121212),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Create Meal for Group',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToCreateMeal() async {
    // Store group ID for the create meal flow
    final authController = Get.find<AuthController>();
    await authController.groupIdStore(widget.groupId); // Temporarily store ID

    // Get current user data for ID
    final userData = authController.userdataget();
    final userId = userData["id"] ?? userData["_id"] ?? "";

    Get.toNamed("${Routes.CreateMeal}?id=$userId&from=group_details");
  }

  Widget _buildMealMessageBubble(MealModel meal, bool isMe) {
    // Determine alignment based on whether the current user is the creator
    // Ideally, we check against current user ID.
    // For now, let's assume left alignment for typical chat look,
    // or maybe highlight admin posts.

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Header
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              DateFormat('MMM d, h:mm a').format(meal.createdAt),
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),

          // Meal Card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D2D2D), Color(0xFF252525)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFC2D86A).withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Store meal details for the next screen
                  Get.find<AuthController>().box.write(
                    'mealdetails',
                    meal.toJson(),
                  );

                  Get.toNamed("${Routes.MEALS_DETAILS}?id=${meal.id ?? ''}");
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Meal Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFF1E1E1E),
                          child: Image(
                            image:
                                UserController.getImageProvider(
                                  meal.imageUrl,
                                ) ??
                                const AssetImage('assets/meal_placeholder.png')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.restaurant,
                                  color: Colors.white54,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Meal Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meal.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            // Macros or Categories
                            Row(
                              children: [
                                _buildMiniBadge(
                                  Icons.local_fire_department,
                                  '${meal.kcal} kcal',
                                ),
                                const SizedBox(width: 8),
                                if (meal.categories.isNotEmpty)
                                  _buildMiniBadge(
                                    Icons.category,
                                    meal.categories.first,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white24,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFFC2D86A)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
