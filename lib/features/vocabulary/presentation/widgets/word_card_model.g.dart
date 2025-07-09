// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyCardAdapter extends TypeAdapter<MyCard> {
  @override
  final int typeId = 0;

  @override
  MyCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyCard(
      korean: fields[0] as String,
      translation: fields[1] as String,
      createdAt: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MyCard obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.korean)
      ..writeByte(1)
      ..write(obj.translation)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
