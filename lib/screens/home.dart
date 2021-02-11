import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    print('f');
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 5,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  pickImage() async {
    try {
      var image = await picker.getImage(source: ImageSource.camera);
      assert(image != null);
      setState(() {
        _image = File(image.path);
      });
      classifyImage(_image);
    } catch (e) {
      print('errrrr');
      print(e);
      return null;
    }
  }

  pickGalleryImage() async {
    try {
      var image = await picker.getImage(source: ImageSource.gallery);
      assert(image != null);
      setState(() {
        _image = File(image.path);
      });
      classifyImage(_image);
    } catch (e) {
      print('errrrr');
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.004,
                    1
                  ],
                  colors: [
                    Color(0xFFa8e863),
                    Color(0xFF56ab2f),
                  ]),
            ),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    columnContentWidgets(
                        title: 'Detect Flowers',
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontsize: 28),
                    columnContentWidgets(
                      title: 'Custom Tensorflow CNN',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7)
                          ]),
                      child: Column(
                        children: [
                          Container(
                            child: Center(
                              child: _loading
                                  ? loadingWidget()
                                  : contentWidget(
                                      image: _image, output: _output),
                            ),
                          ),
                          Container(
                            width: _deviceWidth,
                            child: Column(
                              children: [
                                actionButtonWidget(
                                    function: pickImage,
                                    deviceWidth: _deviceWidth,
                                    title: 'Take a photo'),
                                SizedBox(
                                  height: 10,
                                ),
                                actionButtonWidget(
                                    function: pickGalleryImage,
                                    deviceWidth: _deviceWidth,
                                    title: 'Camera roll')
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}

Widget contentWidget({File image, List output}) {
  print(image.path);
  return Container(
    child: Column(
      children: [
        Container(
          height: 300,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(image)),
        ),
        SizedBox(
          height: 20,
        ),
        output != null && output.length > 0
            ? Text(
                'prediction is: ${output[0]['label']}'
                    .trim()
                    .replaceFirst(new RegExp(r'0|1'), ''),
                style: TextStyle(color: Colors.black, fontSize: 20),
              )
            : Container()
      ],
    ),
  );
}

Widget loadingWidget() {
  return Container(
    width: 300,
    child: Column(
      children: [
        Image.asset('assets/flower.png'),
        SizedBox(
          height: 50,
        )
      ],
    ),
  );
}

Widget actionButtonWidget({num deviceWidth, String title, Function function}) {
  return GestureDetector(
    onTap: function,
    child: Container(
      width: deviceWidth - 100,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      decoration: BoxDecoration(
        color: Color(0xFF56ab2f),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    ),
  );
}

//Flower content in column.
Widget columnContentWidgets(
    {String title, Color color, double fontsize, FontWeight fontWeight}) {
  return Text(
    title,
    style: TextStyle(color: color, fontWeight: fontWeight, fontSize: fontsize),
  );
}
