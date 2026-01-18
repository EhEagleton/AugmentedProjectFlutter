import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'widgets/log_panel.dart';
import 'services/log_service.dart';

void main() {
  final logService = LogService();
  
  // Enable error logging for web
  FlutterError.onError = (FlutterErrorDetails details) {
    logService.error('Flutter Error: ${details.exception}');
    if (details.stack != null) {
      logService.debug('Stack: ${details.stack.toString().split('\n').take(5).join('\n')}');
    }
  };
  
  logService.info('App starting...');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Processor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      builder: (context, child) {
        // Only show log panel on web in debug mode
        if (kIsWeb) {
          return LogPanel(child: child ?? const SizedBox.shrink());
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
