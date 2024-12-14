// import 'package:contacts_service/contacts_service.dart';
import 'package:direct_call_plus/direct_call_plus.dart';
import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';
import 'package:provider/provider.dart';

import '../service/call_service.dart';
import '../service/phone_service.dart';
import 'outgoing_call_screen.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({Key? key}) : super(key: key);

  @override
  _DialerScreenState createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  final TextEditingController _numberController = TextEditingController();
  // List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _setupPhoneState();
  }

  Future<void> _loadContacts() async {
    // final contacts = await PhoneService.getContacts();
    // setState(() {
    //   _contacts = contacts;
    // });
  }

  void _setupPhoneState() {
    PhoneService.setupPhoneListener((phoneState) {
      // Handle phone state changes
      switch (phoneState) {
        // case PhoneState.CALL_STARTED:
        //   // Handle call started
        //   break;
        // case PhoneState.CALL_ENDED:
        //   // Handle call ended
        //   break;
        // case PhoneState.CALL_INCOMING:
        //   // Handle incoming call
        //   break;
      }
    });
  }

  Future<void> _makeCall(String number) async {
    await PhoneService.makeCall(number);
  }
  Widget _buildDialPad() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      children: [
        for (var i = 1; i <= 9; i++) _buildDialButton(i.toString()),
        _buildDialButton('*'),
        _buildDialButton('0'),
        _buildDialButton('#'),
      ],
    );
  }
 Widget _buildDialButton(String number) {
    return InkWell(
      onTap: () {
        setState(() {
          _numberController.text += number;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _numberController,
              readOnly: true,
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              decoration:  InputDecoration(
                hintText: 'Enter phone number',
                border:InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon:  IconButton(onPressed: () => _numberController.clear(), icon: const Icon(Icons.clear)),
              ),
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildDialPad()),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () async{
                if (_numberController.text.isNotEmpty) {
                  bool? res = await DirectCallPlus.makeCall(_numberController.text);
                  if(res!=null && res){
                    context.read<CallService>().startCall(_numberController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OutgoingCallScreen(
                          phoneNumber: _numberController.text,
                      ),
                    ),
                  );
                  }
                }
              },
              child: const Icon(Icons.call),
            ),
          ],
        ),
      ),
    );
  }
}
