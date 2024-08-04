import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steal_client/controllers/config_controller.dart';
import 'package:steal_client/models/config_model.dart';
import 'package:steal_client/pages/appbar_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddEditConfigPage extends StatefulWidget {
  final ConfigModel? isEditConfigModel;
  final int? configIndex;
  const AddEditConfigPage(
      {super.key, this.isEditConfigModel, this.configIndex});

  @override
  State<AddEditConfigPage> createState() => _AddconfigPageState();
}

class _AddconfigPageState extends State<AddEditConfigPage> {
  final NewConfig newConfig = NewConfig();

  @override
  void initState() {
    if (widget.isEditConfigModel != null) {
      newConfig.initlizeValues(widget.isEditConfigModel!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarPage(addButton: false),
      backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomFiledWidget(
              label: "Server Address",
              onChanged: newConfig.setAddr,
              keyboardType: TextInputType.text,
              initialValue: newConfig.model.value.addr,
            ),
            CustomFiledWidget(
              label: "Protocol",
              onChanged: newConfig.setType,
              keyboardType: TextInputType.text,
              initialValue: newConfig.model.value.protocol,
            ),
            CustomFiledWidget(
              label: "Secret Key",
              onChanged: newConfig.setSecretKey,
              keyboardType: TextInputType.text,
              initialValue: newConfig.model.value.secretKey,
            ),
            CustomFiledWidget(
              label: "User ID",
              onChanged: newConfig.setUserId,
              keyboardType: TextInputType.text,
              initialValue: newConfig.model.value.userId ?? "",
            ),
            CustomFiledWidget(
              label: "Interval Second",
              onChanged: newConfig.setIntervalSecond,
              keyboardType: TextInputType.number,
              initialValue: newConfig.model.value.intervalSecond.toString(),
            ),
            CustomFiledWidget(
              label: "Skew Second",
              onChanged: newConfig.setSkewSecond,
              keyboardType: TextInputType.number,
              initialValue: newConfig.model.value.skewSecond.toString(),
            ),
            CustomFiledWidget(
              label: "Sni",
              onChanged: newConfig.setSni,
              keyboardType: TextInputType.text,
              initialValue: newConfig.model.value.sni,
            ),
            CustomFiledWidget(
              label: "Read Deadline Second",
              onChanged: newConfig.setReadDeadlineSecond,
              keyboardType: TextInputType.number,
              initialValue: newConfig.model.value.readDeadlineSecond.toString(),
            ),
            CustomFiledWidget(
              label: "Write Deadline Second",
              onChanged: newConfig.setWriteDeadlineSecond,
              keyboardType: TextInputType.number,
              initialValue:
                  newConfig.model.value.writeDeadlineSecond.toString(),
            ),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(
              onPressed: saveData,
              child: Text(
                widget.isEditConfigModel == null
                    ? "Add Config"
                    : "Save Changes",
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  void saveData() async {
    Box<ConfigModel> box = Hive.box<ConfigModel>("configs");
    if (widget.isEditConfigModel != null) {
      // update
      await box.putAt(widget.configIndex!, newConfig.model.value);
    } else {
      // add
      await box.add(newConfig.model.value);
    }
    Get.back(result: true);
  }
}

class CustomFiledWidget extends StatelessWidget {
  final String label;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final String initialValue;

  const CustomFiledWidget({
    super.key,
    required this.label,
    required this.onChanged,
    required this.keyboardType,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autocorrect: false,
        style: const TextStyle(fontSize: 17),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
