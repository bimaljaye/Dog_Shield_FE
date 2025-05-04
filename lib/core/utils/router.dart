import 'package:flutter/material.dart';
import 'package:dogshield_ai/core/constants/app_constants.dart';

// Screens
import 'package:dogshield_ai/presentation/screens/auth/login_screen.dart';
import 'package:dogshield_ai/presentation/screens/auth/register_screen.dart';
import 'package:dogshield_ai/presentation/screens/dashboard/home_screen.dart';
import 'package:dogshield_ai/presentation/screens/pet_profile/add_pet_screen.dart';
import 'package:dogshield_ai/presentation/screens/ai_detection/ai_detection_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      case AppConstants.registerRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
        
      case AppConstants.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        
      case AppConstants.addPetRoute:
        return MaterialPageRoute(builder: (_) => const AddPetScreen());
        
      case AppConstants.aiDetectionRoute:
        return MaterialPageRoute(builder: (_) => const AIDetectionScreen());
        
      // TODO: Add other routes as they are implemented
      case AppConstants.petProfileRoute:
        // final pet = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Pet Profile')),
            body: const Center(
              child: Text('Pet Profile Screen - To be implemented'),
            ),
          ),
        );
        
      case AppConstants.reminderRoute:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Reminders')),
            body: const Center(
              child: Text('Reminders Screen - To be implemented'),
            ),
          ),
        );
        
      case AppConstants.addReminderRoute:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Add Reminder')),
            body: const Center(
              child: Text('Add Reminder Screen - To be implemented'),
            ),
          ),
        );
        
      case AppConstants.detectionHistoryRoute:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Detection History')),
            body: const Center(
              child: Text('Detection History Screen - To be implemented'),
            ),
          ),
        );
        
      case AppConstants.settingsRoute:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Settings')),
            body: const Center(
              child: Text('Settings Screen - To be implemented'),
            ),
          ),
        );
        
      case AppConstants.forgotPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Forgot Password')),
            body: const Center(
              child: Text('Forgot Password Screen - To be implemented'),
            ),
          ),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 