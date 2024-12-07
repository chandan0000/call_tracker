 
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:call_log/call_log.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/services.dart';

class CallLogPermission {
  static const MethodChannel _channel = MethodChannel('call_log_permission');

  static Future<bool> requestCallLogPermission() async {
    final bool granted = await _channel.invokeMethod('requestCallLogPermission');
    return granted;
  }
}


class PhoneService {
  static Future<void> requestPermissions() async {
    await Permission.phone.request();
    await Permission.contacts.request();
    await CallLogPermission.requestCallLogPermission();
    // await Permission.callLog.request();
  }

  static Future<void> makeCall(String phoneNumber) async {
    await FlutterPhoneDirectCaller.callNumber(phoneNumber);
  }

  // static Future<List<CallLogEntry>> getCallLogs() async {
  //   if (await CallLogPermission.requestCallLogPermission()) {
  //     // return await CallLog.get();
  //     return [];
  //   }
  //   return [];
  // }

  // static Future<List<Contact>> getContacts() async {
  //   if (await Permission.contacts.isGranted) {
  //     return await ContactsService.getContacts();
  //   }
  //   return [];
  // }

  static Future<void> setupPhoneListener(Function(PhoneState) onPhoneStateChanged) async {
    // PhoneState.phoneStateStream.listen(onPhoneStateChanged);
    PhoneState.stream.listen(onPhoneStateChanged);
    
  }
}