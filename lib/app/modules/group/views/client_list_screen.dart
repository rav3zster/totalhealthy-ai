import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // App Bar
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.2),
                                  const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFC2D86A),
                                        Color(0xFFB8CC5A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Client List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Search Bar - CRITICAL: NOT wrapped in any reactive widget
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.2),
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
                          controller: searchController,
                          focusNode: searchFocusNode,
                          onChanged: _filterMembers,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: const Color(0xFFC2D86A),
                          decoration: const InputDecoration(
                            hintText: 'Search by name or email...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.search,
                                color: Colors.white54,
                                size: 24,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Client List - CRITICAL: Only this part is reactive, NOT the TextField
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFC2D86A),
                        ),
                      )
                    : ValueListenableBuilder<List<UserModel>>(
                        valueListenable: filteredMembersNotifier,
                        builder: (context, filteredMembers, child) {
                          if (filteredMembers.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 80,
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      searchController.text.isEmpty
                                          ? 'No members available'
                                          : 'No members found',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      searchController.text.isEmpty
                                          ? 'All members have been added or no members exist'
                                          : 'Try a different search term',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                              itemCount: filteredMembers.length,
                              itemBuilder: (context, index) {
                                final member = filteredMembers[index];
                                return _buildModernClientCard(member, index);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernClientCard(UserModel client, int index) {
    List<List<Color>> gradients = [
      [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
      [const Color(0xFF2D2D2D), const Color(0xFF1D1D1D)],
      [const Color(0xFF252525), const Color(0xFF151515)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFC2D86A).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Image
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFC2D86A).withValues(alpha: 0.3),
                        const Color(0xFFC2D86A).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF2A2A2A),
                      child: client.profileImage.isNotEmpty
                          ? Image.asset(
                              client.profileImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Color(0xFFC2D86A),
                                  size: 40,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              color: Color(0xFFC2D86A),
                              size: 40,
                            ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Client Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        client.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Plan: ${client.planName}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Duration: ${client.planDuration}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        client.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),

                      // Add Client Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: addingClients.contains(client.id)
                              ? null
                              : () => _addClientToTrainer(client),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: addingClients.contains(client.id)
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Add Client',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Column(
                  children: [
                    _buildActionButton(
                      Icons.phone,
                      const Color(0xFFF5D657),
                      () => _makePhoneCall(client.phone),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      Icons.email,
                      const Color(0xFFC2D86A),
                      () => _sendEmail(client.email),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      Icons.chat,
                      const Color(0xFFF5D657),
                      () => _openChat(client.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.8)]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black, size: 20),
        padding: const EdgeInsets.all(8),
      ),
    );
  }

  void _makePhoneCall(String phone) {
    Get.snackbar(
      'Phone Call',
      'Calling $phone...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _sendEmail(String email) {
    Get.snackbar(
      'Email',
      'Opening email to $email',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _openChat(String clientId) {
    Get.snackbar(
      'Chat',
      'Opening chat...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}
