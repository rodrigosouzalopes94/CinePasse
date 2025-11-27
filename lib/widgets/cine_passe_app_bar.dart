import 'dart:ui'; // ✅ MOVIDO PARA O TOPO
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CinePasseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String telaAtual;
  final VoidCallback? onBackPress;
  final VoidCallback? onUserMenuPress;
  final VoidCallback? onThemeTogglePress;
  final VoidCallback? onLogoutPress;
  final bool isDarkMode;

  const CinePasseAppBar({
    super.key,
    required this.telaAtual,
    this.onBackPress,
    this.onUserMenuPress,
    this.onThemeTogglePress,
    this.onLogoutPress,
    required this.isDarkMode,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildLeading(BuildContext context) {
    // Botão Voltar aparece apenas em telas secundárias
    if (telaAtual == 'movieDetail' || telaAtual == 'planos') {
      return IconButton(
        icon: const Icon(FontAwesomeIcons.arrowLeft, size: 20),
        onPressed: onBackPress,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTitle(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final defaultTextStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 20);

    if (telaAtual == 'meusIngressos') {
      return RichText(
        text: TextSpan(
          style: defaultTextStyle,
          children: [
            TextSpan(
              text: 'MEUS',
              style: TextStyle(color: primaryColor),
            ),
            const TextSpan(text: ' INGRESSOS'),
          ],
        ),
      );
    } else {
      return RichText(
        text: TextSpan(
          style: defaultTextStyle,
          children: [
            TextSpan(
              text: 'CINE',
              style: TextStyle(color: primaryColor),
            ),
            const TextSpan(text: 'PASSE'),
          ],
        ),
      );
    }
  }

  List<Widget> _buildActions() {
    // A ordem aqui define a posição: Esquerda -> Direita
    return [
      // 1. Botão de Troca de Tema
      IconButton(
        onPressed: onThemeTogglePress,
        tooltip: 'Alternar Tema',
        icon: Icon(
          isDarkMode ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
          size: 20,
        ),
      ),

      // 2. ✅ Botão de Sair (Exatamente ao lado do Tema)
      // Ele aparecerá em TODAS as telas (Home, Ingressos, Planos)
      IconButton(
        // Se onLogoutPress for null, o botão ficará desabilitado (cinza).
        // Certifique-se de passá-lo no MainAppWrapper.
        onPressed: onLogoutPress,
        tooltip: 'Sair',
        icon: const Icon(
          FontAwesomeIcons.rightFromBracket, // Ícone de Logout
          size: 20,
        ),
      ),

      // 3. Menu de Usuário
      IconButton(
        onPressed: onUserMenuPress,
        icon: const Icon(FontAwesomeIcons.solidUser, size: 20),
      ),

      const SizedBox(width: 8),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 64,
      titleSpacing: 0,

      // Fundo com Blur para garantir visibilidade em cima de imagens
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color:
                Theme.of(
                  context,
                ).appBarTheme.backgroundColor?.withOpacity(0.8) ??
                Colors.white.withOpacity(0.8),
          ),
        ),
      ),

      leading: _buildLeading(context),

      title: Padding(
        padding: EdgeInsets.only(
          left: _buildLeading(context) is SizedBox ? 16.0 : 0,
          right: 16.0,
        ),
        child: _buildTitle(context),
      ),

      // As ações são renderizadas incondicionalmente aqui
      actions: _buildActions(),

      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
          height: 1.0,
        ),
      ),
    );
  }
}
