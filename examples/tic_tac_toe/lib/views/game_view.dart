import 'package:flutter/material.dart';
import 'package:jsm/jsm.dart';

import '../models/game_model.dart';
import '../view_models/game_view_model.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return JPage(
      create: () => GameViewModel(),
      builder: (context, controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tic Tac Toe'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  JObserverWidget<GameModel>(
                    observable: controller.game,
                    onChange: (GameModel _) {
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => controller.handleClick(index),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: Center(
                                child: Text(
                                  controller.game.value.board[index],
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: JObserverWidget<GameModel>(
                      observable: controller.game,
                      onChange: (GameModel gameModel) {
                        return controller.game.value.winner != null
                            ? Text(
                                'Player ${controller.game.value.winner} wins!',
                                style: const TextStyle(fontSize: 32),
                              )
                            : const Text(
                                '...',
                                style: TextStyle(fontSize: 32),
                              );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.resetGame,
                    child: const Text('Reset Game'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
