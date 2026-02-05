import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final TextEditingController searchController = TextEditingController();
  
  // Mock client data based on the image
  final List<Map<String, dynamic>> clients = [
    {
      'id': '1',
      'userName': 'Ayush Shukla',
      'planName': 'Keto Plan',
      'planDuration': 'Oct 1 - Nov 1',
      'email': 'ayush@gmail.com',
      'profileImage': 'assets/men.jpg',
    },
    {
      'id': '2',
      'userName': 'Rahul Sharma',
      'planName': 'Vegan Balanced Diet',
      'planDuration': 'Oct 1 - Nov 1',
      'email': 'rahul@gmail.com',
      'profileImage': 'assets/user_avatar.png',
    },
    {
      'id': '3',
      'userName': 'Pankaj Singh',
      'planName': 'High Protein Diet',
      'planDuration': 'Oct 1 - Nov 1',
      'email': 'pankaj@gmail.com',
      'profileImage': 'assets/male.png',
    },
  ];
  
  List<Map<String, dynamic>> filteredClients = [];

  @override
  void initState() {
    super.initState();
    filteredClients = clients;
  }

  void _filterClients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredClients = clients;
      } else {
        filteredClients = clients.where((client) {
          return client['userName'].toLowerCase().contains(query.toLowerCase()) ||
                 client['email'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A1A1A),
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A2A2A),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // App Bar
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFC2D86A).withOpacity(0.2),
                                  Color(0xFFC2D86A).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFC2D86A),
                                        Color(0xFFB8CC5A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
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
                          SizedBox(width: 48), // Balance the back button
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF2D2D2D),
                              Color(0xFF1D1D1D),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xFFC2D86A).withOpacity(0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: _filterClients,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search here by email id...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                            prefixIcon: Container(
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
              
              SizedBox(height: 20),
              
              // Client List
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return _buildModernClientCard(client, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildModernClientCard(Map<String, dynamic> client, int index) {
    // Different gradient combinations for variety
    List<List<Color>> gradients = [
      [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
      [Color(0xFF252525), Color(0xFF151515)],
    ];
    
    List<Color> cardGradient = gradients[index % gradients.length];
    
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFC2D86A).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFC2D86A).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                // Profile Image
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFC2D86A).withOpacity(0.3),
                        Color(0xFFC2D86A).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFC2D86A).withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        client['profileImage'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFF2A2A2A),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFFC2D86A),
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                SizedBox(width: 20),
                
                // Client Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name: ${client['userName']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plan Name: ${client['planName']}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Plan Duration: ${client['planDuration']}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Email: ${client['email']}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Add Client Button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFC2D86A),
                              Color(0xFFB8CC5A),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFC2D86A).withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _addClientToGroup(client);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text(
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
                      Color(0xFFF5D657),
                      () => _makePhoneCall(client['email']),
                    ),
                    SizedBox(height: 12),
                    _buildActionButton(
                      Icons.email,
                      Color(0xFFC2D86A),
                      () => _sendEmail(client['email']),
                    ),
                    SizedBox(height: 12),
                    _buildActionButton(
                      Icons.chat,
                      Color(0xFFF5D657),
                      () => _openChat(client['id']),
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
  
  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black,
          size: 20,
        ),
        padding: EdgeInsets.all(8),
      ),
    );
  }
  
  void _addClientToGroup(Map<String, dynamic> client) {
    Get.snackbar(
      'Success',
      '${client['userName']} has been added to the group!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
  
  void _makePhoneCall(String email) {
    Get.snackbar(
      'Phone Call',
      'Calling client...',
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