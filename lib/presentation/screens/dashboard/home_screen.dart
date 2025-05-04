import 'package:flutter/material.dart';
import 'package:dogshield_ai/core/constants/app_constants.dart';
import 'package:dogshield_ai/core/constants/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  // TODO: Replace with real data
  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Max',
      'breed': 'Golden Retriever',
      'age': '3 years',
      'imageUrl': null, // Will be replaced with actual image
    },
    {
      'name': 'Bella',
      'breed': 'Labrador',
      'age': '1 year',
      'imageUrl': null,
    },
  ];
  
  final List<Map<String, dynamic>> _upcomingReminders = [
    {
      'title': 'Vaccination',
      'petName': 'Max',
      'date': 'Tomorrow, 10:00 AM',
      'type': AppConstants.typeVaccination,
    },
    {
      'title': 'Deworming',
      'petName': 'Bella',
      'date': 'Thursday, 8:00 AM',
      'type': AppConstants.typeDeworming,
    },
    {
      'title': 'Feeding',
      'petName': 'Max',
      'date': 'Today, 6:00 PM',
      'type': AppConstants.typeFeeding,
    },
  ];
  
  final List<Map<String, dynamic>> _recentActivities = [
    {
      'title': 'Rabies Vaccination',
      'petName': 'Max',
      'date': '2 days ago',
      'description': 'Completed rabies vaccination',
    },
    {
      'title': 'Weight Check',
      'petName': 'Bella',
      'date': '1 week ago',
      'description': 'Current weight: 22.5 kg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DogShield AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.settingsRoute);
            },
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AI detection screen
          Navigator.pushNamed(context, AppConstants.aiDetectionRoute);
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'John Doe', // TODO: Replace with actual user name
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'john.doe@example.com', // TODO: Replace with actual email
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('My Pets'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to pets screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Reminders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.reminderRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('AI Detection'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.aiDetectionRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Detection History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.detectionHistoryRoute);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppConstants.settingsRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to help screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement sign out
              Navigator.pushReplacementNamed(context, AppConstants.loginRoute);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet carousel
            _buildPetCarousel(),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 24),
            
            // Upcoming Reminders
            _buildSectionHeader('Upcoming Reminders', AppConstants.reminderRoute),
            const SizedBox(height: 12),
            _buildUpcomingReminders(),
            const SizedBox(height: 24),
            
            // Recent Activities
            _buildSectionHeader('Recent Activities', null),
            const SizedBox(height: 12),
            _buildRecentActivities(),
            const SizedBox(height: 24),
            
            // Health Tips
            _buildHealthTips(),
            
            // Extra space for floating action button
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPetCarousel() {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pets.length + 1, // +1 for the add new pet card
        itemBuilder: (context, index) {
          if (index == _pets.length) {
            // Add new pet card
            return _buildAddPetCard();
          }
          
          final pet = _pets[index];
          return _buildPetCard(pet);
        },
      ),
    );
  }
  
  Widget _buildPetCard(Map<String, dynamic> pet) {
    return GestureDetector(
      onTap: () {
        // Navigate to pet profile screen
        Navigator.pushNamed(
          context, 
          AppConstants.petProfileRoute,
          arguments: pet,
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet image
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.pets,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            // Pet info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet['name'] ?? 'Unknown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pet['breed']} • ${pet['age']}',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddPetCard() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppConstants.addPetRoute);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 40,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Add New Pet',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildQuickActionItem(
              icon: Icons.camera_alt,
              label: 'AI Detection',
              onTap: () => Navigator.pushNamed(context, AppConstants.aiDetectionRoute),
            ),
            _buildQuickActionItem(
              icon: Icons.medication,
              label: 'Add Medication',
              onTap: () => Navigator.pushNamed(context, AppConstants.addReminderRoute),
            ),
            _buildQuickActionItem(
              icon: Icons.calendar_today,
              label: 'Add Reminder',
              onTap: () => Navigator.pushNamed(context, AppConstants.addReminderRoute),
            ),
            _buildQuickActionItem(
              icon: Icons.history,
              label: 'History',
              onTap: () => Navigator.pushNamed(context, AppConstants.detectionHistoryRoute),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, String? routeName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (routeName != null)
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, routeName);
            },
            child: const Text('See All'),
          ),
      ],
    );
  }
  
  Widget _buildUpcomingReminders() {
    if (_upcomingReminders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_available,
        message: 'No upcoming reminders',
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _upcomingReminders.length > 3 ? 3 : _upcomingReminders.length,
      itemBuilder: (context, index) {
        final reminder = _upcomingReminders[index];
        return _buildReminderCard(reminder);
      },
    );
  }
  
  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    IconData iconData;
    Color iconColor;
    
    switch (reminder['type']) {
      case AppConstants.typeVaccination:
        iconData = Icons.medical_services;
        iconColor = AppTheme.primaryColor;
        break;
      case AppConstants.typeMedication:
        iconData = Icons.medication;
        iconColor = AppTheme.warningColor;
        break;
      case AppConstants.typeFeeding:
        iconData = Icons.restaurant;
        iconColor = AppTheme.successColor;
        break;
      case AppConstants.typeDeworming:
        iconData = Icons.healing;
        iconColor = AppTheme.errorColor;
        break;
      default:
        iconData = Icons.event;
        iconColor = AppTheme.infoColor;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(
            iconData,
            color: iconColor,
          ),
        ),
        title: Text(reminder['title']),
        subtitle: Text('${reminder['petName']} • ${reminder['date']}'),
        trailing: IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            // TODO: Navigate to reminder details
          },
        ),
      ),
    );
  }
  
  Widget _buildRecentActivities() {
    if (_recentActivities.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        message: 'No recent activities',
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentActivities.length,
      itemBuilder: (context, index) {
        final activity = _recentActivities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(activity['title']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${activity['petName']} • ${activity['date']}'),
                Text(
                  activity['description'],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
  
  Widget _buildHealthTips() {
    return Card(
      color: AppTheme.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Tip',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Regular exercise is essential for your dog\'s physical and mental health. Aim for at least 30 minutes of activity each day.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to health tips screen
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                child: const Text('Read More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        
        // TODO: Implement navigation between tabs
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Pets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Reminders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
} 