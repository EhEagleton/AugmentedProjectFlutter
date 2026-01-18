import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/log_service.dart';

class LogPanel extends StatefulWidget {
  final Widget child;

  const LogPanel({Key? key, required this.child}) : super(key: key);

  @override
  State<LogPanel> createState() => _LogPanelState();
}

class _LogPanelState extends State<LogPanel> {
  final LogService _logService = LogService();
  bool _isExpanded = false;
  double _panelHeight = 200;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _logService.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    _logService.removeListener(_onLogsChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onLogsChanged() {
    setState(() {});
    // Auto-scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'ERROR':
        return Colors.red.shade300;
      case 'WARN':
        return Colors.orange.shade300;
      case 'DEBUG':
        return Colors.grey.shade400;
      default:
        return Colors.green.shade300;
    }
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}.${dt.millisecond.toString().padLeft(3, '0')}';
  }

  void _copyAllLogs() {
    final logsText = _logService.logs.map((log) {
      return '[${_formatTimestamp(log.timestamp)}] [${log.level}] ${log.message}';
    }).join('\n');
    
    Clipboard.setData(ClipboardData(text: logsText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logs copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        // Log panel header (always visible)
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          onVerticalDragUpdate: _isExpanded
              ? (details) {
                  setState(() {
                    _panelHeight = (_panelHeight - details.delta.dy).clamp(100.0, 500.0);
                  });
                }
              : null,
          child: Container(
            color: Colors.grey.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_more : Icons.expand_less,
                  color: Colors.white70,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Logs (${_logService.logs.length})',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (_isExpanded) ...[
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    color: Colors.white70,
                    tooltip: 'Copy all logs',
                    onPressed: _copyAllLogs,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.white70,
                    tooltip: 'Clear logs',
                    onPressed: () => _logService.clear(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Expandable log content
        if (_isExpanded)
          Container(
            height: _panelHeight,
            color: Colors.grey.shade850,
            child: _logService.logs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs yet',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: _logService.logs.length,
                    itemBuilder: (context, index) {
                      final log = _logService.logs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: SelectableText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '[${_formatTimestamp(log.timestamp)}] ',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              TextSpan(
                                text: '[${log.level}] ',
                                style: TextStyle(
                                  color: _getLevelColor(log.level),
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: log.message,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
