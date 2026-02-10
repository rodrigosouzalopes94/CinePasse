import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/widgets/custom_button.dart'; 
import 'package:cine_passe_app/widgets/custom_text_field.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController(); 

  String? _selectedPlan; 
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_initialized) {
      final user = context.watch<AuthViewModel>().userProfile;
      if (user != null) {
        _nameController.text = user.nome;
        _ageController.text = user.idade.toString();
        _emailController.text = user.email;
        _cpfController.text = user.cpf;
        _selectedPlan = user.planoAtual ?? 'Nenhum';
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<AuthViewModel>();
    
    await viewModel.updateProfileDetails(
      newName: _nameController.text,
      newAge: int.tryParse(_ageController.text) ?? 0,
      newPlan: _selectedPlan,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);

   
    if (viewModel.userProfile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final hasPlan = _selectedPlan != 'Nenhum';
    final validade = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 30)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatar(theme),
              const SizedBox(height: 32),
              
              CustomTextField(
                label: 'Nome',
                icon: Icons.person,
                controller: _nameController,
                validator: (val) => val!.isEmpty ? 'Nome obrigatório' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Idade',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                controller: _ageController,
              ),
              const SizedBox(height: 32),
              
              _buildPlanDropdown(),
              const SizedBox(height: 32),
              
              _buildReadOnlyInfo(theme),
              const SizedBox(height: 32),
              
              _buildPlanStatusCard(theme, hasPlan, validade),
              const SizedBox(height: 32),

              if (viewModel.errorMessage != null)
                _buildErrorBox(viewModel.errorMessage!, theme),
              
              CustomButton(
                text: 'SALVAR ALTERAÇÕES',
                isLoading: viewModel.isLoading,
                onPressed: viewModel.isLoading ? null : _handleUpdate,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildAvatar(ThemeData theme) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
      child: Text(
        _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
        style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildPlanDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPlan,
      decoration: const InputDecoration(
        labelText: 'Plano de Assinatura',
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        prefixIcon: Icon(FontAwesomeIcons.crown),
      ),
      items: ['Nenhum', 'Passe Premium', 'Família'].map((plan) {
        return DropdownMenuItem(value: plan, child: Text(plan));
      }).toList(),
      onChanged: (val) => setState(() => _selectedPlan = val),
    );
  }

  Widget _buildReadOnlyInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Informações da Conta', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        CustomTextField(label: 'E-mail', icon: Icons.email, controller: _emailController, readOnly: true),
        const SizedBox(height: 16),
        CustomTextField(label: 'CPF', icon: FontAwesomeIcons.idCard, controller: _cpfController, readOnly: true),
      ],
    );
  }

  Widget _buildPlanStatusCard(ThemeData theme, bool hasPlan, String validade) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasPlan ? Colors.green.withOpacity(0.1) : theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: hasPlan ? Colors.green : theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(hasPlan ? FontAwesomeIcons.crown : FontAwesomeIcons.ticket, 
               color: hasPlan ? Colors.green : Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hasPlan ? 'Plano Ativo: $_selectedPlan' : 'Plano Básico', 
                     style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(hasPlan ? 'Vencimento: $validade' : 'Assine para benefícios.', 
                     style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBox(String msg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(msg, style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center),
    );
  }
}