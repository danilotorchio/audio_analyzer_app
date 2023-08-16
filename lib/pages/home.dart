import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_error.dart';

import 'package:audio_sentiment_app/services/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  bool processing = false;
  bool speechAvailable = false;

  final timer = StopWatchTimer(mode: StopWatchMode.countUp);
  final speech = stt.SpeechToText();

  @override
  void dispose() async {
    super.dispose();
    await timer.dispose();
  }

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  void _initSpeech() async {
    final result = await speech.initialize(
      onStatus: _onStatusListener,
      onError: _onErrorListener,
    );

    setState(() => speechAvailable = result);
  }

  void _onStatusListener(String msg) {
    log('Status: $msg');
  }

  void _onErrorListener(SpeechRecognitionError error) {
    log('Error: $error');
  }

  String _getTitle() {
    if (processing) {
      return 'Processando. Por favor, aguarde!';
    }

    if (timer.isRunning) {
      return 'Gravando...';
    }

    return 'Pressione o botão para iniciar a gravação';
  }

  void _onButtonPressed(BuildContext context) async {
    if (!speechAvailable) return;

    if (!timer.isRunning) {
      setState(() => timer.onStartTimer());
      speech.listen(localeId: 'pt_BR');
    } else {
      setState(() {
        timer.onStopTimer();
        processing = true;
      });

      await speech.stop();
      log('Words: ${speech.lastRecognizedWords}');

      await _sendRequest(speech.lastRecognizedWords);
    }
  }

  Future<void> _sendRequest(String data) async {
    final go = context.pushNamed;

    final service = ApiService(
      baseUrl: 'https://3439-200-137-221-225.ngrok-free.app',
    );

    final res = await service.sendText(data);
    log('Response: $res');

    setState(() {
      processing = false;
      timer.onResetTimer();
    });

    switch (res["sentiment"]) {
      case 'Positivo':
        go('positive', queryParameters: {'m': res["message"]});
        break;
      case 'Negativo':
        go('negative', queryParameters: {'m': res["message"]});
        break;
      case 'Neutro':
        go('neutral', queryParameters: {'m': res["message"]});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              SizedBox(
                height: 72.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        _getTitle(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: FilledButton(
                    onPressed:
                        processing ? null : () => _onButtonPressed(context),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(64.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(128.0),
                      ),
                      elevation: 12.0,
                    ),
                    child: const Icon(
                      Icons.mic,
                      size: 64.0,
                      // color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 36.0,
                child: processing
                    ? const SizedBox(
                        height: 32.0,
                        width: 32.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : StreamBuilder(
                        stream: timer.rawTime,
                        builder: (context, snap) {
                          final display = StopWatchTimer.getDisplayTime(
                            snap.data ?? 0,
                            hours: false,
                            milliSecond: false,
                          );

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: timer.isRunning,
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                display,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
