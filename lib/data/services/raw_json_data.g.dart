// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_json_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RawJsonDataAdapter extends TypeAdapter<RawJsonData> {
  @override
  final int typeId = 2;

  @override
  RawJsonData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RawJsonData(
      rawData: fields[0] as String,
      languageCode: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RawJsonData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rawData)
      ..writeByte(1)
      ..write(obj.languageCode)
      ..writeByte(2)
      ..write(obj.updatedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawJsonDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
