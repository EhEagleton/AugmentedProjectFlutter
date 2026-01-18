import 'package:flutter/foundation.dart';

class LogEntry {
  final DateTime timestamp;
  final String level;
  final String message;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
  });
}

class LogService extends ChangeNotifier {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final List<LogEntry> _logs = [];
  List<LogEntry> get logs => List.unmodifiable(_logs);

  static const int maxLogs = 500;

  void log(String message, {String level = 'INFO'}) {
    _logs.add(LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
    ));
    
    // Keep only last maxLogs entries
    if (_logs.length > maxLogs) {
      _logs.removeAt(0);
    }
    
    // Also print to console
    if (kDebugMode) {
      print('[$level] $message');
    }
    
    notifyListeners();
  }

  void info(String message) => log(message, level: 'INFO');
  void warn(String message) => log(message, level: 'WARN');
  void error(String message) => log(message, level: 'ERROR');
  void debug(String message) => log(message, level: 'DEBUG');

  void clear() {
    _logs.clear();
    notifyListeners();
  }
}
