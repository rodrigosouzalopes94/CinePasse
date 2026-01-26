import 'package:cine_passe_app/features/api/user_firestore_service.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/services/reservation_service.dart';
import 'package:cine_passe_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationController with ChangeNotifier {
  
  final ReservationService _reservationService;
  final UserFirestoreService _userService = UserFirestoreService();
  final TicketController _ticketController;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ReservationController(this._reservationService, this._ticketController);

  
  UserModel? _userProfile;
  bool _isLoadingProfile = true; 
  String? _selectedTime;
  final List<String> sessionTimes = ['14:00', '16:30', '19:00', '21:30'];

  

  
  TicketController get ticketController => _ticketController;

  
  bool get isLoadingProfile => _isLoadingProfile;

  
  ValueNotifier<int> get remainingSeconds =>
      _reservationService.remainingSeconds;
  ValueNotifier<bool> get isTimeout => _reservationService.isTimeout;

  
  String? get selectedTime => _selectedTime;

  
  UserModel? get userProfile => _userProfile;
  bool get hasActivePlan =>
      _userProfile?.planoAtual != 'Nenhum' && _userProfile?.planoAtual != null;
  String get userPlan => _userProfile?.planoAtual ?? 'Gratuito';

  

  void initialize() {
    _reservationService.startTimer();
    _loadUserProfile();
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
      debugPrint("Timer expirado, modal deve fechar.");
    }
  }

  void setSelectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

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

  
  Future<bool> handleReservation(String movieTitle) async {
    if (_selectedTime == null) return false;

    _reservationService.cancelTimer();

    final String ticketType = hasActivePlan
        ? 'Plano Assinatura'
        : 'Reserva Normal';

    final success = await _ticketController.reserveTicket(
      movieTitle: movieTitle,
      sessionDate: DateTime.now(),
      sessionTime: _selectedTime!,
      ticketType: ticketType,
    );

    if (!success) {
      _reservationService.startTimer();
    }
    return success;
  }
}
