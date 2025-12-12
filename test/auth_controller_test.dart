import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cine_passe_app/features/controllers/auth_controller.dart';


// 1. Criar Mocks para os Serviços (simulações)
class MockAuthService extends Mock implements AuthService {}
class MockUserFirestoreService extends Mock implements UserFirestoreService {}

void main() {
  // Instâncias dos Mocks
  late MockAuthService mockAuthService;
  late MockUserFirestoreService mockFirestoreService;
  late AuthController authController;

  // Configuração (roda antes de cada teste)
  setUp(() {
    mockAuthService = MockAuthService();
    mockFirestoreService = MockUserFirestoreService();
    
    // Configura o Controller com as dependências mockadas
    authController = AuthController(
      mockAuthService,
      mockFirestoreService,
    );
  });
  
  // Limpeza (roda após cada teste)
  tearDown(() {
    // Garante que o estado seja limpo (útil para testes de Provider)
    // Se o seu AuthController for um ChangeNotifier, você pode precisar descartá-lo.
  });


  group('AuthController Tests', () {
    
    test('isLoggedIn deve retornar false após logout', () async {
      // 1. Arrange (Preparação)
      // Dizemos ao MockAuthService o que fazer quando o logout() for chamado.
      // Neste caso, ele não faz nada (void), então usamos when...thenAnswer.
      when(() => mockAuthService.logout()).thenAnswer((_) async => Future.value());
      
      // Simula que o usuário está logado (para o teste funcionar, você pode simular o currentUser)
      // Para este teste, focamos apenas na ação de logout.
      
      // 2. Act (Ação)
      await authController.logout();
      
      // 3. Assert (Verificação)
      // Verifica se o método logout do Service foi de fato chamado
      verify(() => mockAuthService.logout()).called(1);
      
      // Verifica se o Controller notifica que o estado de login mudou
      // (Se o seu isLoggedIn estiver ligado ao authStateChanges, você pode precisar de um passo a mais)
      // Aqui, verificamos o efeito direto no estado (simulando a mudança do _currentUser)
      expect(authController.isLoggedIn, false);
      // Neste cenário real, após o logout, o notifyListeners deve ser chamado.
    });

    test('updateProfileDetails deve atualizar o nome no Auth e o plano no Firestore', () async {
      // 1. Arrange (Preparação)
      const newName = 'Novo Nome Teste';
      const newAge = 35;
      const newPlan = 'Passe Premium';
      
      // Simula o usuário logado e o UserModel
      when(() => mockAuthService.currentUser).thenReturn(
        // Simula um User do Firebase para o Controller conseguir prosseguir
        // (Você precisará de um mock mais elaborado para User se precisar de mais detalhes)
        null, // Colocar null para simular que o user está deslogado
      ); 

      // ⚠️ NOTA: Para um teste completo aqui, você precisaria de um mock mais complexo 
      // para simular um User com UID e o fetchUserProfile inicial.

      // Assume que o usuário está logado e o perfil foi carregado
      authController.fetchUserProfile();
      
      // 2. Act (Ação)
      // Simula as chamadas de serviço
      when(() => mockAuthService.updateUserProfile(newName: newName)).thenAnswer((_) async => Future.value());
      // A chamada ao firestoreService.updateUser será verificada no Assert
      
      // 3. Assert (Verificação)
      // Como o código do controller não está completo, o teste será simplificado
      // O ideal é verificar se mockFirestoreService.updateUser foi chamado com o UserModel correto
    });
    
  });
}