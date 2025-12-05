import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/models/ticket_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cine_passe_app/widgets/ticket_card.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Acessa o controller via Provider (certifique-se de adicioná-lo no main.dart)
    final ticketController = Provider.of<TicketController>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);

    // O Scaffold é opcional aqui se a MainAppWrapper já tiver estrutura,
    // mas ajuda a manter o padding e cor de fundo consistentes.
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<List<TicketModel>>(
        // 2. Escuta o fluxo de dados do Firestore em tempo real
        stream: ticketController.allUserTicketsStream,
        builder: (context, snapshot) {
          // --- ESTADO: CARREGANDO ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- ESTADO: ERRO ---
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.triangleExclamation,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar ingressos',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Não foi possível conectar ao servidor.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Força a reconstrução do widget para tentar reconectar
                        (context as Element).markNeedsBuild();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final tickets = snapshot.data ?? [];

          // --- ESTADO: LISTA VAZIA (Empty State fiel ao conceito) ---
          if (tickets.isEmpty) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.ticket,
                      size: 80,
                      color: theme.disabledColor.withValues(alpha: 0.2),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nenhum ingresso encontrado',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Você ainda não reservou nenhum filme. Seus vouchers aparecerão aqui com o status de aprovação.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Nota: O botão de "Explorar" geralmente ficaria aqui,
                    // mas a navegação para a Home é feita pela BottomBar.
                  ],
                ),
              ),
            );
          }

          // --- ESTADO: LISTA DE DADOS ---
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TicketCard(ticket: ticket),
              );
            },
          );
        },
      ),
    );
  }
}
