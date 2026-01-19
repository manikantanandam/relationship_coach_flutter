import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relationship_coach_flutter/providers/user_settings_provider.dart';
import 'package:relationship_coach_flutter/screens/home_screen.dart';
import 'package:relationship_coach_flutter/screens/settings_screen.dart';
import 'package:relationship_coach_flutter/providers/iap_provider.dart';
import 'package:relationship_coach_flutter/services/local_feature_flag_manager.dart';
import 'package:relationship_coach_flutter/theme/dark_theme.dart';
import 'package:relationship_coach_flutter/theme/light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Generated file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalFeatureFlagManager().init();
  runApp(
    MultiProvider(
      providers: [
        // 1. In-App Purchase Provider
        ChangeNotifierProvider(create: (_) => IAPProvider()),

        // 2. User Settings Provider
        ChangeNotifierProvider(create: (_) => UserSettingsProvider()),
      ],
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            bottomNavigationBar: BottomAppBar(
              child: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.settings)),
                ],
              ),
            ),
            body: TabBarView(children: [const HomeScreen(), SettingsScreen()]),
          ),
        ),
      ),
    ),
  );
}
