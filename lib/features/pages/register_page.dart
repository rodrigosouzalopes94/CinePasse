// lib/features/auth/pages/registration_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/themed_input_field.dart';
import '../controllers/registration_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o Controller (estado e lógica)
    final controller = Provider.of<RegistrationController>(context);
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'), // Título em Português
        automaticallyImplyLeading: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),

        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título Principal
              Text(
                'Cadastre sua Conta', // Texto em Português
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Preencha os dados abaixo para criar sua conta.', // Texto em Português
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 32.0),

              // 1. Campo Nome
              ThemedInputField(
                label: 'Nome Completo', // Label em Português
                icon: Icons.person,
                validator: controller.validateName,
                onChanged: controller.setName,
              ),
              const SizedBox(height: 16.0),

              // 2. Campo Email
              ThemedInputField(
                label: 'Endereço de Email', // Label em Português
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
                onChanged: controller.setEmail,
              ),
              const SizedBox(height: 16.0),

              // 3. Campo Senha
              ThemedInputField(
                label: 'Senha', // Label em Português
                icon: Icons.lock,
                isPassword: true,
                validator: controller.validatePassword,
                onChanged: controller.setPassword,
              ),
              const SizedBox(height: 16.0),

              // 4. Campo CPF
              ThemedInputField(
                label: 'CPF (Documento)', // Label em Português
                icon: Icons.description,
                keyboardType: TextInputType.number,
                onChanged: controller.setCpf,
              ),
              const SizedBox(height: 16.0),

              // 5. Campo Idade
              ThemedInputField(
                label: 'Idade', // Label em Português
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    controller.setAge(int.tryParse(value) ?? 0),
              ),
              const SizedBox(height: 32.0),

              // Botão de Ação
              CustomButton(
                text: 'Cadastrar Conta', // Texto do botão em Português
                isLoading: controller.isLoading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.registerUser();
                  }
                },
              ),

              const SizedBox(height: 20.0),

              // Link para Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Já tem uma conta?", // Texto em Português
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar para a LoginPage (ou voltar)
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Entrar', // Texto em Português
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
    );
  }
}
