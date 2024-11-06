import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
   late FlutterTts _flutterTts; // Marked as 'late'

  TextToSpeechService() {
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  void dispose() {
    _flutterTts.stop();
  }
}
