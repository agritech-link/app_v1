import 'package:AgriTech_Link/providers/plant_analysis_service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraState {
  final CameraController? controller;
  final bool isAnalyzing;
  final String? condition;
  final Map<String, List<String>>? recommendations;
  final File? imageFile;

  CameraState({
    this.controller,
    this.isAnalyzing = false,
    this.condition,
    this.recommendations,
    this.imageFile,
  });

  CameraState copyWith({
    CameraController? controller,
    bool? isAnalyzing,
    String? condition,
    Map<String, List<String>>? recommendations,
    File? imageFile,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      condition: condition ?? this.condition,
      recommendations: recommendations ?? this.recommendations,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}

class CameraStateNotifier extends StateNotifier<CameraState> {
  CameraStateNotifier(this.ref) : super(CameraState());

  final Ref ref;
  final ImagePicker _picker = ImagePicker();
  List<CameraDescription> cameras = [];

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller.initialize();
    state = state.copyWith(controller: controller);
  }

  Future<void> flipCamera() async {
    if (cameras.length < 2) return;

    final lensDirection = state.controller!.description.lensDirection;
    CameraDescription newCamera;
    if (lensDirection == CameraLensDirection.back) {
      newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } else {
      newCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      );
    }
    
    final controller = CameraController(newCamera, ResolutionPreset.medium);
    await controller.initialize();
    state = state.copyWith(controller: controller);
  }

  Future<void> takePicture() async {
    if (state.controller == null) return;

    try {
      final image = await state.controller!.takePicture();
      state = state.copyWith(imageFile: File(image.path));

      await analyzePlant();
    } catch (e) {
      // Handle error (e.g., show a snackbar)
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = state.copyWith(imageFile: File(pickedFile.path));

      await analyzePlant();
    }
  }
  Future<void> analyzePlant() async {
    if (state.imageFile == null) return;

    try {
      state = state.copyWith(isAnalyzing: true);

      // Analyze the plant by calling the service
      final results = await ref.read(plantAnalysisServiceProvider).analyzePlant(state.imageFile!);

      // Extract the condition and recommendations from the results
      String condition = results['condition'];
      Map<String, List<String>> recommendations = Map<String, List<String>>.from(results['recommendations']);

      // Update the state with the condition and recommendations
      state = state.copyWith(
        isAnalyzing: false,
        condition: condition,
        recommendations: recommendations,
      );
    } catch (e) {
      state = state.copyWith(isAnalyzing: false);
      // Handle the error (e.g., show a snackbar or log it)
      print("Error analyzing plant: $e");
    }
  }


  void resetState() {
    state = CameraState(controller: state.controller);
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