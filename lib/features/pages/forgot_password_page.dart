import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Necessário para o BackdropFilter

import 'package:cine_passe_app/widgets/custom_button.dart';
import 'package:cine_passe_app/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o AuthController para saber de loading/erros
    final authController = context.watch<AuthController>();
    // Escuta o tema para modo escuro/claro
    final isDarkMode = Provider.of<ThemeController>(context).isDarkMode;

    // Configurações de Estilo
    const String backgroundImageUrl = 'https://i.imgur.com/UftFEv9.png';
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Cor do painel com transparência
    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.75)
        : Colors.white.withOpacity(0.75);

    return Scaffold(
      // Estende o corpo atrás da AppBar para manter o fundo imersivo
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 1. Imagem de Fundo
          Positioned.fill(
            child: Image.network(
              backgroundImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),
          // 2. Overlay Escuro
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // 3. Conteúdo Central
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: panelBg,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.lock_reset,
                              size: 50,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),

                            // Título
                            Text(
                              'Recuperar Senha',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                            ),
                            const SizedBox(height: 8),

                            // Descrição
                            Text(
                              'Digite seu email para receber o link de redefinição.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Mensagem de Erro (Feedback visual)
                            if (authController.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Text(
                                  authController.errorMessage!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Campo de Email
                            CustomTextField(
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              // Atualiza o controller local ao digitar
                              onChanged: (val) => _emailController.text = val,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Digite seu email';
                                }
                                if (!val.contains('@')) {
                                  return 'Email inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Botão de Enviar
                            CustomButton(
                              text: 'ENVIAR EMAIL',
                              isLoading: authController.isLoading,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Chama o método do AuthController para resetar a senha
                                  final success = await context
                                      .read<AuthController>()
                                      .resetPassword(_emailController.text);

                                  // Verifica se o widget ainda está na árvore antes de usar o contexto
                                  if (success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Email enviado! Verifique sua caixa de entrada.',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // Retorna para a tela de login
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
