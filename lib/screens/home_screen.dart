import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'image_editor_screen.dart';
import '../widgets/error_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (kIsWeb && source == ImageSource.camera) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera not supported on web. Use gallery instead.')),
        );
        return;
      }
      
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        final imageBytes = await image.readAsBytes();
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ImageEditorScreen(imageData: imageBytes),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print('Error picking image: $e');
      ErrorDialog.show(context, 'Error Picking Image', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Processor'),
        centerTitle: true,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final maxContentWidth = isWide ? 600.0 : constraints.maxWidth;
          final iconSize = isWide ? 100.0 : 80.0;
          final titleSize = isWide ? 32.0 : 24.0;
          final subtitleSize = isWide ? 16.0 : 14.0;
          final buttonPaddingH = isWide ? 48.0 : 32.0;
          final buttonPaddingV = isWide ? 20.0 : 16.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 32 : 16,
                  vertical: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isWide ? 40 : 32),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.image,
                        size: iconSize,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Advanced Image Processing',
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Pick an image to apply filters, effects, and adjustments',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('From Gallery'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: buttonPaddingH,
                          vertical: buttonPaddingV,
                        ),
                        textStyle: TextStyle(fontSize: isWide ? 18 : 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
