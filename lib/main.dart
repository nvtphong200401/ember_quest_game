import 'package:ember_quest_game/ember_quest.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = EmberQuestGame();
  runApp(GameWidget(game: game));
}
