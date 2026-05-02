import 'dart:async';
import 'package:flutter/material.dart';

class StatusBanner extends StatefulWidget {
  final List<String> alerts;
  final bool hasCritical;

  const StatusBanner({
    super.key,
    required this.alerts,
    this.hasCritical = false,
  });

  @override
  State<StatusBanner> createState() => _StatusBannerState();
}

class _StatusBannerState extends State<StatusBanner> {
  bool _isDismissed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoDismiss();
  }

  @override
  void didUpdateWidget(StatusBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If alerts changed, un-dismiss and restart timer
    if (widget.alerts.join() != oldWidget.alerts.join()) {
      setState(() {
        _isDismissed = false;
      });
      _startAutoDismiss();
    }
  }

  void _startAutoDismiss() {
    _timer?.cancel();
    if (widget.alerts.isNotEmpty && !_isDismissed) {
      _timer = Timer(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _isDismissed = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alerts.isEmpty || _isDismissed) {
      return const SizedBox.shrink();
    }

    final color = widget.hasCritical ? const Color(0xFFEF4444) : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.only(left: 16, right: 8, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.hasCritical ? Icons.error_outline : Icons.warning_amber_rounded,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.alerts
                  .map((a) => Text(
                        '• $a',
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ))
                  .toList(),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isDismissed = true;
              });
            },
            icon: Icon(Icons.close, color: color, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
