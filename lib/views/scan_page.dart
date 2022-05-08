import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:skillexa_admin_app/models/participant.dart';
import 'package:skillexa_admin_app/services/participants_service.dart';
import 'package:slidable_button/slidable_button.dart';

class ScanPage extends StatefulWidget {
  final String email;
  final bool isEntry;
  const ScanPage({Key? key, required this.email, required this.isEntry})
      : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ParticipantService _participantService = Get.find<ParticipantService>();

  String? result;
  @override
  Widget build(BuildContext context) {
    Participant _participant = _participantService.participants
        .where((p0) => p0.email == widget.email)
        .first;
    return Scaffold(
        appBar: AppBar(title: const Text("Scan QR Code")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Name : ${_participant.name}"),
              Text("Email : ${_participant.email}"),
              Text("Phone : ${_participant.phone}"),
              Text("Reg. No. : ${_participant.regno}"),
            ],
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            if (_participantService.isLoading.value) {
              return;
            }
            Map<String, dynamic> result = widget.isEntry
                ? await _participantService.admitParticipant(
                    email: widget.email, data: _participant.toJson())
                : await _participantService.collectFood(id: _participant.id);
            if (result["result"]) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Success !"),
                backgroundColor: Colors.green,
              ));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Error : ${result["message"]}"),
                backgroundColor: Colors.red,
              ));
            }
            Navigator.pop(context);
          },
          child: Obx(() => !_participantService.isLoading.value
              ? Text(widget.isEntry ? "Admit" : "Hand Over")
              : const Text("Loading")),
          style: ElevatedButton.styleFrom(primary: Colors.green),
        ));
  }
}
