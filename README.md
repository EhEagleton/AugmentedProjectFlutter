# Image Processor - Advanced Image Processing Flutter App

A feature-rich Flutter application that leverages the `advanced_image_processing_toolkit` package to provide powerful image editing capabilities.

## Features

### 🎨 Image Filters
- **Grayscale** - Convert images to black and white
- **Sepia** - Apply classic sepia tone effect
- **Blur** - Gaussian blur for soft focus
- **Edge Detection** - Sobel edge detection algorithm

### 🔧 Image Adjustments
- **Brightness** - Adjust image brightness (-1.0 to 1.0)
- **Contrast** - Control image contrast (0.5 to 2.0)
- **Saturation** - Modify color saturation (0.0 to 2.0)

### 📸 Image Input
- Pick images from device gallery
- Capture photos directly from camera

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart     # Home page with image picker
│   └── image_editor_screen.dart  # Image editing interface
├── models/
│   └── processing_state.dart # Image processing state model
├── widgets/
│   └── adjustment_slider.dart # Custom slider widget
└── services/
    └── image_processor_service.dart # Image processing logic

pubspec.yaml                 # Project dependencies
```

## Dependencies

- **flutter**: Flutter SDK
- **advanced_image_processing_toolkit**: ^0.1.6 - Advanced image processing features
- **image_picker**: ^1.0.5 - Pick images from gallery or camera
- **image**: ^4.1.3 - Image manipulation library

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart (>=3.0.0)

### Installation

1. **Get dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

## Usage

1. **Launch the app** - Home screen with image picker options
2. **Select an image** - Choose from gallery or take a photo
3. **Edit** - Apply filters and adjustments in real-time
4. **Preview** - See results instantly
5. **Save** - Export your edited image

## Image Processing Algorithms

### Filters
- **Grayscale**: RGB to grayscale conversion
- **Sepia**: Sepia tone matrix transformation
- **Blur**: Gaussian blur with radius 5
- **Edge Detection**: Sobel operator

### Adjustments
- **Brightness**: Linear RGB adjustment (-1.0 to 1.0)
- **Contrast**: Midpoint adjustment (0.5 to 2.0)
- **Saturation**: Color intensity modification (0.0 to 2.0)

## References

- [Advanced Image Processing Toolkit](https://pub.dev/packages/advanced_image_processing_toolkit)
- [Flutter Official Documentation](https://flutter.dev/docs)

---

**Built with ❤️ using Flutter and advanced image processing techniques** 
