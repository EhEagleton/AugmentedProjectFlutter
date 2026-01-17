# Image Processor - Project Documentation

## Overview

**Image Processor** is a comprehensive Flutter application built to demonstrate the capabilities of the `advanced_image_processing_toolkit` package. The app provides an intuitive interface for applying various image filters and adjustments to images captured from the device camera or selected from the gallery.

## Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **Image Processing**: 
  - `advanced_image_processing_toolkit` - Primary toolkit
  - `image` - Image manipulation and encoding/decoding
- **UI/UX**:
  - Material Design 3
  - Custom widgets and layouts
- **Dependencies Management**: Pub (pub.dev)

## Architecture

### Layered Architecture

```
┌─────────────────────────────────────┐
│        UI Layer (Screens)           │
│  - HomeScreen                       │
│  - ImageEditorScreen                │
├─────────────────────────────────────┤
│        Widget Layer                 │
│  - AdjustmentSlider                 │
│  - Filter Buttons                   │
├─────────────────────────────────────┤
│        Service Layer                │
│  - ImageProcessorService            │
├─────────────────────────────────────┤
│        Model Layer                  │
│  - ProcessingState                  │
├─────────────────────────────────────┤
│        External Libraries           │
│  - advanced_image_processing_toolkit│
│  - image                            │
│  - image_picker                     │
└─────────────────────────────────────┘
```

## File Structure

```
AugmentedProjectFlutter/
├── lib/
│   ├── main.dart                          # Application entry point
│   ├── constants/
│   │   └── app_constants.dart            # App-wide constants
│   ├── models/
│   │   └── processing_state.dart         # Image processing state
│   ├── services/
│   │   └── image_processor_service.dart  # Processing logic
│   ├── screens/
│   │   ├── home_screen.dart             # Home page
│   │   └── image_editor_screen.dart     # Editor interface
│   └── widgets/
│       └── adjustment_slider.dart        # Custom slider widget
├── android/                               # Android native code
├── ios/                                   # iOS native code
├── pubspec.yaml                          # Project manifest
├── README.md                              # Project readme
└── LICENSE                                # License file
```

## Component Details

### 1. HomeScreen (`lib/screens/home_screen.dart`)
**Purpose**: Main entry point of the application

**Features**:
- Image picker integration
- Camera and gallery options
- Navigation to editor screen

**Key Methods**:
- `_pickImage(ImageSource source)` - Picks image from camera or gallery

### 2. ImageEditorScreen (`lib/screens/image_editor_screen.dart`)
**Purpose**: Main editing interface

**Features**:
- Real-time image preview
- Filter application
- Adjustment sliders
- Reset and save functionality

**Key Methods**:
- `_applyFilter(String filterName)` - Applies selected filter
- `_adjustBrightness(double value)` - Adjusts brightness
- `_adjustContrast(double value)` - Adjusts contrast
- `_applySaturation(double value)` - Adjusts saturation
- `_reset()` - Resets to original image

### 3. ImageProcessorService (`lib/services/image_processor_service.dart`)
**Purpose**: Centralized image processing logic

**Filter Methods**:
- `_applyGrayscale(Image image)` - Converts to grayscale
- `_applySepia(Image image)` - Applies sepia effect
- `_applyBlur(Image image)` - Applies Gaussian blur
- `_applyEdgeDetection(Image image)` - Sobel edge detection

**Adjustment Methods**:
- `adjustBrightness(Uint8List imageData, double brightness)` - Brightness adjustment
- `adjustContrast(Uint8List imageData, double contrast)` - Contrast adjustment
- `adjustSaturation(Uint8List imageData, double saturation)` - Saturation adjustment

### 4. ProcessingState (`lib/models/processing_state.dart`)
**Purpose**: Maintains image editing state

**Properties**:
- `originalImage` - Original image bytes
- `processedImage` - Currently edited image bytes
- `currentFilter` - Name of active filter
- `brightness`, `contrast`, `saturation` - Adjustment values

### 5. AdjustmentSlider (`lib/widgets/adjustment_slider.dart`)
**Purpose**: Reusable slider widget for adjustments

**Features**:
- Customizable min/max range
- Value display
- Smooth slider interaction

## Data Flow

```
User Interaction
        ↓
ImageEditorScreen (UI)
        ↓
ImageProcessorService (Processing)
        ↓
Image Library & advanced_image_processing_toolkit
        ↓
Processed Image Bytes
        ↓
ProcessingState (Model)
        ↓
Display in UI
```

## Image Processing Algorithms

