import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePicture extends StatefulWidget {
  TakePicture({Key? key}) : super(key: key);
  @override
  TakePictureState createState() => TakePictureState();
}
class TakePictureState extends State<TakePicture> {
  var _firstCamera;
  Future<void> initcamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    _firstCamera = cameras.first;
  }
  @override
  void initState() {
    super.initState();
    // initcamera();
  }

  @override
  Widget build(BuildContext context) {
    // return  MaterialApp(
    //   home: TakePictureScreen(
    //     // Pass the appropriate camera to the TakePictureScreen widget.
    //     camera: _firstCamera,
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black), centerTitle: true),
      body: FutureBuilder<void>(
        future: initcamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return MaterialApp(
              home: TakePictureScreen(
                // Pass the appropriate camera to the TakePictureScreen widget.
                camera: _firstCamera,
              ),
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late String _imgPath;

  @override
  void initState() {
    super.initState();
    onNewCameraSelected();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop("");
            },
          ),
          FloatingActionButton(
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;
                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();
                _imgPath = image.path;
                // If the picture was taken, display it on a new screen.
                bool pictaken = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      // Pass the automatically generated path to
                      // the DisplayPictureScreen widget.
                      imagePath: _imgPath,
                    ),
                  ),
                );
                if (pictaken) {
                  dispose();
                  Navigator.of(context).pop(_imgPath);
                }
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      // _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) {
        onNewCameraSelected();
      }
    }
  }

  void onNewCameraSelected() {
    // if (_controller != null) {
    //   _controller!.dispose();
    // }
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Camera error ${_controller.value.errorDescription}'),
          duration: const Duration(seconds: 1),
          action: SnackBarAction(
            label: 'ACTION',
            onPressed: () {},
          ),
        ));
      }
    });
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     iconTheme: IconThemeData(color: Colors.black), centerTitle: true),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Center(child: Image.file(File(imagePath))),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.cancel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.done),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
