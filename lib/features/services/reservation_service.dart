import 'dart:async';
import 'package:flutter/foundation.dart'; 

class ReservationService {
  static const int reservationDuration = 15 * 60; 

  Timer? _timer;
  ValueNotifier<int> remainingSeconds = ValueNotifier(reservationDuration);
  ValueNotifier<bool> isTimeout = ValueNotifier(false);

  void startTimer() {
    
    _timer?.cancel();
    remainingSeconds.value = reservationDuration;
    isTimeout.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        isTimeout.value = true;
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void resetTimer() {
    cancelTimer();
    remainingSeconds.value = reservationDuration;
    isTimeout.value = false;
  }
}
