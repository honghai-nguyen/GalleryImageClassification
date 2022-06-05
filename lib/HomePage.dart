import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:yaml/yaml.dart';
import 'ButtonPage.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();

}

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
}
class _HomePageState extends State<HomePage> {
  List<String> imgs = [
    "./assets/imgs/car.png",
    "./assets/imgs/cat.png",
    "./assets/imgs/dog.png",
    "./assets/imgs/fruit.png",
    "./assets/imgs/food.png",
    "./assets/imgs/tree.png",
  ];
  void initState() {
    super.initState();
    // _loadFile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Center(child: Text('GALLERY IMAGE CLASSIFICATION',  style: TextStyle(
            color: Colors.indigo, fontFamily: 'Indies', fontWeight: FontWeight.bold, fontSize: 17
        ))),
        backgroundColor: Colors.green[300],
      ),

      body: SafeArea(
        child: Column(
          children: <Widget> [
                          const SizedBox(
                              height: 10
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            children: imgs.map((url){
                              return Card(elevation: 4.0,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)),),
                              child:Image.asset(url, fit: BoxFit.fill));
                             }).toList(),
                            ),
                          const SizedBox(
                              height: 10
                          ),
                          Center(
                            child: SizedBox(
                              height:60, //height of button
                              width:200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.lightGreen,
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.greenAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0)),
                                  minimumSize: Size(100, 30), //////// HERE
                                ),
                                child: const Text("START", style: TextStyle(fontFamily: 'Indies')),
                                onPressed: (){Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ButtonPage()),
                                );},
                              ),
                          ),
                          ),
          ],
        ),
      ),
    );

  }
}
