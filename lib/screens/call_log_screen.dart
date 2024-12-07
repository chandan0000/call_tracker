import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/call_service.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call Log')),
      body: Consumer<CallService>(
        builder: (context, callService, child) {
          return ListView.builder(
            itemCount: callService.callLog.length,
            itemBuilder: (context, index) {
              final call = callService.callLog[index];
              return ListTile(
                leading: Icon(
                  call.isOutgoing ? Icons.call_made : Icons.call_received,
                  color: call.isOutgoing ? Colors.green : Colors.blue,
                ),
                title: Text(call.phoneNumber),
                subtitle: Text(call.timestamp.toString()),
                trailing: Text(call.duration.toString() + 's'),
              );
            },
          );
        },
      ),
    );
  }
}
