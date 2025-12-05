import 'dart:async';
import 'package:cine_passe_app/features/controllers/reservation_controller.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/services/reservation_service.dart';
import 'package:cine_passe_app/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widgets
import 'package:cine_passe_app/widgets/custom_button.dart';

class ReservationModal extends StatelessWidget {
  final MovieModel movie;

  const ReservationModal({super.key, required this.movie});

  // Método para exibir o feedback de sucesso (AlertDialog)
  void _showSuccessDialog(BuildContext context) {
    // É importante garantir que o contexto seja válido antes de chamar o pop
    if (Navigator.canPop(context)) Navigator.pop(context);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          'Solicitação de reserva enviada!\n\nSeu voucher está aguardando aprovação na aba "Meus Ingressos".',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ⚠️ INJEÇÃO LOCAL DO CONTROLLER E SERVICE
    // Isso garante que a instância do timer seja criada e destruída apenas com o modal
    return ChangeNotifierProvider(
      create: (ctx) => ReservationController(
        ReservationService(),
        ctx.read<TicketController>(),
      )..initialize(),

      child: Consumer<ReservationController>(
        builder: (ctx, controller, child) {
          final bool hasActivePlan = controller.hasActivePlan;

          // 1. Listener de Timeout: Se o timer zerar, fecha o modal
          if (controller.isTimeout.value && Navigator.canPop(ctx)) {
            // O addPostFrameCallback é usado para garantir que o pop ocorra após o frame ser construído
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(ctx);
            });
          }

          return Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header com Timer
                _buildTimerHeader(theme, controller),
                const SizedBox(height: 24),

                _buildMovieDetails(theme, controller),

                const SizedBox(height: 24),

                // Conteúdo Principal (Horários e Botão)
                // ✅ Usando o getter corrigido: controller.isLoadingProfile
                if (controller.isLoadingProfile)
                  const Center(child: CircularProgressIndicator())
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTimeSelection(theme, controller),

                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),

                      // ✅ CORREÇÃO: Passamos o context E o movie
                      _buildSummaryAndButton(theme, controller, ctx, movie),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGETS AUXILIARES E LÓGICA DE RENDERING ---

  Widget _buildTimerHeader(ThemeData theme, ReservationController controller) {
    // ✅ ValueListenableBuilder<int> remainingSeconds
    return ValueListenableBuilder<int>(
      valueListenable: controller.remainingSeconds,
      builder: (context, remainingSeconds, child) {
        final String formattedTime =
            '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}';
        final bool isCritical = remainingSeconds < 60;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reserva de Ingresso',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isCritical
                    ? Colors.red.withOpacity(0.1)
                    : theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: isCritical ? Colors.red : theme.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Monospace',
                      color: isCritical ? Colors.red : theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovieDetails(ThemeData theme, ReservationController controller) {
    final bool hasActivePlan = controller.hasActivePlan;
    final String userPlan = controller.userPlan;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            movie.imagemUrl,
            width: 80,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(width: 80, height: 120, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.titulo,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text('CinePasse Center', style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              // Badge do Plano
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: hasActivePlan
                      ? Colors.purple.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: hasActivePlan ? Colors.purple : Colors.grey,
                  ),
                ),
                child: Text(
                  hasActivePlan ? 'Benefício $userPlan' : 'Pagamento Avulso',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: hasActivePlan ? Colors.purple : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection(
    ThemeData theme,
    ReservationController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Horário da Sessão',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          children: controller.sessionTimes.map((time) {
            // ✅ Usando o getter corrigido: controller.selectedTime
            final isSelected = controller.selectedTime == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              onSelected: (selected) =>
                  controller.setSelectedTime(selected ? time : null),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.cardColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ✅ CORREÇÃO: Recebe o context e o MovieModel
  Widget _buildSummaryAndButton(
    ThemeData theme,
    ReservationController controller,
    BuildContext context,
    MovieModel movie,
  ) {
    final bool hasActivePlan = controller.hasActivePlan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              hasActivePlan ? 'R\$ 0,00' : 'R\$ 25,00',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: hasActivePlan
                    ? Colors.green
                    : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),

        // Benefício
        if (hasActivePlan)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Benefício aplicado: Ingresso Gratuito',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Botão de Ação
        CustomButton(
          text: hasActivePlan
              ? 'CONFIRMAR RESERVA (R\$ 0,00)'
              : 'IR PARA PAGAMENTO (R\$ 25,00)',
          // ✅ Usa o getter público controller.ticketController.isLoading
          isLoading: controller.ticketController.isLoading,
          onPressed: controller.selectedTime == null
              ? null
              : () async {
                  // ✅ CHAMADA CORRIGIDA: Passando o movie.titulo para o controller
                  final success = await controller.handleReservation(
                    movie.titulo,
                  );
                  if (success) _showSuccessDialog(context);
                },
        ),
      ],
    );
  }
}
