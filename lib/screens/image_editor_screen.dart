import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/processing_state.dart';
import '../widgets/adjustment_slider.dart';
import '../widgets/error_dialog.dart';
import '../services/image_processor_service.dart';
import '../services/log_service.dart';

class ImageEditorScreen extends StatefulWidget {
  final Uint8List imageData;

  const ImageEditorScreen({Key? key, required this.imageData}) : super(key: key);

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  late ImageProcessorService _processorService;
  ProcessingState _state = ProcessingState();
  bool _isProcessing = false;
  final LogService _log = LogService();

  @override
  void initState() {
    super.initState();
    _log.info('ImageEditorScreen initialized');
    _processorService = ImageProcessorService('');
    _loadOriginalImage();
  }

  void _loadOriginalImage() async {
    _log.info('Loading original image: ${widget.imageData.length} bytes');
    _state.originalImage = widget.imageData;
    _state.processedImage = _state.originalImage;
    setState(() {});
    _log.info('Image loaded successfully');
  }

  Future<void> _applyFilter(String filterName) async {
    _log.info('Applying filter: $filterName');
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.applyFilter(
        _state.originalImage!,
        filterName,
      );
      setState(() {
        _state.processedImage = processed;
        _state.currentFilter = filterName;
      });
      _log.info('Filter applied successfully: $filterName');
    } catch (e) {
      _log.error('Error applying filter $filterName: $e');
      if (mounted) {
        ErrorDialog.show(context, 'Error Applying Filter', e.toString());
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _adjustBrightness(double value) async {
    _log.debug('Adjusting brightness: $value');
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustBrightness(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      _log.error('Error adjusting brightness: $e');
      if (mounted) {
        ErrorDialog.show(context, 'Error Adjusting Brightness', e.toString());
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _adjustContrast(double value) async {
    _log.debug('Adjusting contrast: $value');
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustContrast(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      _log.error('Error adjusting contrast: $e');
      if (mounted) {
        ErrorDialog.show(context, 'Error Adjusting Contrast', e.toString());
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _applySaturation(double value) async {
    _log.debug('Adjusting saturation: $value');
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustSaturation(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      _log.error('Error adjusting saturation: $e');
      if (mounted) {
        ErrorDialog.show(context, 'Error Adjusting Saturation', e.toString());
      }
    }
    setState(() => _isProcessing = false);
  }

  void _reset() {
    _log.info('Resetting all adjustments');
    setState(() {
      _state.processedImage = _state.originalImage;
      _state.currentFilter = '';
      _state.brightness = 0;
      _state.contrast = 1;
      _state.saturation = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final isMedium = constraints.maxWidth > 500;

          Widget imageArea = Container(
            color: Colors.black12,
            alignment: Alignment.center,
            child: _state.processedImage != null
                ? InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.memory(
                      _state.processedImage!,
                      fit: BoxFit.contain,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );

          Widget controls = SingleChildScrollView(
            padding: EdgeInsets.all(isMedium ? 20 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: isMedium ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FilterButton(
                          label: 'Grayscale',
                          onPressed: () => _applyFilter('grayscale'),
                          isActive: _state.currentFilter == 'grayscale',
                          isProcessing: _isProcessing,
                        ),
                        _FilterButton(
                          label: 'Sepia',
                          onPressed: () => _applyFilter('sepia'),
                          isActive: _state.currentFilter == 'sepia',
                          isProcessing: _isProcessing,
                        ),
                        _FilterButton(
                          label: 'Blur',
                          onPressed: () => _applyFilter('blur'),
                          isActive: _state.currentFilter == 'blur',
                          isProcessing: _isProcessing,
                        ),
                        _FilterButton(
                          label: 'Edge Detect',
                          onPressed: () => _applyFilter('edge'),
                          isActive: _state.currentFilter == 'edge',
                          isProcessing: _isProcessing,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Adjustments
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adjustments',
                      style: TextStyle(
                        fontSize: isMedium ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AdjustmentSlider(
                      label: 'Brightness',
                      value: _state.brightness,
                      min: -1.0,
                      max: 1.0,
                      onChanged: _adjustBrightness,
                    ),
                    const SizedBox(height: 8),
                    AdjustmentSlider(
                      label: 'Contrast',
                      value: _state.contrast,
                      min: 0.5,
                      max: 2.0,
                      onChanged: _adjustContrast,
                    ),
                    const SizedBox(height: 8),
                    AdjustmentSlider(
                      label: 'Saturation',
                      value: _state.saturation,
                      min: 0.0,
                      max: 2.0,
                      onChanged: _applySaturation,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Action buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMedium ? 24 : 16,
                          vertical: isMedium ? 14 : 12,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Image processing completed!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMedium ? 24 : 16,
                          vertical: isMedium ? 14 : 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: imageArea),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450, minWidth: 350),
                  child: controls,
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(flex: isMedium ? 3 : 2, child: imageArea),
              Expanded(flex: isMedium ? 2 : 3, child: controls),
            ],
          );
        },
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isProcessing;

  const _FilterButton({
    required this.label,
    required this.onPressed,
    required this.isActive,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isProcessing ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
        foregroundColor: isActive ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
