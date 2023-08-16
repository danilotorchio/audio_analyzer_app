import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NegativePage extends StatelessWidget {
  final String message;
  const NegativePage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return _NegativeView(message);
  }
}

class _NegativeView extends StatelessWidget {
  final String message;
  const _NegativeView(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NEGATIVO',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text(
                'Voltar',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
