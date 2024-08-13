import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';
import 'package:steal_client/controllers/config_controller.dart';
import 'package:steal_client/pages/addconfig_page.dart';
import 'package:steal_client/pages/appbar_page.dart';
import 'package:steal_client/models/config_model.dart';
import 'package:steal_client/services/vpn_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RxBool isRunning = false.obs;
  final RxInt selectedItem = 0.obs;
  final RxString pingText = "Ping!".obs;
  final ConfigController configController = Get.put(ConfigController());

  @override
  void initState() {
    ManageVPNService.isActive().then((value) {
      isRunning.value = value;
    });
    pingText.value = "Ping!";

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (await ManageVPNService.isActive()) {
        await ManageVPNService.stop();
      }
      return true;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarPage(
        addButton: true,
      ),
      backgroundColor: const Color.fromRGBO(19, 75, 112, 1),
      body: Obx(() {
        return ListView.builder(
            itemCount: configController.allConfigs.length,
            itemBuilder: (BuildContext context, int index) {
              ConfigModel itemData = configController.allConfigs[index];
              return Obx(() {
                return InkWell(
                  onTap: () {
                    selectedItem.value = index;
                    if (isRunning.value) {
                      // stop
                      ManageVPNService.stop();

                      // start
                      ConfigModel config =
                          configController.allConfigs[selectedItem.value];
                      ManageVPNService.start(config);
                    }
                  },
                  child: Card(
                    color: const Color.fromRGBO(238, 236, 236, 1),
                    margin: const EdgeInsets.all(0),
                    surfaceTintColor: Colors.black,
                    shape: selectedItem.value == index
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(
                              color: Color.fromRGBO(124, 175, 188, 1),
                              width: 3,
                              style: BorderStyle.solid,
                            ),
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            itemData.addr ?? "",
                            style: const TextStyle(fontSize: 20),
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () async {
                                  bool? result =
                                      await Get.to(() => AddEditConfigPage(
                                            isEditConfigModel: itemData,
                                            configIndex: index,
                                          ));
                                  if (result == true) {
                                    configController.loadConfigs();
                                  }
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await configController.deleteConfig(index);
                                  configController.loadConfigs();
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            });
      }),
      bottomNavigationBar: Obx(() {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          height: isRunning.value ? 65 : 0,
          child: isRunning.value
              ? GestureDetector(
                  onTap: () {
                    pingText.value = "Checking...";
                    ManageVPNService.ping().then((value) {
                      pingText.value = "Ping: $value";
                    });
                  },
                  child: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    notchMargin: 8,
                    child: Text(
                      pingText.value,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                )
              : Container(),
        );
      }),
      floatingActionButton: Obx(() {
        return FloatingActionButton.large(
          onPressed: () {
            if (isRunning.value) {
              // stop
              ManageVPNService.stop().then((onValue) {
                if (onValue) {
                  isRunning.value = !isRunning.value;
                }
              });
            } else {
              // start
              ConfigModel config =
                  configController.allConfigs[selectedItem.value];
              ManageVPNService.start(config).then((value) {
                if (value != "") {
                  Get.snackbar("Error", value,
                      backgroundColor: Colors.black, colorText: Colors.white);
                } else {
                  isRunning.value = !isRunning.value;
                }
              });
            }
          },
          backgroundColor: isRunning.value
              ? const Color.fromRGBO(80, 140, 155, 1)
              : Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            size: 50,
            isRunning.value
                ? Icons.pause_circle_outline
                : Icons.play_circle_outline,
            color: isRunning.value
                ? Colors.white
                : const Color.fromRGBO(32, 30, 67, 1),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
