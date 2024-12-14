import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/incoming_call_screen.dart';
 

class CallHandler {
  static const platform = MethodChannel('com.example.call_r/call_handler');
  final BuildContext context;

  CallHandler(this.context);

  Future<void> initialize() async {
    await requestPermissions();
    platform.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onIncomingCall':
        final String phoneNumber = call.arguments['phoneNumber'];
        await showIncomingCallScreen(phoneNumber);
        break;
    }
  }

  Future<void> showIncomingCallScreen(String phoneNumber) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return IncomingCallScreen(
          phoneNumber: phoneNumber,
          onAccept: () async {
            Navigator.of(context).pop();
            await acceptCall();
          },
          onDecline: () async {
            Navigator.of(context).pop();
            await declineCall();
          },
        );
      },
    );
  }

  Future<void> acceptCall() async {
    try {
      final bool success = await platform.invokeMethod('acceptCall');
      if (success) {
        print('Call accepted successfully');
      } else {
        print('Failed to accept call');
      }
    } on PlatformException catch (e) {
      print('Error accepting call: ${e.message}');
    }
  }

  Future<void> declineCall() async {
    try {
      final bool success = await platform.invokeMethod('declineCall');
      if (success) {
        print('Call declined successfully');
      } else {
        print('Failed to decline call');
      }
    } on PlatformException catch (e) {
      print('Error declining call: ${e.message}');
    }
  }

  Future<void> requestPermissions() async {
    await Permission.phone.request();
    if (await Permission.phone.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
