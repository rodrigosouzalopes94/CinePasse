// ignore_for_file: deprecated_member_use

import 'package:cine_passe_app/features/pages/main_app_wrapper.dart';
import 'package:flutter/material.dart';
import 'dart:ui'; // Para o BackdropFilter
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o controller (watch para reconstruir a tela em mudanças de estado)
    final controller = context.watch<AuthController>();
    // Acessa o controller apenas para leitura (chamar métodos)
    final authReader = context.read<AuthController>();

    final formKey = GlobalKey<FormState>();

    // Configurações visuais baseadas no tema e CSS original
    const String backgroundImageUrl = 'https://i.imgur.com/UftFEv9.png';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Define a cor do painel com transparência dependendo do tema
    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withValues(alpha: 0.75)
        : Colors.white.withOpacity(0.75);

    final auxTextColor = isDarkMode
        ? const Color(0xFFC4C4C4)
        : const Color(0xFF6B7280);

    return Scaffold(
      // Stack permite colocar a imagem de fundo atrás do conteúdo
      body: Stack(
        children: [
          // 1. Imagem de Fundo
          Positioned.fill(
            child: Image.network(
              backgroundImageUrl,
              fit: BoxFit.cover,
              // Fallback caso a imagem não carregue
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.black),
            ),
          ),

          // 2. Overlay Escuro (para melhorar legibilidade)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // 3. Conteúdo Principal Centralizado
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAppTitle(context),
                  const SizedBox(height: 40.0),

                  // Painel de Login (Container com Blur)
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: panelBg,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      // Efeito de desfoque no fundo do painel
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                // Mensagem de Erro (se houver)
                                if (controller.errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Text(
                                      controller.errorMessage!,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                // Campo Email
                                CustomTextField(
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: authReader.setEmail,
                                  validator: controller.validateEmail,
                                ),
                                const SizedBox(height: 16.0),

                                // Campo Senha
                                CustomTextField(
                                  label: 'Senha',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  onChanged: authReader.setPassword,
                                  validator: controller.validatePassword,
                                ),
                                const SizedBox(height: 20.0),

                                // Linha: Lembrar-me e Esqueceu a senha
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Checkbox "Lembrar-me"
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: controller.rememberMe,
                                          onChanged:
                                              authReader.toggleRememberMe,
                                          activeColor: primaryColor,
                                          side: BorderSide(color: auxTextColor),
                                        ),
                                        Text(
                                          'Lembrar-me',
                                          style: TextStyle(
                                            color: auxTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Link "Esqueceu a senha?"
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (ctx) =>
                                                const ForgotPasswordPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Esqueceu a senha?',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),

                                // Botão de Login
                                CustomButton(
                                  text: 'Entrar',
                                  isLoading: controller.isLoading,
                                  onPressed: controller.isLoading
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            authReader.login();
                                          }
                                        },
                                ),

                                const SizedBox(height: 16.0),

                                // Link para Cadastro
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
                                            builder: (ctx) =>
                                                const RegisterPage(),
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

                                // 🛠️ ÁREA DE DEBUG / ACESSO RÁPIDO
                                const SizedBox(height: 24.0),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '--- Acesso Rápido (Debug) ---',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: auxTextColor.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    // Pula a autenticação e vai direto para o App Principal
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (ctx) =>
                                            const MainAppWrapper(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.developer_mode,
                                    size: 16,
                                  ),
                                  label: const Text('Entrar Sem Login'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
              shadows: [
                Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.8)),
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
}
