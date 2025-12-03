import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/services/reservation_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationController with ChangeNotifier {
  // Dependências
  final ReservationService _reservationService;
  final UserFirestoreService _userService = UserFirestoreService();
  final TicketController _ticketController; // Injetado
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ReservationController(this._reservationService, this._ticketController);

  // --- ESTADO ---
  UserModel? _userProfile;
  bool _isLoadingProfile = true;
  String? _selectedTime;
  final List<String> sessionTimes = ['14:00', '16:30', '19:00', '21:30'];

  // --- GETTERS ---
  UserModel? get userProfile => _userProfile;
  bool get isLoadingProfile => _isLoadingProfile;
  String? get selectedTime => _selectedTime;

  // Pass-through do Timer
  ValueNotifier<int> get remainingSeconds =>
      _reservationService.remainingSeconds;
  ValueNotifier<bool> get isTimeout => _reservationService.isTimeout;

  // Lógica de Negócio
  bool get hasActivePlan =>
      _userProfile?.planoAtual != 'Nenhum' && _userProfile?.planoAtual != null;
  String get userPlan => _userProfile?.planoAtual ?? 'Gratuito';

  // --- MÉTODOS DE CONTROLE ---

  void initialize() {
    _reservationService.startTimer();
    _loadUserProfile();
    // Monitora o timeout e avisa
    _reservationService.isTimeout.addListener(_onTimeoutListener);
  }

  @override
  void dispose() {
    _reservationService.cancelTimer();
    _reservationService.isTimeout.removeListener(_onTimeoutListener);
    super.dispose();
  }

  void _onTimeoutListener() {
    if (_reservationService.isTimeout.value) {
      // Aqui o controller poderia disparar uma navegação global ou um evento
      debugPrint("Timer expirado, modal deve fechar.");
    }
  }

  void setSelectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Carrega o perfil do usuário para verificar o plano (Regra de Negócio)
  Future<void> _loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      try {
        final profile = await _userService.getUser(uid);
        _userProfile = profile;
      } catch (e) {
        debugPrint("Erro ao carregar perfil: $e");
      }
    }
    _isLoadingProfile = false;
    notifyListeners();
  }

  // Lógica de Reserva (Chama o TicketController)
  Future<bool> handleReservation(String movieTitle) async {
    if (_selectedTime == null) return false;

    // 1. Determina o tipo de ticket
    final String ticketType = hasActivePlan
        ? 'Plano Assinatura'
        : 'Reserva Normal';

    // 2. Cancela o timer antes da chamada de rede
    _reservationService.cancelTimer();

    // 3. Chama a lógica de salvamento
    final success = await _ticketController.reserveTicket(
      movieTitle: movieTitle,
      sessionDate: DateTime.now(),
      sessionTime: _selectedTime!,
      ticketType: ticketType,
    );

    if (!success) {
      // Se falhar, reinicia o timer para dar mais uma chance
      _reservationService.startTimer();
    }
    return success;
  }
}
