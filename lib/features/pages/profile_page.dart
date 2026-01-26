import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


import 'package:cine_passe_app/widgets/custom_button.dart'; 
import 'package:cine_passe_app/widgets/custom_text_field.dart'; 



import 'package:firebase_auth/firebase_auth.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _ageController = TextEditingController();
  
  
  String? _selectedPlan; 
  
  
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _cpfController = TextEditingController(); 

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _userProfile;
  bool _isInitializing = true; 

  
  final List<String> _planOptions = const [
    'Nenhum',
    'Passe Premium',
    'Família',
  ];

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData(context.read<AuthController>());
    });
  }

  
  Future<void> _loadProfileData(AuthController authController) async {
    setState(() => _isLoading = true);
    
    
    await authController.fetchUserProfile();
    
    if (mounted && authController.userProfile != null) {
      _setupControllers(authController.userProfile!);
    }
    
    if (mounted) setState(() {
      _isLoading = false;
      _isInitializing = false;
    });
  }
  
  void _setupControllers(UserModel profile) {
    _userProfile = profile;
    _nameController = TextEditingController(text: profile.nome);
    _ageController = TextEditingController(text: profile.idade.toString());
    _emailController = TextEditingController(text: profile.email);
    _cpfController = TextEditingController(text: profile.cpf);
    
    _selectedPlan = profile.planoAtual; 
  }


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate() || _userProfile == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authController = context.read<AuthController>();
    final newName = _nameController.text;
    final newAge = int.tryParse(_ageController.text) ?? _userProfile!.idade;
    
    try {
      
      await authController.updateProfileDetails(
        newName: newName, 
        newAge: newAge,
        newPlan: _selectedPlan, 
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _userProfile = authController.userProfile; 
        });
        
        
        Navigator.of(context).pop(); 
        
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Erro Firebase: ${e.message}';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Ocorreu um erro: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isInitializing || _isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Carregando Perfil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_userProfile == null) {
      
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Text('Falha ao carregar dados do usuário.', style: TextStyle(color: theme.colorScheme.error)),
        ),
      );
    }
    
    
    final bool hasPlan = _userProfile!.planoAtual != 'Nenhum' && _userProfile!.planoAtual != null;
    
    final String validade = DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 30)));

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
              
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'U',
                  style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(height: 32),
              
              
              
              
              
              
              CustomTextField(
                label: 'Nome',
                icon: Icons.person,
                
                controller: _nameController, 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome não pode ser vazio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              
              CustomTextField(
                label: 'Idade',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                controller: _ageController,
                validator: (value) {
                  if (int.tryParse(value ?? '') == null) {
                    return 'Idade inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              
              
              
              
              DropdownButtonFormField<String>(
                value: _selectedPlan,
                decoration: const InputDecoration(
                  labelText: 'Plano de Assinatura',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                  prefixIcon: Icon(FontAwesomeIcons.crown),
                ),
                items: _planOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPlan = newValue;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Selecione um plano' : null,
              ),
              const SizedBox(height: 32),

              
              
              
              
              Text(
                'Informações da Conta (Somente Leitura)',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              
              CustomTextField(
                label: 'E-mail',
                icon: Icons.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
                
              ),
              const SizedBox(height: 16),
              
              
              CustomTextField(
                label: 'CPF',
                icon: FontAwesomeIcons.idCard,
                controller: _cpfController,
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              
              const SizedBox(height: 32),
              
              
              
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: hasPlan ? Colors.green.withOpacity(0.1) : theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: hasPlan ? Colors.green : theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasPlan ? FontAwesomeIcons.crown : FontAwesomeIcons.ticket,
                      color: hasPlan ? Colors.green : Colors.grey.shade700,
                      size: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasPlan ? 'Plano Ativo: ${_userProfile!.planoAtual}' : 'Plano Básico (Gratuito)',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            hasPlan
                                ? 'Próxima Vencimento: $validade' 
                                : 'Assine um plano para benefícios ilimitados.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                
              
              CustomButton(
                text: 'SALVAR ALTERAÇÕES',
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _updateProfile,
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}