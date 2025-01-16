import 'dart:developer';

import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mppo_app/repositories/audio/storage.dart';

class SoundRecorder {
  FlutterSoundRecorder? audioRecorder;

  String? _audioPath;

  // Проверка, включен ли диктофон
  bool get isRecording => audioRecorder!.isRecording;

  // Инициализация диктофона
  Future init() async {
    audioRecorder = FlutterSoundRecorder();

    final statusMic = await Permission.microphone.status;
    if (!statusMic.isGranted) {
      await Permission.microphone.request();
    }
    final statusStorage = await Permission.audio.status;
    if (!statusStorage.isGranted) {
      await Permission.audio.request();
    }

    final statusStorage1 = await Permission.storage.status;
    if (!statusStorage1.isGranted) {
      await Permission.storage.request();
    }

    try {
      _audioPath = await Storage().completePath();
    } catch (e) {
      log('<SoundRecorder> Ошибка $e');
    }

    log("<SoundRecorder> Путь к аудио: $_audioPath");

    await audioRecorder!.openAudioSession();
  }

  // Выключение диктофона при выходе
  void dispose() {
    audioRecorder!.closeAudioSession();
    audioRecorder = null;
  }

  // Локальный метод запуска диктофона
  Future<void> _record() async {
    await audioRecorder!.startRecorder(toFile: _audioPath);
  }

  // Локальный метод остановки диктофона
  Future<void> _stop() async {
    await audioRecorder!.stopRecorder();
  }

  // Включение/отключение диктофона
  Future<void> toggleRecording() async {
    if (audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
