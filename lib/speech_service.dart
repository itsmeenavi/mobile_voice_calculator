import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
    late final stt.SpeechToText _speech; // Use 'late' here
  bool _isInitialized = false;

  SpeechService() {
    _speech = stt.SpeechToText();
  }


  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );
    }
    return _isInitialized;
  }

  void startListening(
      Function(String) onResult,
      Function(String) onError,
      Function(String) onStatus,
      ) {
    _speech.listen(
      onResult: (val) => onResult(val.recognizedWords),
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 5),
      partialResults: false,
      localeId: 'en_US',
      onSoundLevelChange: null,
      cancelOnError: true,
      listenMode: stt.ListenMode.confirmation,
    );
  }

  void stopListening() {
    _speech.stop();
  }

void _onError(dynamic error) {
  // Handle errors here
  print('Error: $error');
}



  void _onStatus(String status) {
    // Handle status changes here
  }

  void dispose() {
    _speech.cancel();
  }
}
