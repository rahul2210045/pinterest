import 'package:hive/hive.dart';
import 'saved_pin_model.dart';

part 'board_model.g.dart';

@HiveType(typeId: 1)
class BoardModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<SavedPinModel> pins;

  @HiveField(3)
  DateTime createdAt;

  BoardModel({
    required this.id,
    required this.name,
    required this.pins,
    required this.createdAt,
  });
}
