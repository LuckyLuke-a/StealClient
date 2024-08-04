import 'package:get/get.dart';
import 'package:steal_client/models/config_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigController extends GetxController {
  RxList allConfigs = <ConfigModel>[].obs;

  @override
  void onInit() {
    loadConfigs();
    super.onInit();
  }

  void loadConfigs() {
    Box<ConfigModel> box = Hive.box<ConfigModel>("configs");
    allConfigs.assignAll(box.values.toList());
  }

  Future<void> deleteConfig(int index) async {
    Box<ConfigModel> box = Hive.box<ConfigModel>("configs");
    await box.deleteAt(index);
  }
}

class NewConfig extends GetxController {
  late final Rx<ConfigModel> model = ConfigModel(
    addr: "",
    protocol: "",
    userId: "",
    secretKey: "",
    intervalSecond: 0,
    skewSecond: 0,
    sni: "",
    readDeadlineSecond: 0,
    writeDeadlineSecond: 0,
  ).obs;

  void initlizeValues(ConfigModel getModel) {
    setAddr(getModel.addr);
    setType(getModel.protocol);
    setUserId(getModel.userId ?? "");
    setSecretKey(getModel.secretKey);
    setIntervalSecond(getModel.intervalSecond.toString());
    setSkewSecond(getModel.skewSecond.toString());
    setSni(getModel.sni);
    setReadDeadlineSecond(getModel.readDeadlineSecond.toString());
    setWriteDeadlineSecond(getModel.writeDeadlineSecond.toString());
  }

  void setAddr(String addr) {
    model.update((value) {
      value?.addr = addr;
    });
  }

  void setType(String protocol) {
    model.update((value) {
      value?.protocol = protocol;
    });
  }

  void setUserId(String userId) {
    model.update((value) {
      value?.userId = userId;
    });
  }

  void setSecretKey(String secretKey) {
    model.update((value) {
      value?.secretKey = secretKey;
    });
  }

  void setIntervalSecond(String intervalSecond) {
    model.update((value) {
      value?.intervalSecond = int.parse(intervalSecond);
    });
  }

  void setSkewSecond(String skewSecond) {
    model.update((value) {
      value?.skewSecond = int.parse(skewSecond);
    });
  }

  void setSni(String sni) {
    model.update((value) {
      value?.sni = sni;
    });
  }

  void setReadDeadlineSecond(String readDeadlineSecond) {
    model.update((value) {
      value?.readDeadlineSecond = int.parse(readDeadlineSecond);
    });
  }

  void setWriteDeadlineSecond(String writeDeadlineSecond) {
    model.update((value) {
      value?.writeDeadlineSecond = int.parse(writeDeadlineSecond);
    });
  }
}
