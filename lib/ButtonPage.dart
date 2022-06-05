import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'RemovePage.dart';
import 'ClassifyPage.dart';


class ButtonPage extends StatefulWidget {
  @override
  _ButtonPageState createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
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

      body: SafeArea(
        child: Column(
          children: <Widget> [
            const SizedBox(
                height: 100
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
                  child: const Text("ADD CLASSES", style: TextStyle(fontFamily: 'Indies')),
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPage()),
                  );},
                ),
              ),
            ),
            const SizedBox(
                height: 30
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
                  child: const Text("REMOVE CLASSES", style: TextStyle(fontFamily: 'Indies')),
                  onPressed: (){Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RemovePage()),
                  );},
                ),
              ),
            ),
            const SizedBox(
                height: 30
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
                    MaterialPageRoute(builder: (context) => ClassifyPage()),
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