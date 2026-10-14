import 'package:flutter/material.dart';
import '../../core/enums/cell_type.dart';
import '../../models/board_position.dart';

class PegCell extends StatelessWidget {
  final BoardPosition position;
  final CellType type;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isValidDestination;
  
  const PegCell({
    super.key,
    required this.position,
    required this.type,
    required this.isSelected,
    required this.onTap,
    this.isValidDestination = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isValidDestination
              ? const Color.fromARGB(194, 4, 63, 115)
              : const Color.fromARGB(194, 28, 13, 54),
          border: Border.all(color: const Color.fromARGB(255, 48, 29, 74), width: 1.5),
        ),
        child: Center(
          child: type == CellType.occupiedPeg
              ? Image.asset(
                  isSelected
                      ? 'assets/icons/Seleccionado.png'
                      : 'assets/icons/Casilla.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                )
              : type == CellType.emptyHole
                  ? Image.asset(
                      'assets/icons/Vacio.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    )
                  : null,
        ),
      ),
    );
  }
}