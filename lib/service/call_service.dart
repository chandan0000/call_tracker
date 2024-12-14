import 'package:flutter/foundation.dart';

class CallLog {
  final String phoneNumber;
  final DateTime timestamp;
  final int duration;
  final bool isOutgoing;

  CallLog({
    required this.phoneNumber,
    required this.timestamp,
    required this.duration,
    required this.isOutgoing,
  });
}

class CallService extends ChangeNotifier {
  final List<CallLog> _callLog = [];
  bool _isInCall = false;
  String? _currentCallNumber;
  DateTime? _callStartTime;

  List<CallLog> get callLog => List.unmodifiable(_callLog);
  bool get isInCall => _isInCall;
  String? get currentCallNumber => _currentCallNumber;

  void startCall(String phoneNumber) {
    _isInCall = true;
    _currentCallNumber = phoneNumber;
    _callStartTime = DateTime.now();
    
    notifyListeners();
  }

  void answerCall() {
    if (_isInCall && _currentCallNumber != null) {
      _callStartTime = DateTime.now();
      notifyListeners();
    }
  }

  void endCall() {
    if (_isInCall && _currentCallNumber != null && _callStartTime != null) {
      final duration = DateTime.now().difference(_callStartTime!).inSeconds;
      _callLog.insert(
        0,
        CallLog(
          phoneNumber: _currentCallNumber!,
          timestamp: _callStartTime!,
          duration: duration,
          isOutgoing: true,
        ),
      );
      _isInCall = false;
      _currentCallNumber = null;
      _callStartTime = null;
      notifyListeners();
    }
  }
}