import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:pinterest/data/local/board_model.dart';



final boardsBoxProvider = Provider<Box<BoardModel>>((ref) {
  return Hive.box<BoardModel>('boardsBox'); 
});
