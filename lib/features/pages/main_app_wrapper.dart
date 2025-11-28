// ignore_for_file: deprecated_member_use

import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/pages/home_page.dart';
import 'package:cine_passe_app/features/pages/plans_page.dart';
import 'package:cine_passe_app/features/pages/tickets_page.dart';
// Ajuste os caminhos de import conforme sua estrutura real
// Se os arquivos estiverem em lib/pages/, use o caminho correspondente
// ✅ Import da PlansPage

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widgets
import 'package:cine_passe_app/widgets/cine_passe_app_bar.dart';

// Enum para identificar as abas da navegação inferior
enum TabItem { home, tickets, plans }

// Widget da Barra de Navegação Ajustado
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

    // Cor de fundo sólida ou semi-transparente para garantir leitura
    final backgroundColor = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.98)
        : Colors.white.withOpacity(0.98);

    return Container(
      // O Container desenha o fundo e a borda superior
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
      // 🚀 SafeArea envolve apenas os ícones/texto
      child: SafeArea(
        top: false, // Não precisa proteger o topo da barra
        child: BottomNavigationBar(
          currentIndex: TabItem.values.indexOf(currentTab),
          onTap: (index) => onSelectTab(TabItem.values[index]),

          // Estilização
          selectedItemColor: primaryColor,
          unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(
            0.5,
          ),
          backgroundColor:
              Colors.transparent, // Transparente para usar a cor do Container
          elevation: 0, // Remove a sombra padrão do Material
          type: BottomNavigationBarType.fixed, // Evita animação de "shifting"
          // Tamanho das fontes
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

  // ✅ Lista de páginas completa com a PlansPage
  final List<Widget> _pages = [
    const HomePage(),
    const TicketsPage(),
    const PlansPage(), // ✅ Adicionado aqui
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

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    // Mapeamento simples de títulos para o AppBar decidir o logo/texto
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
      // extendBody: true faz o corpo da página ir até o final da tela (atrás da navbar)
      extendBody: true,

      appBar: CinePasseAppBar(
        telaAtual: title,
        onBackPress: _currentTab != TabItem.home ? _handleBackPress : null,
        onThemeTogglePress: themeController.toggleTheme,
        onUserMenuPress: () => debugPrint('Menu Usuário'),

        // ✅ Implementação do Logout
        onLogoutPress: () {
          // Chama o logout do AuthController
          // O listener no main.dart vai detectar a mudança e redirecionar para Login
          context.read<AuthController>().logout();
        },

        isDarkMode: themeController.isDarkMode,
      ),

      // O IndexedStack preserva o estado das páginas quando troca de aba
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavBar(
        currentTab: _currentTab,
        onSelectTab: _selectTab,
      ),
    );
  }
}
