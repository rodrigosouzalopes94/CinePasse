

import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/pages/home_page.dart';
import 'package:cine_passe_app/features/pages/plans_page.dart';
import 'package:cine_passe_app/features/pages/tickets_page.dart';
import 'package:cine_passe_app/features/pages/profile_page.dart'; 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:cine_passe_app/widgets/cine_passe_app_bar.dart';


enum TabItem { home, tickets, plans }


class BottomNavBar extends StatelessWidget {
  final TabItem currentTab;
  final Function(TabItem) onSelectTab;

  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDarkMode = theme.brightness == Brightness.dark;

    
    final backgroundColor = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.98)
        : Colors.white.withOpacity(0.98);

    return Container(
      
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      
      child: SafeArea(
        top: false, 
        child: BottomNavigationBar(
          currentIndex: TabItem.values.indexOf(currentTab),
          onTap: (index) => onSelectTab(TabItem.values[index]),

          
          selectedItemColor: primaryColor,
          unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(
            0.5,
          ),
          backgroundColor:
              Colors.transparent, 
          elevation: 0, 
          type: BottomNavigationBarType.fixed, 
          
          
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded),
              label: 'Ingressos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_rounded),
              label: 'Planos',
            ),
          ],
        ),
      ),
    );
  }
}

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  TabItem _currentTab = TabItem.home;
  int _currentIndex = 0;

  final Map<TabItem, int> tabToIndex = {
    TabItem.home: 0,
    TabItem.tickets: 1,
    TabItem.plans: 2,
  };

  
  final List<Widget> _pages = [
    const HomePage(),
    const TicketsPage(),
    const PlansPage(), 
  ];

  void _selectTab(TabItem tabItem) {
    if (_currentTab != tabItem) {
      setState(() {
        _currentTab = tabItem;
        _currentIndex = tabToIndex[tabItem]!;
      });
    }
  }

  void _handleBackPress() {
    setState(() {
      _currentTab = TabItem.home;
      _currentIndex = tabToIndex[TabItem.home]!;
    });
  }
  
  
  void _navigateToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfilePage(), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    
    String title;
    switch (_currentTab) {
      case TabItem.home:
        title = 'home';
        break;
      case TabItem.tickets:
        title = 'meusIngressos';
        break;
      case TabItem.plans:
        title = 'planos';
        break;
    }

    return Scaffold(
      
      extendBody: true,

      appBar: CinePasseAppBar(
        telaAtual: title,
        onBackPress: _currentTab != TabItem.home ? _handleBackPress : null,
        onThemeTogglePress: themeController.toggleTheme,
        
        
        onUserMenuPress: _navigateToProfile, 

        
        onLogoutPress: () {
          
          context.read<AuthViewModel>().logout();
        },

        isDarkMode: themeController.isDarkMode,
      ),

      
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavBar(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
    );
  }
}