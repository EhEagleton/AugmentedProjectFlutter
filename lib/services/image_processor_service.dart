import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessorService {
  final String imagePath;

  ImageProcessorService(this.imagePath);

  // Helper functions for color channel extraction from Pixel objects
  static int _redFromPixel(img.Pixel pixel) => pixel.r.toInt();
  static int _greenFromPixel(img.Pixel pixel) => pixel.g.toInt();
  static int _blueFromPixel(img.Pixel pixel) => pixel.b.toInt();
  static int _alphaFromPixel(img.Pixel pixel) => pixel.a.toInt();

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
          final r = (_redFromPixel(pixel) * factor).clamp(0, 255).toInt();
          final g = (_greenFromPixel(pixel) * factor).clamp(0, 255).toInt();
          final b = (_blueFromPixel(pixel) * factor).clamp(0, 255).toInt();
          final a = _alphaFromPixel(pixel);
          image.setPixelRgba(x, y, r, g, b, a);
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
          final r = ((_redFromPixel(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final g = ((_greenFromPixel(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final b = ((_blueFromPixel(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
          final a = _alphaFromPixel(pixel);
          image.setPixelRgba(x, y, r, g, b, a);
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

      image = img.adjustColor(image, saturation: saturation);

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
        final r = _redFromPixel(pixel);
        final g = _greenFromPixel(pixel);
        final b = _blueFromPixel(pixel);

        final tr = (0.393 * r + 0.769 * g + 0.189 * b).clamp(0, 255).toInt();
        final tg = (0.349 * r + 0.686 * g + 0.168 * b).clamp(0, 255).toInt();
        final tb = (0.272 * r + 0.534 * g + 0.131 * b).clamp(0, 255).toInt();

        image.setPixelRgba(x, y, tr, tg, tb, _alphaFromPixel(pixel));
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
