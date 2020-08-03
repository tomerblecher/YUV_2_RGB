import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Basic Camera widget, no functionality here.
///
/// The widget requires [CameraController] to load the actual camera on screen.
class CameraScreenWidget extends StatefulWidget {
  final CameraController controller;

  const CameraScreenWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreenWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.controller == null || !widget.controller.value.isInitialized) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text("Loading Camera...")
        ],
      ));
    } else {
      return AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: CameraPreview(widget.controller),
      );
    }
  }
}
