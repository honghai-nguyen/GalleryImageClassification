
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'DisplayPage.dart';


class ClassifyPage extends StatefulWidget {
  @override
  _ClassifyPageState createState() => _ClassifyPageState();
}

class _ClassifyPageState extends State<ClassifyPage> {
  late ImagePicker image_test;
  List<String> imagesFile =[];
  bool mobilenet = true;
  bool efficient = false;
  late double _currentSliderValue = 50;
  // String _textThreshold = 'Value of threshold: ${_currentSliderValue.toString()};

  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Center(child: Text('GALLERY IMAGE CLASSIFICATION',  style: TextStyle(
            color: Colors.indigo, fontFamily: 'Indies', fontWeight: FontWeight.bold, fontSize: 17
        ))),
        backgroundColor: Colors.green[300],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            const SizedBox(
                height: 10
            ),
            const Text("Select the model", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            const SizedBox(
                height: 10
            ),
            CheckboxListTile(
              title: const Text('MobileNet', style: TextStyle(color: Colors.orange,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
              value: mobilenet,
              onChanged: (value){
                setState(() {
                  mobilenet = value!;
                  efficient = !mobilenet;
                });
              },
            ),
            const SizedBox(
                height: 10
            ),
            CheckboxListTile(
              title: const Text('EfficientNet', style: TextStyle(color: Colors.orange,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
              value: efficient,
              onChanged: (value){
                setState(() {
                  efficient = value!;
                  mobilenet = !efficient;
                });
              },
            ),
            const SizedBox(
                height: 10
            ),
            Text("The value of threshold: ${_currentSliderValue.toStringAsFixed(3)} %",
                style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            const SizedBox(
                height: 10
            ),

            SfSlider(
              min: 0.0,
              max: 100.0,
              value: _currentSliderValue,
              interval: 20,
              showTicks: true,
              showLabels: true,
              enableTooltip: true,
              minorTicksPerInterval: 1,
              onChanged: (dynamic value){
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),

            const SizedBox(
                height: 10
            ),
            const Text("Select the image", style: TextStyle(color: Colors.indigo,
                fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            const SizedBox(
                height: 10
            ),

            const SizedBox(
                width: 10
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
                    height: 20
                ),
            Center(
                child: imagesFile.isEmpty
                    ? const Text('No image selected.'):
                GridView.count(
                  shrinkWrap: true,
                  physics:  const ScrollPhysics(),
                  crossAxisCount: 3,
                  // childAspectRatio: 5,
                  // crossAxisSpacing: 10.0,
                  // mainAxisSpacing: 10.0,
                  // children: imgs,
                  children: imagesFile.map((url){
                    return Card(
                        elevation: 4.0,
                        child:Image.file(File(url), fit: BoxFit.fill)
                    );
                  }).toList(),
                ),
            ),

            const SizedBox(
                height: 20
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
                    minimumSize: const Size(100, 30), //////// HERE
                  ),
                  child: const Text("CLASSIFICATION", style: TextStyle(fontFamily: 'Indies')),
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DisplayPage()),
                  );},
                ),
              ),
            ),
            const SizedBox(
                height: 20
            ),
          ],
        ),
      ),
    );
  }
  _getFromGallery() async {
    var imagePicker = await ImagePicker().pickMultiImage();
    if (imagePicker!.isNotEmpty) {
      for (var i=0; i<imagePicker.length;i++){
        imagesFile.add(imagePicker[i].path);
      }
      // imgs = Image.file(File(imagePicker.path), fit: BoxFit.fill);
      // imagesFile.add(imagePicker.path);
      _saveFileImages();
      setState(() {
      });
    }
    }

  _getFromCamera() async {
    var imagePicker = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imagePicker != null) {
      imagesFile.add(imagePicker.path);
      _saveFileImages();
      setState(() {
      });
    }
  }
  Future<void> _saveFileImages() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());

    File file = await File("${directory?.path}/imagesClassify.yaml").create();

    final settings = SettingsYaml.load(pathToSettings:file.path);
    settings['images'] = imagesFile;
    settings['threshold'] = _currentSliderValue;
    print("SAVE IMAGE");
    print(imagesFile);
    settings.save();
  }

}
