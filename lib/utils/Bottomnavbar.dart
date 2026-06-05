import 'package:flutter/material.dart';
import 'package:mztrackertodo/MainPage.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/views/Profile.dart';
import 'package:mztrackertodo/views/TaskStatus.dart';
import 'package:mztrackertodo/views/Todoist.dart';

class BottomnavbarPage extends StatefulWidget {
  const BottomnavbarPage({super.key});

  @override
  State<BottomnavbarPage> createState() => _BottomnavbarPageState();
}

class _BottomnavbarPageState extends State<BottomnavbarPage> {
  int index = 0;

  final screens = [
    MainPage(userdata: box.read('Name').toString()),
    const assign_task(),
    const TaskStatus(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        height: 60,
        backgroundColor: colors.navBackground,
        indicatorColor: colors.navIndicator,
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: colors.surface),
            icon: Icon(Icons.home_outlined, color: colors.textMuted),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_task, color: colors.surface),
            icon: Icon(Icons.add_task_outlined, color: colors.textMuted),
            label: 'Create',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.workspaces_filled, color: colors.surface),
            icon: Icon(Icons.workspaces_outline, color: colors.textMuted),
            label: 'Status',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2, color: colors.surface),
            icon: Icon(Icons.person_2_outlined, color: colors.textMuted),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
