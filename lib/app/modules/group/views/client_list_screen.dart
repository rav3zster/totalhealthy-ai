import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../controllers/user_controller.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/users_firestore_service.dart';
import '../../../data/services/role_permissions_service.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  // CRITICAL: Persistent controllers - NEVER recreate these
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final UsersFirestoreService _usersService = UsersFirestoreService();
  final RolePermissionsService _permissionsService = RolePermissionsService();

  // Use ValueNotifier to avoid rebuilding TextField
  final ValueNotifier<List<UserModel>> filteredMembersNotifier =
      ValueNotifier<List<UserModel>>([]);

  List<UserModel> allMembers = [];
  Set<String> assignedClientIds = {};
  bool isLoading = true;
  Set<String> addingClients = {};

  @override
  void initState() {
    super.initState();

    // CRITICAL: RBAC Check - Only Advisors can access this screen
    if (!_permissionsService.canManageClients()) {
      debugPrint('❌ RBAC: Non-advisor attempted to access Client List');

      // Show error message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Permission Denied',
          'Only Advisors can manage clients',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate back
        Get.back();
      });

      return;
    }

    debugPrint('✅ RBAC: Advisor access granted to Client List');
    _loadMembers();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    filteredMembersNotifier.dispose();
    super.dispose();
  }

  void _loadMembers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint('❌ No current user found');
      setState(() {
        isLoading = false;
      });
      return;
    }

    debugPrint('✅ Loading members for trainer: ${currentUser.uid}');

    // Get assigned clients first
    _usersService.getTrainerClientsStream(currentUser.uid).listen((
      assignedClients,
    ) {
      debugPrint('📋 Assigned clients: ${assignedClients.length}');
      assignedClientIds = assignedClients.map((c) => c.id).toSet();

      // Trigger re-filter when assigned clients change
      if (mounted) {
        setState(() {
          allMembers = allMembers
              .where((m) => !assignedClientIds.contains(m.id))
              .toList();
          _filterMembers(searchController.text);
        });
      }
    });

    // Get all users from Firebase
    _usersService.getUsersStream().listen(
      (users) {
        debugPrint('👥 Total users from Firebase: ${users.length}');

        if (mounted) {
          setState(() {
            // CRITICAL: Filter using RolePermissionsService
            // This ensures ONLY Members appear (Advisors NEVER appear)
            final membersOnly = _permissionsService.filterMembersOnly(users);
            debugPrint(
              '✅ Members only (Advisors excluded): ${membersOnly.length}',
            );

            // Further filter: exclude current user and assigned clients
            allMembers = membersOnly.where((user) {
              final isNotCurrentUser = user.id != currentUser.uid;
              final isNotAssigned = !assignedClientIds.contains(user.id);
              return isNotCurrentUser && isNotAssigned;
            }).toList();

            debugPrint('✨ Available members to add: ${allMembers.length}');
            _filterMembers(searchController.text);
            isLoading = false;
          });
        }
      },
      onError: (error) {
        debugPrint('❌ Error loading users: $error');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }

  void _filterMembers(String query) {
    // CRITICAL: Do NOT call setState here - only update ValueNotifier
    // This prevents TextField from rebuilding and losing focus
    if (query.isEmpty) {
      filteredMembersNotifier.value = allMembers;
    } else {
      filteredMembersNotifier.value = allMembers.where((member) {
        return member.username.toLowerCase().contains(query.toLowerCase()) ||
            member.email.toLowerCase().contains(query.toLowerCase()) ||
            member.fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    debugPrint('🔍 Filtered members: ${filteredMembersNotifier.value.length}');
  }

  Future<void> _addClientToTrainer(UserModel client) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // RBAC: Validate permission to add client
    final validationError = _permissionsService.validateAddClient(client);
    if (validationError != null) {
      Get.snackbar(
        'Permission Denied',
        validationError,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      addingClients.add(client.id);
    });

    try {
      await _usersService.assignClientToTrainer(client.id, currentUser.uid);
      debugPrint('✅ Client ${client.fullName} assigned successfully');

      if (mounted) {
        Get.snackbar(
          'Success',
          '${client.fullName} has been added as your client!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Remove from list immediately
        setState(() {
          allMembers.removeWhere((m) => m.id == client.id);
          _filterMembers(searchController.text);
        });
      }
    } catch (e) {
      debugPrint('❌ Error adding client: $e');
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to add client: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      setState(() {
        addingClients.remove(client.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC2D86A).withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC2D86A).withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Premium Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Discover Clients',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Connect with new members',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Modern Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      onChanged: _filterMembers,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      cursorColor: const Color(0xFFC2D86A),
                      decoration: InputDecoration(
                        hintText: 'Search members...',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: const Color(0xFFC2D86A).withValues(alpha: 0.7),
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  searchController.clear();
                                  _filterMembers('');
                                },
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white.withValues(alpha: 0.3),
                                  size: 20,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Section Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AVAILABLE MEMBERS',
                        style: TextStyle(
                          color: Color(0xFFC2D86A),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      ValueListenableBuilder<List<UserModel>>(
                        valueListenable: filteredMembersNotifier,
                        builder: (context, members, _) => Text(
                          '${members.length} found',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Scrollable List
                Expanded(
                  child: isLoading
                      ? _buildLoadingState()
                      : ValueListenableBuilder<List<UserModel>>(
                          valueListenable: filteredMembersNotifier,
                          builder: (context, filteredMembers, child) {
                            if (filteredMembers.isEmpty) {
                              return _buildEmptyState();
                            }

                            return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                return _buildModernClientCard(
                                  filteredMembers[index],
                                  index,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFC2D86A), strokeWidth: 3),
          SizedBox(height: 20),
          Text(
            'Syncing Member Database...',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                Icons.person_search_rounded,
                size: 60,
                color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Members Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchController.text.isEmpty
                  ? 'There are currently no members available to connect with.'
                  : 'Try searching for a different name or check for typos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernClientCard(UserModel client, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative Background Gradient
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC2D86A).withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Profile Image with Status Ring
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFC2D86A), Color(0xFF2A2A2A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: const Color(0xFF2A2A2A),
                              backgroundImage: UserController.getImageProvider(
                                client.profileImage,
                              ),
                              child: client.profileImage.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white24,
                                      size: 35,
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC2D86A),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF1A1A1A),
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Client Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              client.email,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildBadge(
                                  client.planName,
                                  const Color(0xFFC2D86A),
                                ),
                                const SizedBox(width: 8),
                                _buildBadge(
                                  '${client.age} yrs',
                                  Colors.white.withValues(alpha: 0.1),
                                  textColor: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Action Toolbar
                  Divider(
                    color: Colors.white.withValues(alpha: 0.05),
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Compact Action Buttons
                      _buildCompactActionButton(
                        Icons.phone_rounded,
                        'Call',
                        () => _makePhoneCall(client.phone),
                      ),
                      const SizedBox(width: 12),
                      _buildCompactActionButton(
                        Icons.chat_bubble_rounded,
                        'Chat',
                        () => _openChat(client.id),
                      ),
                      const Spacer(),
                      // Add Client Button (Prime Action)
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: addingClients.contains(client.id)
                              ? null
                              : () => _addClientToTrainer(client),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC2D86A),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: addingClients.contains(client.id)
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'Add Client',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
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
      ),
    );
  }

  Widget _buildBadge(String text, Color color, {Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildCompactActionButton(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white60, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phone) {
    Get.snackbar(
      'Dialer',
      'Initiating call to $phone',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A1A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
    );
  }

  void _openChat(String clientId) {
    Get.snackbar(
      'Messenger',
      'Opening secure chat channel...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A1A),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
    );
  }
}
