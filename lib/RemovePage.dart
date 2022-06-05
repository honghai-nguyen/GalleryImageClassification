import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';
import "package:flutter/services.dart";
import 'package:settings_yaml/settings_yaml.dart';


class RemovePage extends StatefulWidget {
  @override
  _RemovePageState createState() => _RemovePageState();
}

class _RemovePageState extends State<RemovePage> {

  Future<void> _loadFile() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());
    bool fileExists = await File("${directory?.path}/labels.yaml").exists();

    if (fileExists == false){
      List<String> loadClasses;
      List<String> loadImgs = [];
      final data = await rootBundle.loadString('assets/yamlfiles/labels.yml');
      final mapData = loadYaml(data);

      loadClasses = List<String>.from(mapData.keys.toList());
      for (var idx = 0; idx < loadClasses.length; idx++){
        loadImgs.add(mapData[loadClasses[idx]][0]);
      }
      File file = await File("${directory?.path}/labels.yaml").create();

      final settings = SettingsYaml.load(pathToSettings:file.path);
      for (var idx = 0; idx < loadClasses.length; idx++){
        settings[loadClasses[idx]] = [loadImgs[idx]];
      }
      settings.save();
    }
    setState(() {
      File file = File("${directory?.path}/labels.yaml");
      final string = file.readAsStringSync();
      final mapData = loadYaml(string);

      // final data = await rootBundle.loadString('assets/yamlfiles/labels.yml');
      // final mapData = loadYaml(data);
      // classes = mapData.keys;
      classes = List<String>.from(mapData.keys.toList());
      for (var idx = 0; idx < classes.length; idx++){
        imgs.add(mapData[classes[idx]][0]);
      }
      isLoad = false;
    });


    // writeFilesToCustomDevicePath();

  }
  Future<void> _refresh() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());
    File file = File("${directory?.path}/labels.yaml");
    await file.delete();
    await file.create();
    final settings = SettingsYaml.load(pathToSettings:file.path);
    for (var idx = 0; idx < classes.length; idx++){
      settings[classes[idx]] = [imgs[idx]];
    }
    settings.save();
  }
  bool isLoad = true;
  YamlMap? xx;
  List<String> imgs = [];
  List<String> classes = [];

  late File imageFile;
  @override
  Widget build (BuildContext ctxt) {
    if(isLoad){
      _loadFile();
    }
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Center(child: Text('GALLERY IMAGE CLASSIFICATION',
            style: TextStyle(
                color: Colors.indigo,
                fontFamily: 'Indies',
                fontWeight: FontWeight.bold, fontSize: 17
            ))),
        backgroundColor: Colors.green[300],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            const SizedBox(
                height: 30
            ),
            const SizedBox(
                height: 30
            ),
            const Text("Please select the class to delete", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            const SizedBox(
                height: 30
            ),

            GridView.count(
              shrinkWrap: true,
              physics:  const ScrollPhysics(),
              crossAxisCount: 1,
              childAspectRatio: 5,
              children: _rowList(imgs, classes),
            ),
          ],
        ),
      ),
    );
  }
  List<Widget> _rowClass(String url, String clas, int idx){

    return  <Widget>[
      // AssetThumb(
      //   asset: asset,
      //   width: 300,
      //   height: 300,
      // ),

      const SizedBox(
          width: 10
      ),
      Expanded(
          child: SizedBox(
              height: 90,
              width: 90,
              child: Card(
                  elevation: 4.0,
                  child:Image.file(File(url), fit: BoxFit.fill))
          )
      ),
      // Image.asset(imgs[0], fit: BoxFit.fill),
      const Expanded(
          child:  SizedBox(
              width: 20
          )),
      Expanded(
          child: Text(clas, style: const TextStyle(color: Colors.indigo)
          )
      ),

      IconButton(
        icon: const Icon(Icons.delete),
        tooltip: 'Increase volume by 10',
        onPressed: () {
          setState(() {
            print("delete $idx");
            imgs.removeAt(idx);
            classes.removeAt(idx);
            _refresh();
          });
        },
      ),
      const Expanded(
          child:  SizedBox(
              width: 20
          )),
    ];
  }

  List<Widget> _rowList(List imgs, List classes){
    List<Widget> rows = [];
    for (var idx = 0; idx < imgs.length; idx++){
      rows.add(Row(children: _rowClass(imgs[idx], classes[idx], idx)));
    }
    return rows;
  }
}

