
part of 'saved_pin_model.dart';


class SavedPinModelAdapter extends TypeAdapter<SavedPinModel> {
  @override
  final int typeId = 2;

  @override
  SavedPinModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedPinModel(
      id: fields[0] as int,
      width: fields[1] as int,
      height: fields[2] as int,
      url: fields[3] as String,
      photographer: fields[4] as String,
      photographerUrl: fields[5] as String,
      photographerId: fields[6] as int,
      avgColor: fields[7] as String,
      original: fields[8] as String,
      large: fields[9] as String,
      medium: fields[10] as String,
      small: fields[11] as String,
      portrait: fields[12] as String,
      landscape: fields[13] as String,
      tiny: fields[14] as String,
      alt: fields[15] as String,
      liked: fields[16] as bool,
      savedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedPinModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.photographer)
      ..writeByte(5)
      ..write(obj.photographerUrl)
      ..writeByte(6)
      ..write(obj.photographerId)
      ..writeByte(7)
      ..write(obj.avgColor)
      ..writeByte(8)
      ..write(obj.original)
      ..writeByte(9)
      ..write(obj.large)
      ..writeByte(10)
      ..write(obj.medium)
      ..writeByte(11)
      ..write(obj.small)
      ..writeByte(12)
      ..write(obj.portrait)
      ..writeByte(13)
      ..write(obj.landscape)
      ..writeByte(14)
      ..write(obj.tiny)
      ..writeByte(15)
      ..write(obj.alt)
      ..writeByte(16)
      ..write(obj.liked)
      ..writeByte(17)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedPinModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
