import 'package:flutter/material.dart';
import '../../core/enums/cell_type.dart';

class PegCell extends StatelessWidget {
  final int row;
  final int col;
  final CellType type;
  final bool isSelected;
  final VoidCallback onTap;

  const PegCell({
    super.key,
    required this.row,
    required this.col,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(194, 28, 13, 54),
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