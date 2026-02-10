import 'package:cine_passe_app/features/repositories/authrepositorie/i_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart';
import 'package:cine_passe_app/models/user_model.dart';

// Criamos o Mock do Repositório
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late AuthViewModel viewModel;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();

    
    when(() => mockRepository.onAuthStateChanged)
        .thenAnswer((_) => const Stream<UserModel?>.empty());

    viewModel = AuthViewModel(mockRepository);
  });

  group('AuthViewModel - Login Tests', () {
    final tUser = UserModel(
      uid: '123',
      nome: 'Rodrigo Lopes',
      email: 'rodrigo@email.com',
      cpf: '12345678900',
      idade: 30,
    );

    test('Deve atualizar o perfil do usuário quando o login for bem-sucedido', () async {
     
      when(() => mockRepository.login('rodrigo@email.com', '123456'))
          .thenAnswer((_) async => tUser);

      
      final loginFuture = viewModel.login('rodrigo@email.com', '123456');

      
      expect(viewModel.isLoading, true);

      await loginFuture;

     
      expect(viewModel.userProfile, tUser);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
      verify(() => mockRepository.login('rodrigo@email.com', '123456')).called(1);
    });

    test('Deve retornar mensagem de erro quando o login falhar por exceção genérica', () async {
     
      when(() => mockRepository.login(any(), any()))
          .thenThrow(Exception('Falha no sistema'));

      
      await viewModel.login('email@teste.com', '123456');

      
      expect(viewModel.userProfile, isNull);
      expect(viewModel.isLoading, false);
      
      
      expect(viewModel.errorMessage, contains('erro')); 
      
    });
  });

  group('AuthViewModel - Logout Tests', () {
    test('Deve limpar o perfil do usuário ao fazer logout', () async {
      
      when(() => mockRepository.logout()).thenAnswer((_) async => {});

      
      await viewModel.logout();

      
      expect(viewModel.userProfile, isNull);
      verify(() => mockRepository.logout()).called(1);
    });
  });
}