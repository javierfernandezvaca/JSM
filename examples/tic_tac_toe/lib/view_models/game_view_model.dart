import 'package:jsm/jsm.dart';

import '../models/game_model.dart';

class GameViewModel extends JController {
  final game = GameModel(
    board: List.filled(9, ''),
    currentPlayer: 'X',
  ).observable;

  void handleClick(int index) {
    if ((game.value.winner == null) && (game.value.board[index] == '')) {
      game.value.board[index] = game.value.currentPlayer;
      checkWinner();
      game.value.currentPlayer = game.value.currentPlayer == 'X' ? 'O' : 'X';
      game.refresh();
    }
  }

  void checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var combination in winningCombinations) {
      if (game.value.board[combination[0]] ==
              game.value.board[combination[1]] &&
          game.value.board[combination[1]] ==
              game.value.board[combination[2]] &&
          game.value.board[combination[0]] != '') {
        game.value.winner = game.value.board[combination[0]];
        game.refresh();
        return;
      }
    }
  }

  void resetGame() {
    game.value.board = List.filled(9, '');
    game.value.currentPlayer = 'X';
    game.value.winner = null;
    game.refresh();
  }
}
