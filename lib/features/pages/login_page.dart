import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/features/pages/register_page.dart';
import 'package:cine_passe_app/features/pages/forgot_password_page.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';
import 'package:cine_passe_app/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
    
      context.read<AuthViewModel>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final panelBg = isDarkMode
        ? const Color(0xFF1C1C1C).withOpacity(0.75)
        : Colors.white.withOpacity(0.75);

    final auxTextColor = isDarkMode 
        ? const Color(0xFFC4C4C4) 
        : const Color(0xFF6B7280);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildAppTitle(theme),
                  const SizedBox(height: 40.0),
                  _buildLoginCard(panelBg, authViewModel, auxTextColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(Color panelBg, AuthViewModel viewModel, Color auxTextColor) {
    return Container(
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
                children: [
                  if (viewModel.errorMessage != null) _buildErrorBox(viewModel.errorMessage!),
                  
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => (val == null || !val.contains('@')) ? 'E-mail inválido' : null,
                  ),
                  const SizedBox(height: 16.0),
                  
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (val) => (val == null || val.length < 6) ? 'Senha muito curta' : null,
                  ),
                  const SizedBox(height: 20.0),
                  
                  _buildOptionsRow(auxTextColor),
                  const SizedBox(height: 20.0),
                  
                  CustomButton(
                    text: 'Entrar',
                    isLoading: viewModel.isLoading,
                    onPressed: viewModel.isLoading ? null : _handleLogin,
                  ),
                  
                  const SizedBox(height: 16.0),
                  _buildFooter(auxTextColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildErrorBox(String error) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        error,
        style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsRow(Color auxTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (val) => setState(() => _rememberMe = val ?? false),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
            Text('Lembrar-me', style: TextStyle(color: auxTextColor, fontSize: 12)),
          ],
        ),
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
          child: Text('Esqueceu a senha?', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildFooter(Color auxTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Não tem uma conta?', style: TextStyle(color: auxTextColor)),
        TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
          child: Text('Cadastre-se', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://i.imgur.com/UftFEv9.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.5))),
      ],
    );
  }

  Widget _buildAppTitle(ThemeData theme) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            text: 'CINE',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.primary,
              shadows: [Shadow(blurRadius: 10.0, color: Colors.black.withOpacity(0.8))],
            ),
            children: const [TextSpan(text: 'PASSE', style: TextStyle(color: Colors.white))],
          ),
        ),
        const Text('O próximo nível em entretenimento.', style: TextStyle(color: Color(0xFFC4C4C4), fontSize: 16)),
      ],
    );
  }
}