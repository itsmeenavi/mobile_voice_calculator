import 'package:flutter/material.dart';
import 'speech_service.dart';
import 'text_to_speech_service.dart';
import 'calculator_service.dart';

void main() {
  runApp(VoiceCalculatorApp());
}

class VoiceCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice-Controlled Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceCalculatorHomePage(),
    );
  }
}

class VoiceCalculatorHomePage extends StatefulWidget {
  @override
  _VoiceCalculatorHomePageState createState() => _VoiceCalculatorHomePageState();
}

class _VoiceCalculatorHomePageState extends State<VoiceCalculatorHomePage> {
  final SpeechService _speechService = SpeechService();
  final TextToSpeechService _ttsService = TextToSpeechService();
  final CalculatorService _calculatorService = CalculatorService();

  String _command = '';
  String _result = '';
  String _status = 'Ready.';
  bool _isListening = false;

  void _startListening() async {
    setState(() {
      _status = 'Listening...';
      _isListening = true;
      _command = '';
      _result = '';
    });
    bool available = await _speechService.initialize();
    if (available) {
      _speechService.startListening(_onSpeechResult, _onSpeechError, _onSpeechStatus);
    } else {
      setState(() {
        _status = 'Speech recognition not available';
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    _speechService.stopListening();
    setState(() {
      _status = 'Processing...';
      _isListening = false;
    });
  }

  void _onSpeechResult(String recognizedWords) {
    setState(() {
      _command = recognizedWords;
    });
    _processCommand(recognizedWords);
  }

  void _onSpeechError(String error) {
    setState(() {
      _status = 'Error: $error';
      _isListening = false;
    });
    _ttsService.speak("Sorry, I didn't catch that. Please try again.");
  }

  void _onSpeechStatus(String status) {
    // You can handle different statuses here if needed
  }

  void _processCommand(String command) async {
    String result = _calculatorService.parseCommand(command);
    setState(() {
      _result = result;
      _status = 'Ready.';
    });
    await _ttsService.speak(result);
  }

  void _onListenButtonPressed() {
    if (!_isListening) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  void _onExitButtonPressed() {
    _ttsService.speak("Goodbye!");
    _speechService.dispose();
    _ttsService.dispose();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _speechService.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
  title: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('IAS 2 Project'),
      Text(
        'BSIT-42E3',
        style: TextStyle(fontSize: 14, color: Colors.white70),
      ),
    ],
  ),
),

body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(height: 16),
      Text(
        'Voice-Controlled Calculator',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Text(
        'Command:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _command.isEmpty ? 'Your spoken command will appear here.' : _command,
          style: TextStyle(fontSize: 16),
        ),
      ),
      SizedBox(height: 16),
      Text(
        'Result:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _result.isEmpty ? 'Calculation result will appear here.' : _result,
          style: TextStyle(fontSize: 16),
        ),
      ),
      SizedBox(height: 24),
      Text(
        _status,
        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 24),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: _onListenButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isListening ? Colors.red : Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: Icon(_isListening ? Icons.stop : Icons.mic),
            label: Text(
              _isListening ? 'Stop' : 'Listen',
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _onExitButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: Icon(Icons.exit_to_app),
            label: Text(
              'Exit',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ],
          ),
        )
        );
  }
}
