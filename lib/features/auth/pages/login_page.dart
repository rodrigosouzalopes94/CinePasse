// lib/features/auth/pages/login_page.dart

import 'package:flutter/material.dart';
import 'dart:ui'; // Para o BackdropFilter
import 'package:provider/provider.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/themed_input_field.dart';
import '../controllers/auth_controller.dart'; // Importa o Controller de Login
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o Controller (listener: true, para reconstruir a UI)
    final controller = context.watch<AuthController>();
    // Usamos 'watch' para que a tela seja reconstruída quando o estado (isLoading, errorMessage) mudar.

    // 2. Acessa o Controller sem ouvir (listener: false)
    // Usamos 'read' quando só queremos chamar métodos (como login), sem reconstruir.
    final authReader = context.read<AuthController>();

    final formKey = GlobalKey<FormState>();
    const String backgroundImageUrl = 'https://i.imgur.com/UftFEv9.png';

    return Scaffold(
      body: Stack(
        children: [
          // 1. Imagem de Fundo
          Positioned.fill(
            child: Image.network(backgroundImageUrl, fit: BoxFit.cover),
          ),

          // 2. Overlay Escuro
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

                  // Painel de Login
                  _buildLoginPanel(context, formKey, controller, authReader),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    // (Implementação do _buildAppTitle mantida em Português)
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
                Shadow(blurRadius: 15.0, color: Colors.black.withValues(alpha: 0.7)),
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
    AuthController controller, // Controller que está sendo 'watched'
    AuthController
    authReader, // Controller que é usado apenas para chamar funções
  ) {
    final blurColor = Theme.of(context).cardColor.withValues(alpha: 0.75);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: blurColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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

                  // Campo Email
                  ThemedInputField(
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: authReader
                        .setEmail, // Usa o Reader para chamar o setter
                    validator: controller.validateEmail,
                  ),
                  const SizedBox(height: 16.0),

                  // Campo Senha
                  ThemedInputField(
                    label: 'Senha',
                    icon: Icons.lock,
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
                            activeColor: Theme.of(context).colorScheme.primary,
                          ),
                          const Text(
                            'Lembrar-me',
                            style: TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar tela de recuperação de senha
                        },
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Botão Entrar
                  CustomButton(
                    text: 'Entrar',
                    isLoading: controller
                        .isLoading, // Pega o estado de loading do Controller
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              authReader
                                  .login(); // Chama a lógica de login do Controller
                            }
                          },
                  ),

                  const SizedBox(height: 16.0),

                  // Link Cadastre-se
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Não tem uma conta?',
                        style: TextStyle(color: Color(0xFF9CA3AF)),
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
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
