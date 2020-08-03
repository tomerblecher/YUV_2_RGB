import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuvtransform/camera_handler.dart';
import 'package:yuvtransform/service/image_result_processor_service.dart';

import 'camera_screen.dart';

class YuvTransformScreen extends StatefulWidget {
  @override
  _YuvTransformScreenState createState() => _YuvTransformScreenState();
}

class _YuvTransformScreenState extends State<YuvTransformScreen>
    with CameraHandler, WidgetsBindingObserver {
  List<StreamSubscription> _subscription = List();
  ImageResultProcessorService _imageResultProcessorService;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Registers the page to observer for life cycle managing.
    _imageResultProcessorService = ImageResultProcessorService();
    WidgetsBinding.instance.addObserver(this);
    _subscription.add(_imageResultProcessorService.queue.listen((event) {
      _isProcessing = false;
    }));
    onNewCameraSelected(cameras[cameraType]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Dispose all streams!
    _subscription.forEach((element) {
      element.cancel();
    });
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        print("Camera error: ${controller.value.errorDescription}");
      }
    });

    try {
      await controller.initialize();

      await controller
          .startImageStream((CameraImage image) => _processCameraImage(image));
    } on CameraException catch (e) {
      showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isProcessing)
      return; //Do not detect another image until you finish the previous.
    _isProcessing = true;
    print("Sent a new image and sleeping for: $DELAY_TIME");
    await Future.delayed(Duration(milliseconds: DELAY_TIME),
        () => _imageResultProcessorService.addRawImage(image));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: CameraScreenWidget(
              controller: controller,
            ),
          ),
        ],
      )
    ])));
  }
}
