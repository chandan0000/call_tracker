import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/call_service.dart';
 
class OutgoingCallScreen extends StatelessWidget {
  final String phoneNumber;

  const OutgoingCallScreen({
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
                  const Text('Calling...'),
                ],
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  context.read<CallService>().endCall();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.call_end),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
