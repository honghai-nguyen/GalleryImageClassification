import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:yaml/yaml.dart';
import "package:flutter/services.dart";
import 'package:settings_yaml/settings_yaml.dart';


class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

writeFilesToCustomDevicePath(String label, String path) async {
  // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
  Directory? directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  // Create a new file. You can create any kind of file like txt, doc , json etc.
  final settings = SettingsYaml.load(pathToSettings:"${directory?.path}/labels.yaml");
  settings[label] = [path];
  settings.save();

}

class _AddPageState extends State<AddPage> {

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

    final string = file.readAsStringSync();

    final mapData = loadYaml(string);

    setState(() {
      // classes = mapData.keys;
      classes = List<String>.from(mapData.keys.toList());
      imgs = [];
      for (var idx = 0; idx < classes.length; idx++) {
        imgs.add(mapData[classes[idx]][0]);
      }
    });
  }
  bool isLoad = true;
  YamlMap? xx;
  List<String> imgs = [];
  List<String> classes = [];
  final _formKey = GlobalKey<FormState>();

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

            Row(
              children: [
                Expanded(
                    child: Center(
                      child: SizedBox(
                        height:60, //height of button
                        width:170,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            onPrimary: Colors.white,
                            shadowColor: Colors.greenAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: const Size(100, 40), //////// HERE
                          ),
                          child: const Text("Gallery",  style: TextStyle(fontFamily: 'Indies')),
                          onPressed: (){

                            _getFromGallery();

                          },
                    ),
                  ),
            )
              ),
                Expanded(
                    child:
                    Center(
                      child: SizedBox(
                        height:60, //height of button
                        width:170,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen,
                            onPrimary: Colors.white,
                            shadowColor: Colors.greenAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: const Size(100, 40), //////// HERE
                          ),
                          child: const Text("Take a photo",  style: TextStyle(fontFamily: 'Indies')),
                          onPressed: (){
                            _getFromCamera();
                          },
                        ),
                      ),
                    )
                )
              ],
            ),
            const SizedBox(
                height: 30
            ),
            const Text("Current classes", style: TextStyle(color: Colors.indigo,
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
  /// Get from gallery
  _getFromGallery() async {
    var imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      var nameOfClass = TextEditingController();
      setState(() {
        imageFile = File(imagePicker.path);
        showDialog(
            context: context,
            builder: (BuildContext context) {
          return AlertDialog(
              content: SafeArea(
                child: Column(
                children: <Widget>[
                    const Text('Update class',  style: TextStyle(color: Colors.indigo,
                    fontWeight: FontWeight.bold, fontFamily: 'Indies')),
                  Expanded(
                      child:
                          Container(
                            height: 140,
                            width: 180,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(imageFile),
                                fit: BoxFit.fill,
                              ),
                              ),
                      )

                  ),
                  const SizedBox(
                      height: 10
                  ),
                  Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Expanded(
                          // padding: const EdgeInsets.all(1.0),
                          child: TextFormField(
                            controller: nameOfClass,
                            decoration: const InputDecoration(hintText: 'Name of class'),
                          ),
                        ),
                        Expanded(
                          // padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreen,
                              onPrimary: Colors.white,
                              shadowColor: Colors.greenAccent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                              minimumSize: const Size(100, 40), //////// HERE
                            ),
                            child: const Text("Update",  style: TextStyle(fontFamily: 'Indies')),
                            onPressed: () async {
                              var name = nameOfClass.text;
                              if (name != null) {
                                writeFilesToCustomDevicePath(name, imagePicker.path);
                                imgs.add(imagePicker.path);
                                classes.add(name);
                                print(imgs);
                                Navigator.pop(context, true);

                                setState(() {
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  )
                ],
              )
              )
          );}
              );
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    var imagePicker = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imagePicker != null) {
      var nameOfClass = TextEditingController();
      setState(() {
        imageFile = File(imagePicker.path);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: SafeArea(
                      child: Column(
                        children: <Widget>[
                          const Text('Update class',  style: TextStyle(color: Colors.indigo,
                              fontWeight: FontWeight.bold, fontFamily: 'Indies')),
                          Expanded(
                              child:
                              Container(
                                height: 140,
                                width: 180,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(imageFile),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )

                          ),
                          const SizedBox(
                              height: 10
                          ),
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: <Widget>[

                                  Expanded(
                                    // padding: const EdgeInsets.all(1.0),
                                    child: TextFormField(
                                      controller: nameOfClass,
                                      decoration: const InputDecoration(hintText: 'Name of class'),
                                    ),
                                  ),
                                  Expanded(
                                    // padding: const EdgeInsets.all(1.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.lightGreen,
                                        onPrimary: Colors.white,
                                        shadowColor: Colors.greenAccent,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(32.0)),
                                        minimumSize: const Size(100, 40), //////// HERE
                                      ),
                                      child: const Text("Update",  style: TextStyle(fontFamily: 'Indies')),
                                      onPressed: () {
                                        var name = nameOfClass.text;
                                        if (name != null) {
                                          writeFilesToCustomDevicePath(name, imagePicker.path);
                                          imgs.add(imagePicker.path);
                                          classes.add(name);
                                          // _refresh();
                                          Navigator.pop(context, true);
                                          setState(() {
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                  )
              );}
        );
      });
    }
  }


  List<Widget> _rowClass(String url, String clas){
    return  <Widget>[
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
          width: 30
      )),
      Expanded(
          child: Text(clas, style: const TextStyle(color: Colors.indigo)
          )
      ),
    ];
  }

  List<Widget> _rowList(List imgs, List classes){
    List<Widget> rows = [];
    for (var idx = 0; idx < imgs.length; idx++){
      rows.add(Row(children: _rowClass(imgs[idx], classes[idx])));
    }
    return rows;
  }
}