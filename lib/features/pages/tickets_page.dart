import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/models/ticket_model.dart';

import 'package:cine_passe_app/widgets/ticket_card.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final ticketViewModel = context.watch<TicketViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final userId = authViewModel.userProfile?.uid;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Meus Ingressos'),
        centerTitle: true,
      ),
      body: userId == null
          ? const _ErrorState(message: 'Usuário não identificado.')
          : StreamBuilder<List<TicketModel>>(
             
              stream: ticketViewModel.getTicketsByStatus(userId, TicketStatus.approved),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return _ErrorState(
                    message: 'Erro ao carregar ingressos.',
                    onRetry: () => (context as Element).markNeedsBuild(),
                  );
                }

                final tickets = snapshot.data ?? [];

                if (tickets.isEmpty) {
                  return const _EmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TicketCard(ticket: tickets[index]),
                    );
                  },
                );
              },
            ),
    );
  }
}



class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.ticket,
              size: 80,
              color: theme.disabledColor.withOpacity(0.2),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum ingresso aprovado',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Assim que suas reservas forem aprovadas pelo backoffice, os vouchers com QR Code aparecerão aqui.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(message, style: theme.textTheme.titleMedium),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Tentar Novamente')),
          ]
        ],
      ),
    );
  }
}