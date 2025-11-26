import 'package:flutter/material.dart';
import 'dart:ui'; // Para o BackdropFilter
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart'; // ✅ NOVO IMPORT
import '../controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();
    final authReader = context.read<AuthController>();

    final formKey = GlobalKey<FormState>();
    const String backgroundImageUrl = 'https://i.imgur.com/UftFEv9.png';

    // Cores dinâmicas para o texto e plano de fundo
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Cor de fundo do painel de login: rgba(28, 28, 28, 0.75) ou rgba(255, 255, 255, 0.75)
    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.75);

    // Cor do texto auxiliar (cinza)
    final auxTextColor = isDarkMode ? const Color(0xFFC4C4C4) : const Color(0xFF6B7280);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagem de Fundo (login-screen)
          Positioned.fill(
            child: Image.network(backgroundImageUrl, fit: BoxFit.cover,
              // Fallback para caso a imagem falhe
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),

          // 2. Overlay Escuro (::before)
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),

          // 3. Conteúdo Principal
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppTitle(context),
                  const SizedBox(height: 40.0),

                  // Painel de Login (login-panel)
                  _buildLoginPanel(context, formKey, controller, authReader, panelBg, primaryColor, auxTextColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'CINE',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).colorScheme.primary,
              // Adiciona a sombra para melhor visibilidade no fundo
              shadows: [
                Shadow(blurRadius: 10.0, color: Colors.black.withValues(alpha: 0.8)),
              ],
            ),
            children: const [
              TextSpan(
                text: 'PASSE',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4.0),
        const Text(
          'O próximo nível em entretenimento.',
          style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildLoginPanel(
      BuildContext context,
      GlobalKey<FormState> formKey,
      AuthController controller,
      AuthController authReader,
      Color panelBg,
      Color primaryColor,
      Color auxTextColor,
      ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: panelBg, // Cor de fundo com opacidade
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // backdrop-blur-lg
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // 🚨 Exibe mensagem de erro (se houver)
                  if (controller.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        controller.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // ✅ Campo Email - Agora usando CustomTextField
                  CustomTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: authReader.setEmail,
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 16.0),

                  // ✅ Campo Senha - Agora usando CustomTextField
                  CustomTextField(
                    label: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: authReader.setPassword,
                    validator: controller.validatePassword,
                  ),
                  const SizedBox(height: 20.0),

                  // Lembre-me e Esqueceu a senha?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: controller.rememberMe,
                            onChanged: authReader.toggleRememberMe,
                            activeColor: primaryColor,
                          ),
                          Text(
                            'Lembrar-me',
                            style: TextStyle(color: auxTextColor),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar tela de recuperação de senha
                        },
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Botão Entrar
                  CustomButton(
                    text: 'Entrar',
                    isLoading: controller.isLoading,
                    onPressed: controller.isLoading
                        ? null
                        : () {
                      if (formKey.currentState!.validate()) {
                        authReader.login();
                      }
                    },
                  ),

                  const SizedBox(height: 16.0),

                  // Link Cadastre-se
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não tem uma conta?',
                        style: TextStyle(color: auxTextColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => const RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Cadastre-se',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}