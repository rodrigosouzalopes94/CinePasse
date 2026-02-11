import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cine_passe_app/features/controllers/reservation_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/features/repositories/authrepository/i_auth_repository.dart';
import 'package:cine_passe_app/features/services/reservation_service.dart';


import 'package:cine_passe_app/models/movie_model.dart';
import 'package:cine_passe_app/widgets/custom_button.dart';

class ReservationModal extends StatelessWidget {
  final MovieModel movie;

  const ReservationModal({super.key, required this.movie});

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          'Solicitação de reserva enviada!\n\nSeu voucher está aguardando aprovação na aba "Meus Ingressos".',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.read<AuthViewModel>();
    final userId = authViewModel.userProfile?.uid ?? '';

    return ChangeNotifierProvider(
      create: (ctx) => ReservationViewModel(
        ReservationService(),
        ctx.read<IAuthRepository>(),
        ctx.read<TicketViewModel>(),
      )..initialize(userId),
      child: Consumer<ReservationViewModel>(
        builder: (ctx, viewModel, child) {
          
          if (viewModel.isTimeout.value && Navigator.canPop(ctx)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tempo de reserva esgotado.'), backgroundColor: Colors.red),
              );
            });
          }

          return Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTimerHeader(theme, viewModel),
                  const SizedBox(height: 24),
                  _buildMovieDetails(theme, viewModel),
                  const SizedBox(height: 24),
                  if (viewModel.isLoadingProfile)
                    const Center(child: Padding(padding: EdgeInsets.all(40.0), child: CircularProgressIndicator()))
                  else
                    Column(
                      children: [
                        _buildTimeSelection(theme, viewModel),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        _buildSummaryAndButton(theme, viewModel, ctx),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  

  Widget _buildTimerHeader(ThemeData theme, ReservationViewModel viewModel) {
    return ValueListenableBuilder<int>(
      valueListenable: viewModel.remainingSeconds,
      builder: (context, seconds, child) {
        final String formattedTime =
            '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Reserva de Ingresso', style: TextStyle(color: Colors.grey)),
            Text(formattedTime, style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
          ],
        );
      },
    );
  }

  Widget _buildMovieDetails(ThemeData theme, ReservationViewModel viewModel) {
    final bool hasPlan = viewModel.hasActivePlan;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(movie.imagemUrl, width: 80, height: 120, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movie.titulo, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(hasPlan ? 'Plano Ativo: ${viewModel.userProfile?.planoAtual}' : 'Pagamento Avulso',
                  style: TextStyle(color: hasPlan ? Colors.purple : Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection(ThemeData theme, ReservationViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Horário da Sessão', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: viewModel.sessionTimes.map((time) {
            final isSelected = viewModel.selectedTime == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (selected) => viewModel.setSelectedTime(selected ? time : null),
              selectedColor: theme.colorScheme.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryAndButton(ThemeData theme, ReservationViewModel viewModel, BuildContext context) {
    final bool hasPlan = viewModel.hasActivePlan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(hasPlan ? 'R\$ 0,00' : 'R\$ 25,00', 
                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: hasPlan ? Colors.green : null)),
          ],
        ),
        const SizedBox(height: 24),
        CustomButton(
          // O texto muda para deixar claro o próximo passo
          text: hasPlan ? 'CONFIRMAR RESERVA' : 'IR PARA PAGAMENTO',
          isLoading: viewModel.ticketViewModel.isLoading,
          onPressed: viewModel.selectedTime == null
              ? null
              : () async {
                  
                  final success = await viewModel.handleReservationFlow(context, movie.titulo);
                  
                  if (success && context.mounted) {
                    
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    _showSuccessDialog(context);
                  }
                },
        ),
      ],
    );
  }
}