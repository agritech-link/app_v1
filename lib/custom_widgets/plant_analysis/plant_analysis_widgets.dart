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

  Future<void> _processImageAndNavigate() async {
    try {
      final cameraNotifier = ref.read(cameraStateProvider.notifier);
      await cameraNotifier.analyzePlant();

      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => ResultsPage())
        );
      }
    } catch (e) {
      // Show an error message to the user
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
                                await _processImageAndNavigate();
                              },
                            ),
                            FloatingActionButton(
                              backgroundColor: Colors.white,
                              child: Icon(Icons.camera_alt, color: Colors.black),
                              onPressed: () async {
                                await ref.read(cameraStateProvider.notifier).takePicture();
                                await _processImageAndNavigate();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                              onPressed: () {
                                ref.read(cameraStateProvider.notifier).flipCamera();
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