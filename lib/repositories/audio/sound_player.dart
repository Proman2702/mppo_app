import 'dart:developer';
import 'dart:ui';

import 'package:mppo_app/repositories/audio/storage.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

// Класс работы с плеером

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  String? _audioPath;

  bool get isPlaying => _audioPlayer!.isPlaying;

  // Инициализация плеера
  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    try {
      _audioPath = await Storage().completePath();
    } catch (e) {
      log('Ошибка $e');
    }

    await _audioPlayer!.openAudioSession();
  }

  // Отключение плеера при выходе
  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  // Локальный метод запуска аудиофайла
  Future _play(VoidCallback whenFinished) async {
    try {
      await _audioPlayer!.startPlayer(fromURI: _audioPath!, whenFinished: whenFinished);
    } on Exception catch (e) {
      log("Ошибка $e");
    }
  }

  // Локальный метод остановки аудиофайла
  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  // Запустить/остановить аудиофайл
  Future togglePlaying({required VoidCallback whenFinished}) async {
    if (_audioPlayer!.isStopped) {
      await _play(whenFinished);
    } else {
      await _stop();
    }
  }
}
