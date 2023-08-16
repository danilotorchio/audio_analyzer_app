import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NeutralPage extends StatelessWidget {
  final String message;
  const NeutralPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return _NeutralView(message);
  }
}

class _NeutralView extends StatelessWidget {
  final String message;
  const _NeutralView(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Neutro',
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
