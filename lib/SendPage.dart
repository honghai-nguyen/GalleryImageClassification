import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:yaml/yaml.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  Map<String, double> dataMap = {};
  bool loadData = false;

  @override
  Widget build (BuildContext ctxt) {
    if (loadData == false){
      _loadFile();
      loadData = true;
    }
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Center(child: Text('GALLERY IMAGE CLASSIFICATION',  style: TextStyle(
            color: Colors.indigo, fontFamily: 'Indies', fontWeight: FontWeight.bold, fontSize: 17
        ))),
        backgroundColor: Colors.green[300],
      ),

      body: SafeArea(
        child: dataMap.isEmpty? Text(""): PieChart(dataMap: dataMap),
      ),
    );
  }

  List<Widget> _rowPrediction(String label, int num){
    return  <Widget>[
      const SizedBox(
          width: 10
      ),
      Expanded(
          child: Text(label, style: const TextStyle(color: Colors.indigo, fontFamily: 'Indies')
          )
      ),
      Expanded(
          child: Text('$num Images', style: const TextStyle(color: Colors.orange, fontFamily: 'Indies'))
      )
    ];
  }
  List<Widget> _rowList(List classes, List nums){
    List<Widget> rows = [];
    rows.add(
        const SizedBox(
            height: 20
        ));
    rows.add(
        Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            SizedBox(
                width: 10
            ),
            Expanded(
              flex: 1,
              child: Text('Classes',  style: TextStyle(color: Colors.red,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            ),
            Expanded(
              flex: 1,
              child: Text('Total',  style: TextStyle(color: Colors.red,
                  fontWeight: FontWeight.bold, fontFamily: 'Indies')),
            ),
          ],
        )
    );
    for (var idx = 0; idx < classes.length; idx++){
      rows.add(const SizedBox(
          height: 20
      ));
      rows.add(Row(children: _rowPrediction(classes[idx], nums[idx])));
    }
    return rows;
  }

  _loadFile() async {
    Directory? directory = (Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory());
    File file = File("${directory?.path}/pred.yaml");
    final string = file.readAsStringSync();
    final mapData = loadYaml(string);
    var loadClasses = List<String>.from(mapData.keys.toList());
    for (var idx = 0; idx < loadClasses.length; idx++){
      dataMap[loadClasses[idx]] = mapData[loadClasses[idx]].toDouble();
    }
    print("DATA MAP");
    print(dataMap);
    setState(() {});
  }
}