### Filter Processing

1. **Grayscale**: Uses standard luminance formula (0.299R + 0.587G + 0.114B)
2. **Sepia**: Applies color transformation matrix
3. **Blur**: Gaussian blur with configurable radius
4. **Edge Detection**: Sobel operator for edge detection

### Adjustment Processing

1. **Brightness**:
   ```
   Result = Original × (1 + brightness_value)
   Range: -1.0 (darker) to 1.0 (brighter)
   ```

2. **Contrast**:
   ```
   Result = (Original - 128) × contrast_factor + 128
   Range: 0.5 (less contrast) to 2.0 (more contrast)
   ```

3. **Saturation**:
   ```
   Modifies color intensity while preserving luminance
   Range: 0.0 (grayscale) to 2.0 (highly saturated)
   ```

## Dependencies Overview

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Image Processing
  advanced_image_processing_toolkit: ^0.1.6
  image: ^4.1.3
  
  # Image Selection
  image_picker: ^1.0.5
  
  # State Management (Optional)
  provider: ^6.0.0
  
  # UI
  cupertino_icons: ^1.0.2
```

### Development Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## Setup and Installation

### Prerequisites

- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: >= 3.0.0
- **Development Environment**: Android Studio, Xcode, or VS Code with Flutter extension

### Installation Steps

1. **Get Dependencies**
   ```bash
   flutter pub get
   ```

2. **Generate Required Files** (if needed)
   ```bash
   flutter pub get && flutter pub upgrade
   ```

3. **Run on Device/Emulator**
   ```bash
   flutter run
   ```

4. **Build for Release**
   ```bash
   # Android
   flutter build apk
   
   # iOS
   flutter build ios
   ```

## Usage Workflow

1. **Launch Application**
   - App opens with HomeScreen
   - Two options: Gallery or Camera

2. **Select Image**
   - Navigate to ImageEditorScreen
   - Image loads and displays

3. **Apply Filters**
   - Click filter buttons (Grayscale, Sepia, Blur, Edge)
   - Real-time preview updates

4. **Adjust Parameters**
   - Use sliders to adjust Brightness, Contrast, Saturation
   - Changes apply immediately

5. **Save/Reset**
   - Save processed image
   - Reset to original anytime

## Performance Considerations

- **Asynchronous Processing**: All image operations run asynchronously
- **Memory Management**: Images processed efficiently to minimize memory usage
- **UI Responsiveness**: Processing doesn't block UI thread
- **Caching**: Original image retained for quick reset

## Error Handling

- **Permission Errors**: Handled gracefully with user feedback
- **Processing Errors**: Try-catch blocks with error messages
- **File Errors**: Proper validation before processing

## Future Enhancements

1. **Advanced Filters**
   - Posterize, Invert, Solarize
   - Custom filter creation
   - Filter presets/favorites

2. **Advanced Features**
   - Undo/Redo history
   - Batch processing
   - Image cropping/rotation
   - Collage creation

3. **Export Options**
   - Multiple format support (PNG, WebP, etc.)
   - Quality settings
   - Social media sharing

4. **Performance**
   - Multi-threading optimization
   - GPU acceleration for filters
   - Progressive image loading

5. **UI/UX**
   - Before/after comparison view
   - Touch-based adjustments
   - Gesture support
   - Dark mode support

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Image picker not responding | Check camera/gallery permissions |
| Filter not applying | Verify image format is supported |
| Performance lag | Reduce image resolution before editing |
| Build errors | Run `flutter pub get` and clear build |

### Debug Tips

1. **Enable Flutter Logging**
   ```bash
   flutter run -v
   ```

2. **Check Console Output**
   - Watch for error messages in logcat/console
   - Use `print()` statements for debugging

3. **Test on Device**
   - Emulator performance differs from real devices
   - Test with various image sizes

## Contributing Guidelines

1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

## License

This project is distributed under the MIT License. See LICENSE file for details.

## References and Resources

- [Advanced Image Processing Toolkit](https://pub.dev/packages/advanced_image_processing_toolkit)
- [Flutter Official Documentation](https://flutter.dev/docs)
- [Dart Official Documentation](https://dart.dev/guides)
- [Image Package Documentation](https://pub.dev/packages/image)
- [Image Picker Documentation](https://pub.dev/packages/image_picker)

## Contact and Support

For issues, suggestions, or improvements:
- Open an issue in the repository
- Review existing issues before creating new ones

---

**Last Updated**: January 2026
**Version**: 1.0.0
**Status**: Production Ready
