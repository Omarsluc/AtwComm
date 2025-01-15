import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  static final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  static String recognizedWords = '';
  static bool isFinalResult = false;
  static ValueNotifier<String> recognizedWordsNotifier = ValueNotifier('');

  static void initSpeech() async {
    bool _speechEnabled = await _speechToText.initialize();
  }

  static Future<void> startListening() async {
    log('J;;');
    await _speechToText.listen(
      pauseFor: const Duration(seconds: 3),
      listenFor: const Duration(minutes: 2),
      onResult: _onSpeechResult,
    );
  }

  static void _onSpeechResult(SpeechRecognitionResult result) {
    log(isFinalResult.toString());
    recognizedWordsNotifier.value = result.recognizedWords;
    log('isFinalResult');
    isFinalResult = false;
    recognizedWords = result.recognizedWords;

    isFinalResultWords(result: result);

    // if (isFinalResult) {
    //   TextToSpeechService.speak(text: "Speak");
    // }
  }

  static void isFinalResultWords({required SpeechRecognitionResult result}) {
    if (result.finalResult) {
      print(result.finalResult);
      print(recognizedWords);

      print('object');
      recognizedWordsNotifier.value = result.recognizedWords;

      isFinalResult = true;
    } else {
      isFinalResult = false;
    }
  }

  static Future<void> stopListening() async {
    await _speechToText.stop();
  }
}