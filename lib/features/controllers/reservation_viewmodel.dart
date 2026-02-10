import 'package:cine_passe_app/features/repositories/authrepositorie/i_auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:cine_passe_app/features/services/reservation_service.dart';
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart';
import 'package:cine_passe_app/models/user_model.dart';

class ReservationViewModel with ChangeNotifier {
  final ReservationService _reservationService;
  final IAuthRepository _authRepository; 
  final TicketViewModel _ticketViewModel;

  ReservationViewModel(
    this._reservationService,
    this._authRepository,
    this._ticketViewModel,
  );

  UserModel? _userProfile;
  bool _isLoadingProfile = true;
  String? _selectedTime;
  final List<String> sessionTimes = ['14:00', '16:30', '19:00', '21:30'];

  
  bool get isLoadingProfile => _isLoadingProfile;
  String? get selectedTime => _selectedTime;
  UserModel? get userProfile => _userProfile;
  TicketViewModel get ticketViewModel => _ticketViewModel;
  
  ValueNotifier<int> get remainingSeconds => _reservationService.remainingSeconds;
  ValueNotifier<bool> get isTimeout => _reservationService.isTimeout;

  bool get hasActivePlan => 
      _userProfile?.planoAtual != 'Nenhum' && _userProfile?.planoAtual != null;

  void initialize(String uid) {
    _reservationService.startTimer();
    _loadUserProfile(uid);
  }

  Future<void> _loadUserProfile(String uid) async {
    _isLoadingProfile = true;
    notifyListeners();
    
 
    _userProfile = await _authRepository.fetchUserProfile(uid);
    
    _isLoadingProfile = false;
    notifyListeners();
  }

  void setSelectedTime(String? time) {
    _selectedTime = time;
    notifyListeners();
  }

  Future<bool> handleReservation(String movieTitle) async {
    if (_selectedTime == null || _userProfile == null) return false;

    _reservationService.cancelTimer();

   
    final String ticketType = hasActivePlan ? 'Plano Assinatura' : 'Reserva Normal';

    return await _ticketViewModel.reserveTicket(
      userId: _userProfile!.uid as String,
      movieTitle: movieTitle,
      sessionDate: DateTime.now(),
      sessionTime: _selectedTime!,
      ticketType: ticketType,
    );
  }

  @override
  void dispose() {
    _reservationService.cancelTimer();
    super.dispose();
  }
}