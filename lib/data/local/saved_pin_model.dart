import 'package:hive/hive.dart';

part 'saved_pin_model.g.dart';

@HiveType(typeId: 2)
class SavedPinModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int width;

  @HiveField(2)
  int height;

  @HiveField(3)
  String url;

  @HiveField(4)
  String photographer;

  @HiveField(5)
  String photographerUrl;

  @HiveField(6)
  int photographerId;

  @HiveField(7)
  String avgColor;

  @HiveField(8)
  String original;

  @HiveField(9)
  String large;

  @HiveField(10)
  String medium;

  @HiveField(11)
  String small;

  @HiveField(12)
  String portrait;

  @HiveField(13)
  String landscape;

  @HiveField(14)
  String tiny;

  @HiveField(15)
  String alt;

  @HiveField(16)
  bool liked;

  @HiveField(17)
  DateTime savedAt;

  SavedPinModel({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.original,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
    required this.alt,
    required this.liked,
    required this.savedAt,
  });
}
