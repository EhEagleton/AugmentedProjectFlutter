class AppConstants {
  // Filter names
  static const String filterGrayscale = 'grayscale';
  static const String filterSepia = 'sepia';
  static const String filterBlur = 'blur';
  static const String filterEdge = 'edge';

  // Adjustment ranges
  static const double brightnessMin = -1.0;
  static const double brightnessMax = 1.0;
  static const double brightnessDefault = 0.0;

  static const double contrastMin = 0.5;
  static const double contrastMax = 2.0;
  static const double contrastDefault = 1.0;

  static const double saturationMin = 0.0;
  static const double saturationMax = 2.0;
  static const double saturationDefault = 1.0;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  
  // Processing
  static const int blurRadius = 5;
}
