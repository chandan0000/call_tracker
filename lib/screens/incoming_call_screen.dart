import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/call_service.dart';
 
class IncomingCallScreen extends StatelessWidget {
  final String phoneNumber;

  const IncomingCallScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.person, size: 100),
                  const SizedBox(height: 20),
                  Text(
                    phoneNumber,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const Text('Incoming Call...'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      context.read<CallService>().endCall();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.call_end),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      context.read<CallService>().answerCall();
                      // Handle answering call
                    },
                    child: const Icon(Icons.call),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
