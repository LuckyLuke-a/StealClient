import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steal_client/controllers/config_controller.dart';
import 'package:steal_client/pages/addconfig_page.dart';

class AppbarPage extends StatelessWidget implements PreferredSizeWidget {
  final bool addButton;
  const AppbarPage({
    super.key,
    required this.addButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Color.fromRGBO(238, 238, 238, 1),
      ),
      actions: addButton
          ? <Widget>[
              IconButton(
                onPressed: () async {
                  bool? result = await Get.to(() => const AddEditConfigPage());
                  if (result == true) {
                    Get.find<ConfigController>().loadConfigs();
                  }
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Color.fromRGBO(238, 238, 238, 1),
                ),
              ),
            ]
          : null,
      title: const Text(
        "Steal Client",
        style: TextStyle(
            color: Color.fromRGBO(238, 238, 238, 1), letterSpacing: 4),
      ),
      backgroundColor: const Color.fromRGBO(32, 30, 67, 1),
      elevation: 10,
      shadowColor: const Color.fromRGBO(32, 30, 67, 1),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
