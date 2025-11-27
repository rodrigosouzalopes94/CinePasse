import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Necessário para o BackdropFilter

// Widgets Customizados
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart'; // ✅ Usando o componente correto

// Controllers
import '../controllers/registration_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o Controller
    final controller = context.watch<RegistrationController>();
    // Apenas para leitura (chamar métodos sem reconstruir)
    final reader = context.read<RegistrationController>();

    final formKey = GlobalKey<FormState>();

    // Configurações visuais (Idênticas ao Login para consistência)
    const String backgroundImageUrl = 'https://i.imgur.com/UftFEv9.png';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Fundo do painel com transparência
    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.75)
        : Colors.white.withOpacity(0.75);

    return Scaffold(
      // AppBar transparente para o botão de voltar aparecer em cima da imagem
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
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // 3. Conteúdo Centralizado
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
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Título
                            Text(
                              'Criar Conta',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Preencha seus dados abaixo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 32.0),

                            // Mensagem de Erro Geral
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

                            // 1. Nome Completo
                            CustomTextField(
                              label: 'Nome Completo',
                              icon: Icons.person_outline,
                              onChanged: reader.setName,
                              validator: controller.validateName,
                            ),
                            const SizedBox(height: 16.0),

                            // 2. Email
                            CustomTextField(
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: reader.setEmail,
                              validator: controller.validateEmail,
                            ),
                            const SizedBox(height: 16.0),

                            // 3. Senha
                            CustomTextField(
                              label: 'Senha',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              onChanged: reader.setPassword,
                              validator: controller.validatePassword,
                            ),
                            const SizedBox(height: 16.0),

                            // 4. CPF
                            CustomTextField(
                              label: 'CPF (apenas números)',
                              icon: Icons.badge_outlined,
                              keyboardType: TextInputType.number,
                              onChanged: reader.setCpf,
                              validator: controller.validateCpf,
                            ),
                            const SizedBox(height: 16.0),

                            // 5. Idade
                            CustomTextField(
                              label: 'Idade',
                              icon: Icons.calendar_today_outlined,
                              keyboardType: TextInputType.number,
                              onChanged: (val) => reader.setAge(val),
                              validator: controller.validateAge,
                            ),
                            const SizedBox(height: 32.0),

                            // Botão Cadastrar
                            CustomButton(
                              text: 'CADASTRAR',
                              isLoading: controller.isLoading,
                              onPressed: controller.isLoading
                                  ? null
                                  : () async {
                                      if (formKey.currentState!.validate()) {
                                        final success = await reader
                                            .registerUser();
                                        if (success && context.mounted) {
                                          // Sucesso: Volta para o login e mostra mensagem
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Conta criada com sucesso! Faça login.',
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        }
                                      }
                                    },
                            ),

                            const SizedBox(height: 20.0),

                            // Link Voltar para Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Já tem uma conta?',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? const Color(0xFFC4C4C4)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Entrar',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
