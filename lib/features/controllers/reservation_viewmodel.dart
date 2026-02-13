import 'package:flutter/material.dart';
import 'package:cine_passe_app/features/repositories/authrepository/i_auth_repository.dart';
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
  String? _errorMessage; 
  
  final List<String> sessionTimes = ['14:00', '16:30', '19:00', '21:30'];

  
  bool get isLoadingProfile => _isLoadingProfile;
  String? get selectedTime => _selectedTime;
  String? get errorMessage => _errorMessage;
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
    _errorMessage = null; 
    notifyListeners();
  }

  Future<bool> _isWithinPlanLimit(String movieTitle) async {
    
    final String? userId = _userProfile?.uid;
    final String? time = _selectedTime;

    if (userId == null || time == null) return false;

    if (!hasActivePlan) return true;

    
    int limit = 1;
    if (_userProfile?.planoAtual == 'Família') {
      limit = 4;
    }

    
    final int currentTicketsCount = await _ticketViewModel.repository.getActiveTicketsCount(
      userId: userId, 
      movieTitle: movieTitle,
      sessionTime: time,
    );

    
    if (currentTicketsCount >= limit) {
      _errorMessage = "Limite do plano atingido ($limit ingresso(s) por sessão).";
      notifyListeners();
      return false;
    }

    return true;
  }

  
  Future<bool> handleReservationFlow(BuildContext context, String movieTitle) async {
    if (_selectedTime == null || _userProfile == null) return false;

    
    final bool canProceed = await _isWithinPlanLimit(movieTitle);
    if (!canProceed) return false;

   
    if (hasActivePlan) {
      
      return await _executeReservation(movieTitle, 'Plano Assinatura');
    } else {
      
      final result = await Navigator.pushNamed(
        context,
        '/checkout',
        arguments: {
          'amount': 25.0,
          'movieTitle': movieTitle,
          'sessionTime': _selectedTime,
        },
      );

      
      if (result == true) {
        return await _executeReservation(movieTitle, 'Reserva Normal');
      }
      return false;
    }
  }

  
  Future<bool> _executeReservation(String movieTitle, String type) async {
    final String userId = _userProfile?.uid ?? '';
    if (userId.isEmpty || _selectedTime == null) return false;

    return await _ticketViewModel.reserveTicket(
      userId: userId,
      movieTitle: movieTitle,
      sessionDate: DateTime.now(),
      sessionTime: _selectedTime!,
      ticketType: type, 
    );
  }

  @override
  void dispose() {
    _reservationService.cancelTimer();
    super.dispose();
  }
}