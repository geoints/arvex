import 'dart:async';

/// Таймер сна с мягким затуханием и остановкой воспроизведения.
class SleepTimerService {
  SleepTimerService();

  Timer? _timer;
  Duration _remaining = Duration.zero;

  bool get isActive => _timer != null && _timer!.isActive;
  Duration get remaining => _remaining;

  void schedule(Duration duration, void Function() onComplete) {
    cancel();
    _remaining = duration;
    _timer = Timer(duration, () {
      _remaining = Duration.zero;
      onComplete();
    });
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
    _remaining = Duration.zero;
  }

  void tick(Duration elapsed) {
    if (!isActive) {
      return;
    }
    _remaining = _remaining > elapsed ? _remaining - elapsed : Duration.zero;
  }
}
