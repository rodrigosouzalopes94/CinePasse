import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cine_passe_app/features/controllers/registration_viewmodel.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';
import 'package:cine_passe_app/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers locais
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpfController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<RegistrationViewModel>();
    
    final success = await viewModel.register(
      name: _nameController.text,
      email: _emailController.text.trim(),
      password: _passwordController.text,
      cpf: _cpfController.text,
      age: int.tryParse(_ageController.text) ?? 0,
    );

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada! Faça login.'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RegistrationViewModel>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.75)
        : Colors.white.withOpacity(0.75);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildRegisterCard(panelBg, primaryColor, isDarkMode, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterCard(Color panelBg, Color primaryColor, bool isDarkMode, RegistrationViewModel viewModel) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(color: panelBg, borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(primaryColor, isDarkMode),
                  const SizedBox(height: 32.0),
                  
                  if (viewModel.errorMessage != null)
                    _buildErrorBox(viewModel.errorMessage!),

                  CustomTextField(
                    label: 'Nome Completo',
                    icon: Icons.person_outline,
                    controller: _nameController,
                    validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16.0),

                  CustomTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => !val!.contains('@') ? 'Email inválido' : null,
                  ),
                  const SizedBox(height: 16.0),

                  CustomTextField(
                    label: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    validator: (val) => val!.length < 6 ? 'Mínimo 6 caracteres' : null,
                  ),
                  const SizedBox(height: 16.0),

                  CustomTextField(
                    label: 'CPF',
                    icon: Icons.badge_outlined,
                    controller: _cpfController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),

                  CustomTextField(
                    label: 'Idade',
                    icon: Icons.calendar_today_outlined,
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32.0),

                  CustomButton(
                    text: 'CADASTRAR',
                    isLoading: viewModel.isLoading,
                    onPressed: viewModel.isLoading ? null : _handleRegister,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(child: Image.network('https://i.imgur.com/UftFEv9.png', fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildHeader(Color primaryColor, bool isDarkMode) {
    return Column(
      children: [
        Text('Criar Conta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor)),
        Text('Preencha seus dados abaixo', style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
      ],
    );
  }

  Widget _buildErrorBox(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(message, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    );
  }
}