/// Локальный эквалайзер для UI-пресетов и логики тонкой настройки.
class EqualizerService {
  EqualizerService();

  final Map<int, double> _bands = {60: 0, 250: 0, 1000: 0, 4000: 0, 16000: 0};

  Map<int, double> get bands => Map.unmodifiable(_bands);

  void setBand(int frequency, double value) {
    if (!_bands.containsKey(frequency)) {
      return;
    }
    _bands[frequency] = value.clamp(-10, 10);
  }

  void setBands(Map<int, double> values) {
    for (final entry in values.entries) {
      setBand(entry.key, entry.value);
    }
  }

  void applyPreset(String preset) {
    switch (preset.toLowerCase()) {
      case 'flat':
        setBands({60: 0, 250: 0, 1000: 0, 4000: 0, 16000: 0});
        return;
      case 'bass_boost':
        setBands({60: 6, 250: 4, 1000: 1, 4000: 0, 16000: -1});
        return;
      case 'vocal':
        setBands({60: -1, 250: 2, 1000: 4, 4000: 3, 16000: 1});
        return;
      case 'night':
        setBands({60: 2, 250: 3, 1000: 1, 4000: -1, 16000: -2});
        return;
      default:
        setBands({60: 0, 250: 0, 1000: 0, 4000: 0, 16000: 0});
    }
  }
}
