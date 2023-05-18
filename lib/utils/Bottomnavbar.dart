import 'package:flutter/material.dart';
import 'package:mztrackertodo/MainPage.dart';
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
    MainPage(userdata: box.read("Name").toString()),
    const assign_task(),
    const TaskStatus(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
            backgroundColor: Colors.white,
            indicatorColor: Color.fromARGB(255, 255, 128, 119),
            labelTextStyle: MaterialStatePropertyAll(
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        child: NavigationBar(
          height: 60,
          selectedIndex: index,
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(
                selectedIcon: Icon(Icons.home),
                icon: Icon(Icons.home_outlined),
                label: 'Home'),
            NavigationDestination(
                selectedIcon: Icon(Icons.add_task),
                icon: Icon(Icons.add_task_outlined),
                label: 'Create'),
            NavigationDestination(
                selectedIcon: Icon(Icons.workspaces_filled),
                icon: Icon(Icons.workspaces_outline),
                label: 'Status'),
            NavigationDestination(
                selectedIcon: Icon(Icons.person_2),
                icon: Icon(Icons.person_2_outlined),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
