import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Face'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<File> getImage() async {
  File picture = await ImagePicker.pickImage(
    source: ImageSource.camera,
    maxWidth: 900,
    maxHeight: 900,
  );

  return picture;
}

// //add firebase_vision
Future<bool> isFace() async {
  File picture = await getImage();
  var _image;

  final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(picture);
  final faceDetector = FirebaseVision.instance.faceDetector();
  List<Face> faces = await faceDetector.processImage(visionImage);

  return (faces.length >= 1) ? true : false;
}

_showDialog(bool isFace, context) {
  var title = (isFace) ? 'Passou!' : 'Que pena';
  var body = (isFace) ? 'Parabens sua foto foi liberada' : 'Sua imagem não tinha um rosto';
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Face',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showDialog(await isFace(), context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
