import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          // Desktop/Wide Layout
          return Scaffold(
            body: Row(
              key: const Key('dashboard_desktop_layout'),
              children: [
                const SizedBox(
                  width: 250,
                  child: Sidebar(),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'VERBADENT',
                        style: TextStyle(
                          fontFamily: 'KumarOne',
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2B57),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Mobile/Narrow Layout
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF5483F5),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            drawer: const Drawer(
              key: Key('dashboard_mobile_drawer'),
              width: 250,
              child: Sidebar(),
            ),
            body: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'VERBADENT',
                  style: TextStyle(
                    fontFamily: 'KumarOne',
                    fontSize: 40, // Smaller font for mobile
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2B57),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5483F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 100), // Spacing from top
          SidebarItem(
              key: const Key('sidebar_item_before_visit'),
              label: 'Before the visit',
              onTap: () {}),
          const SizedBox(height: 20),
          SidebarItem(
              key: const Key('sidebar_item_during_visit'),
              label: 'During the visit',
              onTap: () {}),
          const SizedBox(height: 20),
          SidebarItem(
              key: const Key('sidebar_item_build_own'),
              label: 'Build your own',
              onTap: () {}),
          const SizedBox(height: 20),
          SidebarItem(
              key: const Key('sidebar_item_library'),
              label: 'Library',
              onTap: () {}),
          const Spacer(), // Push content up
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(
            horizontal: 0), // Full width relative to sidebar
        color: const Color(0xFFD9D9D9),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'KumarOne',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
