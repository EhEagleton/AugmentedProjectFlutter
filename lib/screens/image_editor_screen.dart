import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/processing_state.dart';
import '../widgets/adjustment_slider.dart';
import '../services/image_processor_service.dart';

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

  @override
  void initState() {
    super.initState();
    _processorService = ImageProcessorService('');
    _loadOriginalImage();
  }

  void _loadOriginalImage() async {
    _state.originalImage = widget.imageData;
    _state.processedImage = _state.originalImage;
    setState(() {});
  }

  Future<void> _applyFilter(String filterName) async {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error applying filter: $e')),
        );
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _adjustBrightness(double value) async {
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustBrightness(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting brightness: $e')),
        );
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _adjustContrast(double value) async {
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustContrast(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting contrast: $e')),
        );
      }
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _applySaturation(double value) async {
    setState(() => _isProcessing = true);
    try {
      final processed = await _processorService.adjustSaturation(
        _state.originalImage!,
        value,
      );
      setState(() => _state.processedImage = processed);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adjusting saturation: $e')),
        );
      }
    }
    setState(() => _isProcessing = false);
  }

  void _reset() {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _FilterButton(
                              label: 'Grayscale',
                              onPressed: () => _applyFilter('grayscale'),
                              isActive: _state.currentFilter == 'grayscale',
                              isProcessing: _isProcessing,
                            ),
                            const SizedBox(width: 8),
                            _FilterButton(
                              label: 'Sepia',
                              onPressed: () => _applyFilter('sepia'),
                              isActive: _state.currentFilter == 'sepia',
                              isProcessing: _isProcessing,
                            ),
                            const SizedBox(width: 8),
                            _FilterButton(
                              label: 'Blur',
                              onPressed: () => _applyFilter('blur'),
                              isActive: _state.currentFilter == 'blur',
                              isProcessing: _isProcessing,
                            ),
                            const SizedBox(width: 8),
                            _FilterButton(
                              label: 'Edge Detect',
                              onPressed: () => _applyFilter('edge'),
                              isActive: _state.currentFilter == 'edge',
                              isProcessing: _isProcessing,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Adjustments
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adjustments',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: imageArea),
                SizedBox(
                  width: 420,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: controls,
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(flex: 3, child: imageArea),
              Expanded(flex: 2, child: controls),
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
