import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:yaml/yaml.dart';
import 'SendPage.dart';
import 'package:tflite/tflite.dart';


class DisplayPage extends StatefulWidget {

  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  double progress = 0;
  late List<String> imgs = [];
  late List<String> preds = [];
  late List<String> stats = [];

  bool isLoad = true;
  @override
  void initState() {
    super.initState();
      _loadModel().then((value) {
      setState(() {});
    });
    _loadFile();
  }
  _loadModel() async {
    await Tflite.loadModel(
      model: "assets/mobile.tflite",
      labels: "assets/labels.txt",
    ).then((value) {
      setState(() {

      });
    });
  }

  @override
  Widget build (BuildContext ctxt) {
    // if(isLoad){
    //   _loadFile();
    // }
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
          children: _rowList(imgs, preds, stats),
        ),
      ),
    );
  }

  List<Widget> _rowPrediction(String url, String pred, String stat){
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
                  // child:Image.asset(url, fit: BoxFit.fill)
                  child: Image.file(File(url), fit: BoxFit.fill)
              ))
      ),
      // Image.asset(imgs[0], fit: BoxFit.fill),
      const SizedBox(
          width: 30
      ),
      Expanded(
          child: Text(pred, style: const TextStyle(color: Colors.indigo)
          )
      ),
      const SizedBox(
          width: 30
      ),
      Expanded(
          child: Text(stat, style: const TextStyle(color: Colors.orange))
      )
    ];
  }
  List<Widget> _rowList(List imgs, List preds, List stats){
    List<Widget> rows = [];

    rows.add(
        const SizedBox(
        height: 10
    ));
    rows.add(SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
            strokeWidth: 10,
            backgroundColor: Colors.orange,
          ),
          Center(child: buildProgress()),
        ],
      ),));
    rows.add(
        const SizedBox(
            height: 10
        ));
    rows.add(
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
                minimumSize: const Size(100, 40), //////// HERE
              ),
              child: const Text("SUMMARY", style: TextStyle(fontFamily: 'Indies')),
              onPressed: (){Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SendPage()),
              );},
            ),
          ),
        )
    );
    rows.add(
        const SizedBox(
            height: 10
        ));
    rows.add(
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            // SizedBox(width: 30),
            SizedBox(
                width: 15
            ),
            Expanded(
              flex: 1,
              child: Text('Images',  style: TextStyle(color: Colors.indigo,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            ),
            Expanded(
              flex: 1,
              child: Text('Predictions',  style: TextStyle(color: Colors.indigo,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            ),
            Expanded(
              flex: 1,
              child: Text('Confidence',  style: TextStyle(color: Colors.indigo,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            ),
          ],
        )
    );
    rows.add(
      const SizedBox(
          height: 20
      ),);

    for (var idx = 0; idx < imgs.length; idx++){
      rows.add(Row(children: _rowPrediction(imgs[idx], preds[idx], stats[idx])));
    }

    return rows;
  }
  Widget buildProgress() {
    if (progress == 1) {
      return const Icon(
        Icons.done,
        color: Colors.orange,
        size: 56,
      );
    } else {
      return Text(
        (progress * 100).toStringAsFixed(1),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
          fontSize: 24,
        ),
      );
    }
  }

  Future<void> _loadFile() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());
    File file = File("${directory?.path}/imagesClassify.yaml");
    final string = file.readAsStringSync();
    final mapData = loadYaml(string);

    List<String> n_imgs = [];
    List<String> n_preds = [];
    List<String> n_stats = [];
    List x_list = [];
    List feat_and_classes = await _getMatrixTrains();

    double _currentSliderValue = mapData['threshold'];

    for (var idx=0 ; idx < mapData['images'].length; idx++) {
      n_imgs.add(mapData['images'][idx]);
      x_list = await _getProbability(mapData['images'][idx]);

      List ps = [];
      for (var i=0; i<feat_and_classes[0].length;i++){
        var p = _getCosineSimilarity(feat_and_classes[0][i], x_list);
        // var p = _getDistance(feat_and_classes[0][i], x_list);
        // var cs = _getCosineSimilarity(feat_and_classes[0][i], x_list);
        // print('$p _ $cs');
        ps.add(p*50+50);
      }

      var max_value = ps.reduce((curr, next) => curr > next? curr: next); // 8 --> Max
      var min_value = ps.reduce((curr, next) => curr < next? curr: next); // 1 --> Min

      // // Distance
      // int index_pred = ps.indexOf(min_value);
      // int index_pred = ps.indexOf(min_value);
      //
      // // n_stats.add(ps[index_pred].toString());
      // n_stats.add((1.0-(min_value/max_value)).toString());
      // n_preds.add(feat_and_classes[1][index_pred]);

      // Cosine
      int index_pred = ps.indexOf(max_value);

      // n_stats.add(ps[index_pred].toString());
      n_stats.add("${max_value.toStringAsFixed(3)} %");
      if (max_value <= _currentSliderValue){
        n_preds.add('Unknown');
      }
      else{
        print(_currentSliderValue);
        n_preds.add(feat_and_classes[1][index_pred]);
      }

      progress = progress + 1/mapData['images'].length;
      setState((){});
    }

    setState(() {
      isLoad = false;
      imgs = n_imgs;
      preds = n_preds;
      stats = n_stats;
      _savePredictions();
    });

  }
  Future<void> _savePredictions() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());

    File filePred = await File("${directory?.path}/pred.yaml");
    bool fileExists = await filePred.exists();
    if (fileExists == true){
      await filePred.delete();
    }
    await filePred.create();
    final settingsPred = SettingsYaml.load(pathToSettings:filePred.path);
    List checkList = [];

    for (var i=0; i<preds.length; i++) {
      var check = checkList.contains(preds[i]);
      if (check == true){
        settingsPred[preds[i]] = settingsPred[preds[i]] + 1;
      }
      else{
        settingsPred[preds[i]] = 1;
      }
      checkList.add(preds[i]);
    }
    settingsPred.save();
  }

  num _getDistance(List a, List b){
    num x = 0.0;
    for (var i=0; i< a.length;i++){
      num e = a[i] - b[i];
      x = x + e*e;
    }

    return sqrt(x);
  }

  num _getCosineSimilarity(List a, List b){
    num sumxx = 0.0;
    num sumxy = 0.0;
    num sumyy = 0.0;

    for (var i=0; i< a.length;i++){
      sumxx = sumxx + a[i]*a[i];
      sumyy = sumyy + b[i]*b[i];
      sumxy = sumxy + a[i]*b[i];
    }

    return sumxy/sqrt(sumxx*sumyy);
  }

  Future<List> _getProbability(String path_file) async {
    var output = await Tflite.runModelOnImage(
        path: path_file,
        asynch: true,
        numResults: 1000,
        imageMean: 127.0,
        imageStd: 127.0,
        threshold: -0.0
    );


    List prob = [for (var i = 0; i <= 1000; i++) 0.0];
    for (var i=0; i< output!.length;i++){
      prob[output[i]['index']] = output[i]['confidence'];

    }
    return prob;
  }

  Future<List> _getMatrixTrains() async{
    List<List> x = [];
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());
    File file = File("${directory?.path}/labels.yaml");
    final string = file.readAsStringSync();
    final mapData = loadYaml(string);

    List<String> loadClasses;
    List<String> loadImgs = [];

    loadClasses = List<String>.from(mapData.keys.toList());
    for (var idx = 0; idx < loadClasses.length; idx++){
      loadImgs.add(mapData[loadClasses[idx]][0]);
      x.add(await _getProbability(mapData[loadClasses[idx]][0]));
    }
    return [x, loadClasses];
  }

}

