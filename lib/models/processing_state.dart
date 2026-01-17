import 'dart:typed_data';

class ProcessingState {
  Uint8List? originalImage;
  Uint8List? processedImage;
  String currentFilter = '';
  double brightness = 0;
  double contrast = 1;
  double saturation = 1;
}
