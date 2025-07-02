// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transacao.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransacaoAdapter extends TypeAdapter<Transacao> {
  @override
  final int typeId = 0;

  @override
  Transacao read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transacao(
      titulo: fields[0] as String,
      valor: fields[1] as double,
      data: fields[2] as DateTime,
      isGanho: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Transacao obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.titulo)
      ..writeByte(1)
      ..write(obj.valor)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.isGanho);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransacaoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
