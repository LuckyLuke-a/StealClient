class Inbound {
  final String addr;
  final String protocol;
  Inbound({required this.addr, required this.protocol});

  factory Inbound.fromJson(Map<String, dynamic> json) {
    return Inbound(
      addr: json['addr'],
      protocol: json['protocol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addr": addr,
      "protocol": protocol,
    };
  }
}

class User {
  final String id;
  final String system_id;
  User({required this.id, required this.system_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      system_id: json['system_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "system_id": system_id,
    };
  }
}

class ProtocolSettings {
  String secret_key;
  int interval_second;
  int skew_second;
  String sni;
  int read_deadline_second;
  int write_deadline_second;

  ProtocolSettings({
    required this.secret_key,
    required this.interval_second,
    required this.skew_second,
    required this.sni,
    required this.read_deadline_second,
    required this.write_deadline_second,
  });

  factory ProtocolSettings.fromJson(Map<String, dynamic> json) {
    return ProtocolSettings(
      secret_key: json['secret_key'],
      interval_second: json['interval_second'],
      skew_second: json['skew_second'],
      sni: json['sni'],
      read_deadline_second: json['read_deadline_second'],
      write_deadline_second: json['write_deadline_second'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "secret_key": secret_key,
      "interval_second": interval_second,
      "skew_second": skew_second,
      "sni": sni,
      "read_deadline_second": read_deadline_second,
      "write_deadline_second": write_deadline_second,
    };
  }
}

class Outbound {
  String addr;
  String protocol;
  ProtocolSettings protocol_settings;
  List<User> users;

  Outbound({
    required this.addr,
    required this.protocol,
    required this.protocol_settings,
    required this.users,
  });

  factory Outbound.fromJson(Map<String, dynamic> json) {
    return Outbound(
      addr: json['addr'],
      protocol: json['protocol'],
      protocol_settings: ProtocolSettings.fromJson(json['protocol_settings']),
      users: (json['users'] as List).map((i) => User.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "addr": addr,
      "protocol": protocol,
      "protocol_settings": protocol_settings.toJson(),
      "users": users.map((i) => i.toJson()).toList(),
    };
  }
}

class Tun {
  bool start;
  String name;
  int mtu;
  Tun({required this.start, required this.name, required this.mtu});

  factory Tun.fromJson(Map<String, dynamic> json) {
    return Tun(
      start: json['start'],
      name: json['name'],
      mtu: json['mtu'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "start": start,
      "name": name,
      "mtu": mtu,
    };
  }
}

class BaseConfig {
  final List<Inbound> inbound;
  List<Outbound> outbound;
  Tun tun;
  final bool logging;
  final bool debug_mode;
  final String restapi;

  BaseConfig({
    required this.inbound,
    required this.outbound,
    required this.tun,
    required this.logging,
    required this.debug_mode,
    required this.restapi,
  });

  factory BaseConfig.fromJson(Map<String, dynamic> json) {
    return BaseConfig(
      inbound:
          (json['inbounds'] as List).map((i) => Inbound.fromJson(i)).toList(),
      outbound:
          (json['outbounds'] as List).map((i) => Outbound.fromJson(i)).toList(),
      tun: Tun.fromJson(json['tun']),
      logging: json['logging'],
      debug_mode: json['debug_mode'],
      restapi: json['restapi']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "inbounds": inbound.map((i) => i.toJson()).toList(),
      "outbounds": outbound.map((i) => i.toJson()).toList(),
      "tun": tun.toJson(),
      "logging": logging,
      "debug_mode": debug_mode,
      "restapi": restapi,
    };
  }
}
