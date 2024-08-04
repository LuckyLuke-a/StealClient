
import 'package:hive_flutter/hive_flutter.dart';

part 'config_model.g.dart';

@HiveType(typeId: 1)
class ConfigModel {
  @HiveField(0)
  String addr;

  @HiveField(1)
  String protocol;

  @HiveField(2)
  String secretKey;

  @HiveField(3)
  int intervalSecond;

  @HiveField(4)
  int skewSecond;

  @HiveField(5)
  String sni;

  @HiveField(6)
  int readDeadlineSecond;

  @HiveField(7)
  int writeDeadlineSecond;

  @HiveField(8)
  String? userId;


  ConfigModel({
    required this.addr,
    required this.protocol,
    required this.secretKey,
    required this.intervalSecond,
    required this.skewSecond,
    required this.sni,
    required this.readDeadlineSecond,
    required this.writeDeadlineSecond,
    required this.userId
  });
}
