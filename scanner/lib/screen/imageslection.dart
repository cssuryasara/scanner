// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:scanner/provider/imagefile.dart';
// import 'package:scanner/screen/preview.dart';

// class GetImages extends StatefulWidget {
//   GetImages({Key key}) : super(key: key);

//   @override
//   _GetImagesState createState() => _GetImagesState();
// }

// class _GetImagesState extends State<GetImages> {
//   File _image;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//         Provider.of<ImageFiles>(context, listen: false).addItem(_image);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   // Widget buildGridView(List<File> images,) {

//   //   return GridView.count(
//   //     crossAxisCount: 3,
//   //     children: List.generate(images.length, (index) {
//   //       return Image.file(images[index]);
//   //     }),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     List<File> images = Provider.of<ImageFiles>(context).itemss;
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             // Center(child: Text('Error: $_error')),
//             RaisedButton(
//               child: Text("Pick images"),
//               onPressed: () => getImage(),
//             ),
//             RaisedButton(
//               child: Text("Pick imagepp"),
//               onPressed: () => Navigator.push(
//                   context, MaterialPageRoute(builder: (ctx) => Preview())),
//             ),
//             // Expanded(
//             //   child: buildGridView(images),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/provider/imagefile.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<File> images = Provider.of<ImageFiles>(context).itemss;
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ClipOval(
            child: Material(
              color: Colors.blue,
              child: InkWell(
                splashColor: Colors.red,
                child: SizedBox(
                    width: 56, height: 56, child: Icon(Icons.photo_outlined)),
                onTap: () {},
              ),
            ),
          ),
          ClipOval(
            child: Material(
              color: Colors.blue,
              child: InkWell(
                splashColor: Colors.red,
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(Icons.camera_alt_outlined)),
                onTap: () async {
                  try {
                    await _initializeControllerFuture;
                    final image = await _controller.takePicture();

                    // If the picture was taken, display it on a new screen.
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DisplayPictureScreen(
                    //       // Pass the automatically generated path to
                    //       // the DisplayPictureScreen widget.
                    //       imagePath: image?.path,
                    //     ),
                    //   ),
                    // );
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
          ),
          Container(
            child: images == null
                ? Icon(Icons.image)
                : Image.file(images[0]),
          )
        ],
      ),
    );
  }
}

// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
