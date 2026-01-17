import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageProcessorService {
  final String imagePath;

  ImageProcessorService(this.imagePath);

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
      for (int i = 0; i < image.length; i++) {
        final pixel = image[i];
        final r = (img.getRed(pixel) * factor).clamp(0, 255).toInt();
        final g = (img.getGreen(pixel) * factor).clamp(0, 255).toInt();
        final b = (img.getBlue(pixel) * factor).clamp(0, 255).toInt();
        final a = img.getAlpha(pixel);
        image[i] = img.getColor(r, g, b, a);
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
      for (int i = 0; i < image.length; i++) {
        final pixel = image[i];
        final r = ((img.getRed(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
        final g = ((img.getGreen(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
        final b = ((img.getBlue(pixel) - 128) * factor + 128).clamp(0, 255).toInt();
        final a = img.getAlpha(pixel);
        image[i] = img.getColor(r, g, b, a);
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

      for (int i = 0; i < image.length; i++) {
        final pixel = image[i];
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);
        final a = img.getAlpha(pixel);

        // Convert to HSL
        final max = [r, g, b].reduce((a, b) => a > b ? a : b);
        final min = [r, g, b].reduce((a, b) => a < b ? a : b);
        final delta = max - min;

        // Apply saturation
        r = (r * saturation).clamp(0, 255).toInt();
        g = (g * saturation).clamp(0, 255).toInt();
        b = (b * saturation).clamp(0, 255).toInt();

        image[i] = img.getColor(r, g, b, a);
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
    for (int i = 0; i < image.length; i++) {
      final pixel = image[i];
      final r = img.getRed(pixel);
      final g = img.getGreen(pixel);
      final b = img.getBlue(pixel);

      final tr = (0.393 * r + 0.769 * g + 0.189 * b).clamp(0, 255).toInt();
      final tg = (0.349 * r + 0.686 * g + 0.168 * b).clamp(0, 255).toInt();
      final tb = (0.272 * r + 0.534 * g + 0.131 * b).clamp(0, 255).toInt();

      image[i] = img.getColor(tr, tg, tb, img.getAlpha(pixel));
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
