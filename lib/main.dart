import 'package:flutter/material.dart';
import 'package:relationship_coach_flutter/screens/home_screen.dart';
import 'package:relationship_coach_flutter/screens/settings_screen.dart';

void main() {
  runApp(
    MaterialApp(
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
          body: const TabBarView(children: [HomeScreen(), SettingsScreen()]),
        ),
      ),
    ),
  );
}
