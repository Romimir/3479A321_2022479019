import 'package:flutter_test/flutter_test.dart';
import 'package:lab1/core/enums/cell_type.dart';
import 'package:lab1/models/board_position.dart';
import 'package:lab1/viewmodels/peg_solitaire_view_model.dart';

import '../fakes/fake_audio_service.dart';
import '../fakes/fake_game_history_repository.dart';
import '../fakes/fake_preferences_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PegSolitaireViewModel viewModel;
  late FakeGameHistoryRepository fakeRepo;
  late FakePreferencesService fakePrefs;
  late FakeAudioService fakeAudio;

  setUp(() {
    fakeRepo = FakeGameHistoryRepository();
    fakePrefs = FakePreferencesService();
    fakeAudio = FakeAudioService();

    viewModel = PegSolitaireViewModel(
      historyRepository: fakeRepo,
      preferencesService: fakePrefs,
      audioService: fakeAudio,
    );
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('PegSolitaireViewModel Pruebas Unitarias del Motor Lógico', () {
    test('TC-01: Ejecuta salto ortogonal válido y remueve atómicamente la clavija intermedia', () {
      const from = BoardPosition(1, 3);
      const jumped = BoardPosition(2, 3);
      const to = BoardPosition(3, 3);

      expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
      expect(viewModel.getCellType(jumped.row, jumped.col), CellType.occupiedPeg);
      expect(viewModel.getCellType(to.row, to.col), CellType.emptyHole);

      viewModel.onCellTapped(from);
      expect(viewModel.selectedPosition, from);
      expect(fakeAudio.playSelectCount, 1);

      viewModel.onCellTapped(to);

      expect(viewModel.getCellType(from.row, from.col), CellType.emptyHole, reason: 'El origen debe quedar vacío');
      expect(viewModel.getCellType(jumped.row, jumped.col), CellType.emptyHole, reason: 'La clavija saltada debe ser removida');
      expect(viewModel.getCellType(to.row, to.col), CellType.occupiedPeg, reason: 'El destino debe alojar la clavija');
      expect(viewModel.selectedPosition, isNull, reason: 'La FSM debe retornar a estado IDLE');
      expect(fakeAudio.playJumpCount, 1, reason: 'Debe emitirse el sonido de salto');
    });

    test('TC-02: Rechaza categóricamente saltos diagonales y preserva invariantes', () {
      const from = BoardPosition(2, 2);
      const invalidDiagonal = BoardPosition(3, 3); // Hueco vacío central

      viewModel.onCellTapped(from);
      viewModel.onCellTapped(invalidDiagonal);

      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);
      expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
      expect(viewModel.selectedPosition, from, reason: 'Mantiene la selección ante destino inválido');
    });

    test('TC-03: Rechaza desplazamientos simples de distancia 1 hacia hueco vacío', () {
      const from = BoardPosition(3, 2);
      const adjacentHole = BoardPosition(3, 3);

      viewModel.onCellTapped(from);
      viewModel.onCellTapped(adjacentHole);

      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);
      expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
    });

    test('TC-04: Mantiene la consistencia de los contadores de piezas y turnos jugados', () {
      const from = BoardPosition(1, 3);
      const to = BoardPosition(3, 3);

      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);

      viewModel.onCellTapped(from);
      viewModel.onCellTapped(to);

      expect(viewModel.remainingPegs, 31, reason: 'Debe decrementar exactamente 1 clavija');
      expect(viewModel.moveCount, 1, reason: 'Debe incrementar exactamente 1 turno');
    });

    test('TC-05: Estado inicial coherente con tablero inglés estándar', () {
      expect(viewModel.isGameOver, isFalse);
      expect(viewModel.isVictory, isFalse);
      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);
      expect(viewModel.selectedPosition, isNull);
    });
  });
}