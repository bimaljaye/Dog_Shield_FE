import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dogshield_ai/core/constants/app_constants.dart';
import 'package:dogshield_ai/core/constants/app_theme.dart';
import 'package:dogshield_ai/core/utils/router.dart';
import 'package:dogshield_ai/presentation/screens/auth/login_screen.dart';

// Firebase imports
import 'package:firebase_core/firebase_core.dart';
// You'll need to generate this file using flutterfire configure
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('is_dark_mode') ?? false;
  
  // Initialize Firebase
  bool firebaseInitialized = false;
  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      // Note: You'll need to generate firebase_options.dart using FlutterFire CLI
    );
    firebaseInitialized = true;
    print('Firebase initialized successfully');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
    print('App will run with limited functionality');
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(isDarkMode),
      child: DogShieldApp(firebaseInitialized: firebaseInitialized),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;
  
  ThemeProvider(this._isDarkMode);
  
  bool get isDarkMode => _isDarkMode;
  
  ThemeData get themeData => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
  
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    
    // Save theme preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    
    notifyListeners();
  }
}

class DogShieldApp extends StatelessWidget {
  final bool firebaseInitialized;
  
  const DogShieldApp({
    super.key, 
    this.firebaseInitialized = false
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: AppConstants.appName,
          theme: themeProvider.themeData,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppConstants.loginRoute, // Start with login screen
          builder: (context, child) {
            if (!firebaseInitialized) {
              return _buildFirebaseWarningBanner(context, child);
            }
            return child!;
          },
        );
      },
    );
  }
  
  Widget _buildFirebaseWarningBanner(BuildContext context, Widget? child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.amber,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Running with limited functionality. Firebase is not initialized. See SETUP_GUIDE.md for instructions.',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: child ?? Container()),
          ],
        ),
      ),
    );
  }
}
