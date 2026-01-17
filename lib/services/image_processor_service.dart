import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessorService {
  final String imagePath;

  ImageProcessorService(this.imagePath);

  // Helper functions for color channel extraction (works with newer package:image)
  static int _redFromColor(int c) => (c >> 16) & 0xFF;
  static int _greenFromColor(int c) => (c >> 8) & 0xFF;
  static int _blueFromColor(int c) => c & 0xFF;
  static int _alphaFromColor(int c) => (c >> 24) & 0xFF;
  static int _makeColor(int r, int g, int b, int a) =>
      ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);

  Future<Uint8List> applyFilter(Uint8List imageData, String filterType) async {
    try {
      img.Image? image = img.decodeImage(imageData);
      if (image == null) return imageData;

      switch (filterType.toLowerCase()) {
        case 'grayscale':
          image = _applyGrayscale(image);
          break;
        case 'sepia':
          image = _applySepia(image);
          break;
        case 'blur':
          image = _applyBlur(image);
          break;
        case 'edge':
          image = _applyEdgeDetection(image);
          break;
        default:
          return imageData;
      }

      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      print('Error applying filter: $e');
      return imageData;
    }
  }

  Future<Uint8List> adjustBrightness(Uint8List imageData, double brightness) async {
    try {
      img.Image? image = img.decodeImage(imageData);
      if (image == null) return imageData;

      // Brightness adjustment (range: -1.0 to 1.0)
      final factor = 1 + brightness;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixelSafe(x, y);
          final r = (_redFromColor(pixel) * factor).clamp(0, 255).toInt();
          final g = (_greenFromColor(pixel) * factor).clamp(0, 255).toInt();
          final b = (_blueFromColor(pixel) * factor).clamp(0, 255).toInt();
          final a = _alphaFromColor(pixel);
          image.setPixelSafe(x, y, _makeColor(r, g, b, a));
        }
      }

      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      print('Error adjusting brightness: $e');
      return imageData;
    }
  }

  Future<Uint8List> adjustContrast(Uint8List imageData, double contrast) async {
    try {
      img.Image? image = img.decodeImage(imageData);
      if (image == null) return imageData;

      // Contrast adjustment (range: 0.5 to 2.0)
      final factor = contrast;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixelSafe(x, y);
          final r = ((_redFromColor(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final g = ((_greenFromColor(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final b = ((_blueFromColor(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final a = _alphaFromColor(pixel);
          image.setPixelSafe(x, y, _makeColor(r, g, b, a));
        }
      }

      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      print('Error adjusting contrast: $e');
      return imageData;
    }
  }

  Future<Uint8List> adjustSaturation(Uint8List imageData, double saturation) async {
    try {
      img.Image? image = img.decodeImage(imageData);
      if (image == null) return imageData;

      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = image.getPixelSafe(x, y);
          int r = _redFromColor(pixel);
          int g = _greenFromColor(pixel);
          int b = _blueFromColor(pixel);
          final a = _alphaFromColor(pixel);

          // Convert to HSL
          final max = [r, g, b].reduce((a, b) => a > b ? a : b);
          final min = [r, g, b].reduce((a, b) => a < b ? a : b);
          final delta = max - min;

          // Apply saturation
          r = (r * saturation).clamp(0, 255).toInt();
          g = (g * saturation).clamp(0, 255).toInt();
          b = (b * saturation).clamp(0, 255).toInt();

          image.setPixelSafe(x, y, _makeColor(r, g, b, a));
        }
      }

      return Uint8List.fromList(img.encodeJpg(image));
    } catch (e) {
      print('Error adjusting saturation: $e');
      return imageData;
    }
  }

  img.Image _applyGrayscale(img.Image image) {
    return img.grayscale(image);
  }

  img.Image _applySepia(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixelSafe(x, y);
        final r = _redFromColor(pixel);
        final g = _greenFromColor(pixel);
        final b = _blueFromColor(pixel);

        final tr = (0.393 * r + 0.769 * g + 0.189 * b).clamp(0, 255).toInt();
        final tg = (0.349 * r + 0.686 * g + 0.168 * b).clamp(0, 255).toInt();
        final tb = (0.272 * r + 0.534 * g + 0.131 * b).clamp(0, 255).toInt();

        image.setPixelSafe(x, y, _makeColor(tr, tg, tb, _alphaFromColor(pixel)));
      }
    }
    return image;
  }

  img.Image _applyBlur(img.Image image) {
    return img.gaussianBlur(image, radius: 5);
  }

  img.Image _applyEdgeDetection(img.Image image) {
    return img.sobel(image);
  }
}
