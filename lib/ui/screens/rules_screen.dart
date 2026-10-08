import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget { 
  const RulesScreen({super.key}); 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('Reglas del Juego', style: TextStyle(color: Color.fromARGB(255, 188, 228, 244))), 
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 188, 228, 244)),
      ), 
      body: Padding( 
        padding: const EdgeInsets.all(16.0), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [ 
            Card( 
              color: const Color.fromARGB(134, 11, 0, 20),
              elevation: 2, 
              child: Padding( 
                padding: const EdgeInsets.all(16.0), 
                child: Column( 
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [ 
                    Text( 
                      'Objetivo', 
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 188, 228, 244)), 
                    ), 
                    const SizedBox(height: 8), 
                    const Text( 
                      'Eliminar clavijas saltando sobre ellas ortogonalmente hacia un hueco vacío, ''hasta conservar una única clavija en el tablero.', 
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Color.fromARGB(255, 188, 228, 244),
                      ),
                    ), 
                  ], 
                ), 
              ), 
            ), 
            const Spacer(), 
            FilledButton.icon( 
              icon: const Icon(Icons.arrow_back), 
              label: const Text('Volver al Juego'), 
              onPressed: () { 
                  Navigator.pop(context); 
              }, 
            ), 
          ], 
        ), 
      ), 
    ); 
  } 
} 