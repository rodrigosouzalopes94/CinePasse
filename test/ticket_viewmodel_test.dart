import 'package:cine_passe_app/features/repositories/ticketrepository/i_ticket_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart';


class MockTicketRepository extends Mock implements ITicketRepository {}

void main() {
  late TicketViewModel viewModel;
  late MockTicketRepository mockRepo;

  setUp(() {
    mockRepo = MockTicketRepository();
    viewModel = TicketViewModel(mockRepo);
  });

  test('Deve emitir mensagem de sucesso ao criar um ticket corretamente', () async {
    // Preparação
    when(() => mockRepo.createTicket(any())).thenAnswer((_) async => {});

    
    final result = await viewModel.reserveTicket(
      userId: 'user123',
      movieTitle: 'Batman',
      sessionDate: DateTime.now(),
      sessionTime: '19:00',
      ticketType: 'Plano Premium',
    );

    // Verificação
    expect(result, true);
    expect(viewModel.successMessage, isNotNull);
    verify(() => mockRepo.createTicket(any())).called(1);
  });
}