import 'package:hive_flutter/hive_flutter.dart';

part 'config_model.g.dart';

@HiveType(typeId: 1)
class ConfigModel {
  @HiveField(0)
  String? addr;

  @HiveField(1)
  String? protocol;

  @HiveField(2)
  String? secretKey;

  @HiveField(3)
  int? intervalSecond;

  @HiveField(4)
  int? skewSecond;

  @HiveField(5)
  String? sni;

  @HiveField(6)
  int? readDeadlineSecond;

  @HiveField(7)
  int? writeDeadlineSecond;

  @HiveField(8)
  String? userId;

  @HiveField(9)
  int? minSplitPacket;

  @HiveField(10)
  int? maxSplitPacket;

  @HiveField(11)
  int? subChunk;

  @HiveField(12)
  int? padding;

  ConfigModel({
    this.addr = "",
    this.protocol = "",
    this.secretKey = "",
    this.intervalSecond = 0,
    this.skewSecond = 0,
    this.sni = "",
    this.readDeadlineSecond = 0,
    this.writeDeadlineSecond = 0,
    this.userId = "",
    this.minSplitPacket = 0,
    this.maxSplitPacket = 0,
    this.subChunk = 0,
    this.padding = 0,
  });
}
