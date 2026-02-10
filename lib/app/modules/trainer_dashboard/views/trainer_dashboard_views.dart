import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/controllers/user_controller.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../data/services/mock_api_service.dart';
import '../../../data/services/users_firestore_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

import '../../../widgets/drawer_menu.dart';
import '../../../widgets/notification_services.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../widgets/real_time_search_bar.dart';

class TrainerDashboardView extends StatefulWidget {
  const TrainerDashboardView({super.key});

  @override
  State<TrainerDashboardView> createState() => _TrainerDashboardViewState();
}

class _TrainerDashboardViewState extends State<TrainerDashboardView> {
  final UsersFirestoreService _usersService = UsersFirestoreService();
  final RxString searchQuery = ''.obs;
  bool isLoading = false;
  var userData = {};

  // Real-time client list
  List<UserModel> assignedClients = [];
  bool isClientsLoading = true;

  // Search state management
  bool isSearchActive = false;
  List<UserModel> filteredClients = [];
  Future<void> submitUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      String input = searchQuery.value.trim();
      var phone = int.tryParse(input);

      // Use mock API instead of real API
      final response = phone != null
          ? await MockApiService.searchUserByPhone(input)
          : await MockApiService.searchUserByEmail(input);

      if (response['statusCode'] == 200) {
        setState(() {
          groupMemberData = [response['data']];
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response["message"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  var isGroupLoading = false;
  var dataList = [];
  var uniqueDataList = [];

  Future<void> getGroup() async {
    try {
      setState(() {
        isGroupLoading = true;
      });

      // Use mock API instead of real API
      final response = await MockApiService.getGroups(
        Get.find<AuthController>().roleGet() == "admin" ? "admin" : "user",
      );

      if (response['statusCode'] == 200) {
        setState(() {
          dataList = response['data'];
          uniqueDataList = dataList
              .map((item) => item["name"])
              .toSet()
              .map(
                (groupName) =>
                    dataList.firstWhere((item) => item["name"] == groupName),
              )
              .toList();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response["message"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isGroupLoading = false;
      });
    }
  }

  bool isMemberLoading = false;
  var groupMemberData = [];
  NotificationService notificationService = NotificationService();

  Future<void> getCategories() async {
    try {
      // Use mock API instead of real API
      final response = await MockApiService.getMealCategories(
        Get.find<AuthController>().groupgetId(),
      );

      if (response['statusCode'] == 200) {
        Get.find<AuthController>().categoriesAdd(response['data']);
        Get.find<AuthController>().fetchAndScheduleNotifications(
          response['data'],
        );
      } else {
        debugPrint("Categories Not Found");
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> getMember() async {
    try {
      setState(() {
        isMemberLoading = true;
      });
      await getCategories();

      // Use mock API instead of real API
      final response = await MockApiService.getGroupMembers(
        Get.find<AuthController>().groupgetId(),
      );

      if (response['statusCode'] == 200) {
        setState(() {
          groupMemberData = response['data'];
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response["message"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isMemberLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    OntapStore.index = 0; // Set to Member/Home tab
    getMember();
    _loadAssignedClients();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _performSearch(query);
  }

  void onSearchFocused() {
    if (!isSearchActive) {
      setState(() {
        isSearchActive = true;
        filteredClients = [];
      });
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    setState(() {
      isSearchActive = false;
      filteredClients = [];
    });
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();

    setState(() {
      if (trimmedQuery.isEmpty) {
        filteredClients = [];
      } else {
        final lowerQuery = trimmedQuery.toLowerCase();
        filteredClients = assignedClients.where((client) {
          final nameLower = client.fullName.toLowerCase();
          final emailLower = client.email.toLowerCase();
          return nameLower.contains(lowerQuery) ||
              emailLower.contains(lowerQuery);
        }).toList();
      }
    });
  }

  void _loadAssignedClients() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        isClientsLoading = false;
      });
      return;
    }

    // Listen to real-time updates of assigned clients
    _usersService.getTrainerClientsStream(currentUser.uid).listen((clients) {
      debugPrint('Loaded ${clients.length} clients for trainer');
      for (var client in clients) {
        debugPrint('Client: ${client.fullName} (${client.email})');
      }
      setState(() {
        assignedClients = clients;
        isClientsLoading = false;
      });
    });
  }

  String? valueDropDown;

  Widget _buildClientList() {
    // Search mode: show empty state initially, then filtered results
    if (isSearchActive) {
      if (searchQuery.value.isEmpty) {
        // Empty search state - show nothing
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  Icons.search,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Start typing to search',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search by client name or email',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (filteredClients.isEmpty) {
        // No results found
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No clients found',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try a different search term',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Show filtered results
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredClients.length,
          itemBuilder: (context, index) {
            var client = filteredClients[index];
            return _buildModernClientCard(client, index);
          },
        );
      }
    }

    // Normal mode: show all clients or empty state
    if (assignedClients.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.people_outline,
                size: 80,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No clients added yet',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first client to get started',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show all clients
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: assignedClients.length,
      itemBuilder: (context, index) {
        var client = assignedClients[index];
        return _buildModernClientCard(client, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      drawer: const DrawerMenu(),
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with gradient background
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Profile Header
                              Row(
                                children: [
                                  GetBuilder<UserController>(
                                    builder: (userController) {
                                      return GestureDetector(
                                        onTap: () {
                                          scaffoldKey.currentState
                                              ?.openDrawer();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFFC2D86A),
                                                Color(0xFFD4E87C),
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFC2D86A,
                                                ).withValues(alpha: 0.4),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: CircleAvatar(
                                            radius: 28,
                                            backgroundColor: const Color(
                                              0xFF2A2A2A,
                                            ),
                                            backgroundImage:
                                                UserController.getImageProvider(
                                                  userController.profileImage,
                                                ),
                                            child:
                                                userController
                                                    .profileImage
                                                    .isEmpty
                                                ? const Icon(
                                                    Icons.person,
                                                    color: Colors.white24,
                                                    size: 28,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: GetBuilder<UserController>(
                                      builder: (userController) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Welcome Back,",
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              userController.fullName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.3,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFC2D86A),
                                          Color(0xFFD4E87C),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "Advisor",
                                      style: TextStyle(
                                        color: Color(0xFF121212),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Live Stats Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.15),
                                      const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Live Stats',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildStatItem(
                                          assignedClients.length < 10
                                              ? "0${assignedClients.length}"
                                              : "${assignedClients.length}",
                                          'No. Of Clients',
                                          const Color(0xFFF57552),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 1,
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        _buildStatItem(
                                          '05',
                                          'Active Diet Plans',
                                          const Color(0xFFF5D657),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 1,
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                        _buildStatItem(
                                          '07',
                                          'Pending Requests',
                                          const Color(0xFFD0B4F9),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Bar - Using working SimpleRealTimeSearchBar
                            SimpleRealTimeSearchBar(
                              searchQuery: searchQuery,
                              onSearchChanged: (query) {
                                updateSearchQuery(query);
                              },
                              onSearchFocused: () {
                                onSearchFocused();
                              },
                              onSearchCleared: () {
                                clearSearch();
                              },
                              hintText: 'Search clients by name or email...',
                              showFilterIcon: false,
                            ),

                            const SizedBox(height: 24),

                            // Client List Header with Add Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Clients',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.CLIENT_LIST);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFC2D86A),
                                          Color(0xFFD4E87C),
                                        ],
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
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Color(0xFF121212),
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'Add Client',
                                          style: TextStyle(
                                            color: Color(0xFF121212),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Client List
                            isClientsLoading
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(32.0),
                                      child: CircularProgressIndicator(
                                        color: Color(0xFFC2D86A),
                                      ),
                                    ),
                                  )
                                : _buildClientList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavigationBar(),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildModernClientCard(UserModel client, int index) {
    // Different gradient combinations for variety
    List<List<Color>> gradients = [
      [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
      [const Color(0xFF2D2D2D), const Color(0xFF1D1D1D)],
      [const Color(0xFF252525), const Color(0xFF151515)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        GetStorage().write("clientData", client.toJson());
        Get.toNamed("/userdiet?id=${client.id}");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Client Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
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
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF2A2A2A),
                  backgroundImage: UserController.getImageProvider(
                    client.profileImage,
                  ),
                  child: client.profileImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.black, size: 30)
                      : null,
                ),
              ),
              const SizedBox(width: 16),

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
                    const SizedBox(height: 6),
                    Text(
                      client.email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${client.progressPercentage}%',
                              style: TextStyle(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: client.progressPercentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFC2D86A),
                                    Color(0xFFD4E87C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Action Buttons
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFC2D86A).withValues(alpha: 0.2),
                          const Color(0xFFC2D86A).withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFFC2D86A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFC2D86A).withValues(alpha: 0.2),
                          const Color(0xFFC2D86A).withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Color(0xFFC2D86A),
                      size: 20,
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

  Widget _buildModernBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.person, 'Member', false, () {
                Get.find<AuthController>().roleStore("user");
                Get.offAllNamed(Routes.ClientDashboard);
              }),
              _buildNavItem(Icons.group, 'Group', false, () {
                Get.toNamed(Routes.GROUP);
              }),
              _buildNavItem(Icons.notifications, 'Notification', false, () {
                final userData = Get.find<AuthController>().userdataget();
                Get.toNamed('/notification?id=${userData["_id"] ?? ""}');
              }),
              _buildNavItem(Icons.person, 'Profile', false, () {
                Get.toNamed(Routes.PROFILE_MAIN);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
