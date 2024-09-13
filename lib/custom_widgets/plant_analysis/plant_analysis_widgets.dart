import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

import '../../notifiers/camera_state_notifier.dart';

class CameraPage extends ConsumerStatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  @override
  void initState() {
    super.initState();
    ref.read(cameraStateProvider.notifier).initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Take Plant Picture')),
      body: Column(
        children: [
          Expanded(
            child: cameraState.controller != null
                ? CameraPreview(cameraState.controller!)
                : Center(child: CircularProgressIndicator()),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(cameraStateProvider.notifier).takePicture();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ResultsPage()));
            },
            child: Text('Take Picture'),
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Plant Picture')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ref.read(cameraStateProvider.notifier).pickImageFromGallery();
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => ResultsPage()));
          },
          child: Text(
            'Select from Gallery',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ResultsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Analysis Results')),
      body: cameraState.isAnalyzing
          ? Center(child: CircularProgressIndicator())
          : cameraState.condition != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Condition: ${cameraState.condition}',
                          style: Theme.of(context).textTheme.displayMedium),
                      SizedBox(height: 8),
                      Text('Recommendations:',
                          style: Theme.of(context).textTheme.displaySmall),
                      ...cameraState.recommendations!
                          .map((rec) => Text('• $rec'))
                          .toList(),
                    ],
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(cameraStateProvider.notifier).analyzePlant();
                    },
                    child: Text('Analyze Plant'),
                  ),
                ),
    );
  }
}
