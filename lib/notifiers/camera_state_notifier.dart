import 'package:AgriTech_Link/providers/plant_analysis_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraState {
  final CameraController? controller;
  final bool isAnalyzing;
  final bool isCameraActive;
  final String? condition;
  final Map<String, List<String>>? recommendations;
  final File? imageFile;
  final int cameraIndex;
  final bool analysisComplete;

  CameraState({
    this.controller,
    this.isAnalyzing = false,
    this.isCameraActive = true,
    this.condition,
    this.recommendations,
    this.imageFile,
    this.cameraIndex = 0,
    this.analysisComplete = false,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isAnalyzing,
    bool? isCameraActive,
    String? condition,
    Map<String, List<String>>? recommendations,
    File? imageFile,
    int? cameraIndex,
    bool? analysisComplete,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      isCameraActive: isCameraActive ?? this.isCameraActive,
      condition: condition ?? this.condition,
      recommendations: recommendations ?? this.recommendations,
      imageFile: imageFile ?? this.imageFile,
      cameraIndex: cameraIndex ?? this.cameraIndex,
      analysisComplete: analysisComplete ?? this.analysisComplete,
    );
  }
}

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(this.ref) : super(CameraState());

  final Ref ref;
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> cameras = [];

  Future<void> initializeCamera() async {
    if (!state.isCameraActive) return;

    cameras = await availableCameras();
    final controller = CameraController(cameras[state.cameraIndex], ResolutionPreset.medium);
    await controller.initialize();
    state = state.copyWith(controller: controller);
  }

  Future<void> flipCamera() async {
    if (cameras.length < 2) return;

    int newIndex = (state.cameraIndex + 1) % cameras.length;
    await state.controller?.dispose();

    final newController = CameraController(cameras[newIndex], ResolutionPreset.medium);
    await newController.initialize();

    state = state.copyWith(
      controller: newController,
      cameraIndex: newIndex,
    );
  }

  Future<void> takePicture() async {
    if (state.controller == null) return;

    try {
      final image = await state.controller!.takePicture();
      state = state.copyWith(imageFile: File(image.path));

      await deactivateCamera();
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(imageFile: File(pickedFile.path));

      await deactivateCamera();
    }
  }

  Future<void> analyzePlant() async {
    if (state.imageFile == null) return;

    try {
      state = state.copyWith(isAnalyzing: true);

      final results = await ref.read(plantAnalysisServiceProvider).analyzePlant(state.imageFile!);

      String condition = results['condition'];
      Map<String, List<String>> recommendations = Map<String, List<String>>.from(results['recommendations']);

      state = state.copyWith(
        isAnalyzing: false,
        condition: condition,
        recommendations: recommendations,
        analysisComplete: true,
      );
    } catch (e) {
      state = state.copyWith(isAnalyzing: false);
      print("Error analyzing plant: $e");
    }
  }

  void resetState() {
    state = CameraState(isCameraActive: true);
    initializeCamera();
  }

  Future<void> deactivateCamera() async {
    await state.controller?.dispose();
    state = state.copyWith(controller: null, isCameraActive: false);
  }

  Future<void> reactivateCamera() async {
    state = state.copyWith(
      isCameraActive: true,
      condition: null,
      recommendations: null,
      imageFile: null,
      analysisComplete: false,
    );
    await initializeCamera();
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final cameraStateProvider = StateNotifierProvider<CameraStateNotifier, CameraState>((ref) {
  return CameraStateNotifier(ref);
});