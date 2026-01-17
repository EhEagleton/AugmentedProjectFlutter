import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // Enable error logging for web
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Flutter Error: ${details.exception}');
    print('Stack Trace: ${details.stack}');
  };
  
  print('App starting...');
  
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
      // Add error widget for debugging
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
