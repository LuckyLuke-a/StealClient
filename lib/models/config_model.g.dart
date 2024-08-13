// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigModelAdapter extends TypeAdapter<ConfigModel> {
  @override
  final int typeId = 1;

  @override
  ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigModel(
      addr: fields[0] as String?,
      protocol: fields[1] as String?,
      secretKey: fields[2] as String?,
      intervalSecond: fields[3] as int?,
      skewSecond: fields[4] as int?,
      sni: fields[5] as String?,
      readDeadlineSecond: fields[6] as int?,
      writeDeadlineSecond: fields[7] as int?,
      userId: fields[8] as String?,
      minSplitPacket: fields[9] as int?,
      maxSplitPacket: fields[10] as int?,
      subChunk: fields[11] as int?,
      padding: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.addr)
      ..writeByte(1)
      ..write(obj.protocol)
      ..writeByte(2)
      ..write(obj.secretKey)
      ..writeByte(3)
      ..write(obj.intervalSecond)
      ..writeByte(4)
      ..write(obj.skewSecond)
      ..writeByte(5)
      ..write(obj.sni)
      ..writeByte(6)
      ..write(obj.readDeadlineSecond)
      ..writeByte(7)
      ..write(obj.writeDeadlineSecond)
      ..writeByte(8)
      ..write(obj.userId)
      ..writeByte(9)
      ..write(obj.minSplitPacket)
      ..writeByte(10)
      ..write(obj.maxSplitPacket)
      ..writeByte(11)
      ..write(obj.subChunk)
      ..writeByte(12)
      ..write(obj.padding);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
