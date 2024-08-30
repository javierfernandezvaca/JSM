class GameModel {
  List<String> board;
  String currentPlayer;
  String? winner;

  GameModel({
    required this.board,
    required this.currentPlayer,
    this.winner,
  });
}
