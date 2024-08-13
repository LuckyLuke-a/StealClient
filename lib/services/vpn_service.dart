import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:steal_client/models/config_model.dart';
import 'package:steal_client/services/models.dart';

class ManageVPNService {
  // Private constructor to prevent instantiation
  ManageVPNService._();

  static const platform = MethodChannel('StealVPN');
  static Process? proccess;
  static BaseConfig? baseConfig;
  static String corePath = "";

  static Future<String> _readConfig() async {
    return await rootBundle.loadString('assets/config.json');
  }

  static Future<String> start(ConfigModel config) async {
    if (baseConfig == null) {
      String readfile = await _readConfig();
      Map<String, dynamic> json = jsonDecode(readfile);

      baseConfig = BaseConfig.fromJson(json);
    }
    baseConfig!.outbound[0].addr = config.addr ?? "";
    baseConfig!.outbound[0].protocol = config.protocol ?? "";
    baseConfig!.outbound[0].protocol_settings.interval_second =
        config.intervalSecond ?? 0;
    baseConfig!.outbound[0].protocol_settings.skew_second = config.skewSecond ?? 0;
    baseConfig!.outbound[0].protocol_settings.secret_key = config.secretKey ?? "";
    baseConfig!.outbound[0].protocol_settings.sni = config.sni ?? "";
    baseConfig!.outbound[0].protocol_settings.read_deadline_second =
        config.readDeadlineSecond ?? 0;
    baseConfig!.outbound[0].protocol_settings.write_deadline_second =
        config.writeDeadlineSecond ?? 0;
    baseConfig!.outbound[0].protocol_settings.minSplitPacket = config.minSplitPacket ?? 0;
    baseConfig!.outbound[0].protocol_settings.maxSplitPacket = config.maxSplitPacket ?? 0;
    baseConfig!.outbound[0].protocol_settings.subChunk = config.subChunk ?? 0;
    baseConfig!.outbound[0].protocol_settings.padding = config.padding ?? 0;

    baseConfig!.outbound[0].users = [
      User(id: config.userId!, system_id: config.userId!)
    ];

    if (Platform.isAndroid) {
      baseConfig!.tun.start = true;

      final bool getPermission =
          await platform.invokeMethod('requestPermission');
      if (!getPermission) {
        return "Permission Denied";
      }
      // Getfd
      final fileDescriptor = await platform.invokeMethod('getFd');
      baseConfig!.tun.name = "fd://$fileDescriptor";

      final encodeJson = jsonEncode(baseConfig!.toJson());
      // start steal
      await platform.invokeMethod('startSteal', {"config": encodeJson});
    } else if (Platform.isWindows) {
      if (!isAdmin()) {
        return "Tun mode need run as administrator";
      }

      baseConfig!.tun.name = "StealClient";
      String encodeJson = jsonEncode(baseConfig!.toJson());
      String configPath =
          path.join("data", "flutter_assets", "assets", "config.json");
      if (!File(configPath).existsSync()){
          configPath = path.join("assets", "config.json");
      }
      await File(configPath).writeAsString(encodeJson);

      corePath =
          path.join("data", "flutter_assets", "assets", "windows", "steal.exe");
      if (!File(corePath).existsSync()){
          corePath = path.join("assets", "windows", "steal.exe");
      }

      proccess = await Process.start(corePath, ["-c", configPath]);

      File logFile = File('output.log');
      IOSink logSink = logFile.openWrite();

      proccess!.stdout.transform(utf8.decoder).listen((data) {
        logSink.write(data);
      });

      proccess!.stderr.transform(utf8.decoder).listen((data) {
        logSink.write(data);
      });

      proccess!.exitCode.then((code) async {
        await logSink.flush();
        await logSink.close();
      });
    }
    return "";
  }

  static Future<bool> stop() async {
    if (Platform.isAndroid) {
      if (await isActive()) {
        await platform.invokeMethod('stop');
      }
    } else if (Platform.isWindows) {
      proccess!.kill();
      await Process.run(corePath, ["-cleanup"]);
      await Process.run(
          "route", ["delete", baseConfig!.outbound[0].addr.split(":")[0]]);
      proccess = null;
    }
    return true;
  }

  static Future<bool> isActive() async {
    if (Platform.isAndroid) {
      return await platform.invokeMethod('isActive');
    } else if (Platform.isWindows) {
      if (proccess != null) {
        return true;
      }
    }
    return false;
  }

  static Future<int> ping() async {
    if (Platform.isAndroid) {
      return await platform.invokeMethod('ping');
    } else if (Platform.isWindows) {
      return 0;
    }
    return -1;
  }

  static bool isAdmin() {
    try {
      // Attempt to open the handle to \\.\PHYSICALDRIVE0
      File r = File(r'\\.\PHYSICALDRIVE0');
      r.openSync();
      return true;
    } catch (e) {
      // If an exception occurs, the application does not have administrative privileges
      return false;
    }
  }
}
