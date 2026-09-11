import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal - Solitario'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Jugar'),
                onPressed: () => Navigator.pushNamed(context, '/game'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Historial de Partidas'),
                onPressed: () => Navigator.pushNamed(context, '/history'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text('Acerca de'),
                onPressed: () => Navigator.pushNamed(context, '/about'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}