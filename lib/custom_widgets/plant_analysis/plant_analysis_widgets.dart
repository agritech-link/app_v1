import 'package:AgriTech_Link/custom_widgets/plant_analysis/analysis_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

import '../../notifiers/camera_state_notifier.dart';

class UnifiedCameraPage extends ConsumerStatefulWidget {
  @override
  _UnifiedCameraPageState createState() => _UnifiedCameraPageState();
}

class _UnifiedCameraPageState extends ConsumerState<UnifiedCameraPage> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await ref.read(cameraStateProvider.notifier).initializeCamera();
  }

  Future<void> _processImage() async {
    try {
      final cameraNotifier = ref.read(cameraStateProvider.notifier);
      await cameraNotifier.analyzePlant();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error processing image: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateProvider);

    if (cameraState.isAnalyzing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.grey,),
              SizedBox(height: 20),
              Text('Analyzing plant...'),
            ],
          ),
        ),
      );
    }

    if (cameraState.condition != null && cameraState.recommendations != null) {
      return ResultsPage();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: <Widget>[
                if (cameraState.controller != null)
                  CameraPreview(cameraState.controller!),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Text(
                              'Scan crops',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            IconButton(
                              icon: Icon(Icons.help_outline, color: Colors.white),
                              onPressed: () {
                                // Show help or instructions
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(Icons.photo_library, color: Colors.white, size: 30),
                              onPressed: () async {
                                await ref.read(cameraStateProvider.notifier).pickImageFromGallery();
                                await _processImage();
                              },
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt, color: Colors.black),
                              onPressed: () async {
                                await ref.read(cameraStateProvider.notifier).takePicture();
                                await _processImage();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                              onPressed: () async {
                                await ref.read(cameraStateProvider.notifier).flipCamera();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}