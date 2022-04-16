import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:voicebot/main.dart';
import 'package:tflite/tflite.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
{
  bool isWorking = false;
  String result="";
  CameraController cameraController;
  CameraImage imgCamera;

  loadModel() async
  {
    await Tflite.loadModel(
      model: "assets/mobilenet_v1_1.0_224.tflite",
      labels: "assets/mobilenet_v1_1.0_224.txt",
      // model: "assets/yolov2_tiny.tflite",
      // labels:"assets/yolov2_tiny.txt",
      // model: "assets/ssd_mobilenet.tflite",
      // labels: "assets/ssd_mobilenet.txt",
    );
  }

  initCamera()
  {
    cameraController = CameraController(cameras[0], ResolutionPreset.high );
    cameraController.initialize().then((value)
    {

      if(!mounted)
      {
        return;
      }

      setState(() {
        cameraController.startImageStream((imageFromStream) =>
        {

          if(!isWorking)
            {
              isWorking = true,
              imgCamera = imageFromStream,
              runModelOnStreamFrames(),
            }

        });

      });

    });

  }
  runModelOnStreamFrames() async
  {
    if(imgCamera != null)
    {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera.planes.map((plane)
        {
          return plane.bytes;
        }).toList(),

        imageHeight: imgCamera.height,
        imageWidth: imgCamera.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      result = "";

      recognitions.forEach((response)
      {
        result += response["label"] + "  " + (response["confidence"] as double).toStringAsFixed(2) + "\n\n";
      });
      setState(() {
        result;
      });

      isWorking = false;
    }
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  @override
  void dispose() async
  {
    super.dispose();

    await Tflite.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/jarvis1.jpg")
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Center(
                      child: Container(
                        color: Colors.black,
                        height: 450,
                        width: 360,
                        child: Image.asset("assets/camera1.png"),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                        onPressed: (){
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 100),
                          height: 270,
                          width: 360,
                          child: imgCamera == null
                              ? Container(
                            height: 270,
                            width: 360,
                            child: Icon(Icons.photo_camera_front, color: Colors.blueAccent, size: 40,),
                          )
                              : AspectRatio(
                            aspectRatio: cameraController.value.aspectRatio,
                            child: CameraPreview(cameraController),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: SingleChildScrollView(
                            child: Text("Output",style: TextStyle(fontSize: 30.0,color: Colors.black))
                        )
                    )
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 50.0),
                    child: SingleChildScrollView(
                      child: Text(


                        result,
                        style: TextStyle(
                          backgroundColor: Colors.black87,
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
