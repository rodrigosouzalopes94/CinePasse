// lib/pages/main_app_wrapper.dart

import 'package:flutter/material.dart';
import '../../../widgets/bottom_nav_bar.dart';
// Importe as páginas que serão as abas (vamos criá-las em seguida)
import 'home/home_page.dart';
import 'tickets/tickets_page.dart';
import 'plans/plans_page.dart';

class MainAppWrapper extends StatefulWidget {
  const MainAppWrapper({super.key});

  @override
  State<MainAppWrapper> createState() => _MainAppWrapperState();
}

class _MainAppWrapperState extends State<MainAppWrapper> {
  // 1. Gerencia o estado da aba ativa
  TabItem _currentTab = TabItem.home;
  int _currentIndex = 0; // Index para o IndexedStack

  // Mapeia o Enum para o Index e para a Tela (Page)
  final Map<TabItem, int> tabToIndex = {
    TabItem.home: 0,
    TabItem.tickets: 1,
    TabItem.plans: 2,
  };

  // 2. Lista de Telas Principais (serão construídas aqui)
  final List<Widget> _pages = [
    const HomePage(),
    const TicketsPage(),
    const PlansPage(),
  ];

  // 3. Função de Callback para o BottomNavBar
  void _selectTab(TabItem tabItem) {
    if (_currentTab != tabItem) {
      setState(() {
        _currentTab = tabItem;
        _currentIndex = tabToIndex[tabItem]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A AppBar não é obrigatória para a Home, mas pode ser útil para o título/botão de perfil
      appBar: AppBar(
        title: Text(
          _currentTab == TabItem.home
              ? 'CINEPASSE'
              : _currentTab.name.toUpperCase(),
        ),
        automaticallyImplyLeading: false, // Esconde o botão voltar
      ),

      // 4. IndexedStack: Apenas o conteúdo visível é reconstruído/exibido
      body: IndexedStack(index: _currentIndex, children: _pages),

      // 5. BottomNavigationBar: A barra de navegação vive aqui
      bottomNavigationBar: BottomNavBar(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
    );
  }
}
