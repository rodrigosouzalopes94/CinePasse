import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CinePasseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String telaAtual;
  final VoidCallback? onBackPress;
  final VoidCallback? onUserMenuPress;
  final VoidCallback? onThemeTogglePress;
  final bool isDarkMode;

  const CinePasseAppBar({
    super.key,
    required this.telaAtual,
    this.onBackPress,
    this.onUserMenuPress,
    this.onThemeTogglePress,
    required this.isDarkMode,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildLeading(BuildContext context) {
    if (telaAtual == 'movieDetail' || telaAtual == 'planos') {
      return IconButton(
        // <i class="fas fa-arrow-left"></i>
        icon: const Icon(FontAwesomeIcons.arrowLeft, size: 20),
        onPressed: onBackPress,
      );
    }
    return const SizedBox.shrink(); // Widget vazio
  }

  Widget _buildTitle(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final defaultTextStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    // Corresponde a h1 v-else-if="telaAtual === 'meusIngressos'"
    if (telaAtual == 'meusIngressos') {
      return RichText(
        text: TextSpan(
          style: defaultTextStyle,
          children: [
            TextSpan(text: 'MEUS', style: TextStyle(color: primaryColor)),
            const TextSpan(text: ' INGRESSOS'),
          ],
        ),
      );
    }
    // Corresponde a h1 v-else (CINEPASSE)
    else {
      return RichText(
        text: TextSpan(
          style: defaultTextStyle,
          children: [
            TextSpan(text: 'CINE', style: TextStyle(color: primaryColor)),
            const TextSpan(text: 'PASSE'),
          ],
        ),
      );
    }
  }

  List<Widget> _buildActions() {
    return [
      // 1. Botão Alternar Tema (darkMode)
      IconButton(
        onPressed: onThemeTogglePress,
        // <i :class="!darkMode ? 'fas fa-moon' : 'fas fa-sun'"></i>
        icon: Icon(
          isDarkMode ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
          size: 20,
        ),
      ),
      // 2. Botão Menu do Usuário
      IconButton(
        onPressed: onUserMenuPress,
        // <i class="fas fa-user"></i>
        icon: const Icon(FontAwesomeIcons.solidUser, size: 20),
      ),
      const SizedBox(width: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // themed-bg-light/80 border-b themed-border / backdrop-filter: blur(16px)
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64, // Ajuste de altura
      titleSpacing: 0,

      // Simulação do BackdropFilter e Padding
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur
          child: Container(
            color: Theme.of(context).appBarTheme.backgroundColor?.withValues(alpha: 0.8) ?? Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),

      leading: _buildLeading(context),

      title: Padding(
        padding: EdgeInsets.only(left: _buildLeading(context) is SizedBox ? 16.0 : 0, right: 16.0),
        child: _buildTitle(context),
      ),
      actions: _buildActions(),

      // themed-border
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          height: 1.0,
        ),
      ),
    );
  }
}

// Para usar o BackdropFilter
import 'dart:ui';