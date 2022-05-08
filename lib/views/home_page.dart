import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skillexa_admin_app/services/participants_service.dart';
import 'package:skillexa_admin_app/views/scan_page.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ParticipantService _participantService = Get.find<ParticipantService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Skillexa Admin",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () async {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Fetching Data")));
              try {
                await _participantService.getAllParticipants();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Data Fetched"),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Error while fetching data"),
                  backgroundColor: Colors.red,
                ));
              }
            },
          )
        ],
      ),
      body: GridView(
        physics: BouncingScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        children: [
          Card(
            color: Colors.blue[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    Icons.door_front_door,
                    size: 100.0,
                  ),
                  Text("Scan for Entry"),
                ],
              ),
              onTap: () async {
                await Permission.camera.request();
                String? scanResult = await scanner.scan();
                log(scanResult.toString(), name: "QR Result");

                if (scanResult != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScanPage(
                              isEntry: true,
                              email: scanResult
                                  .substring(scanResult.indexOf("=") + 1))));
                }
              },
            ),
          ),
          Card(
            color: Colors.blue[200],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icon(
                    Icons.food_bank_outlined,
                    size: 100,
                  ),
                  Text("Scan for Food"),
                ],
              ),
              onTap: () async {
                await Permission.camera.request();
                String? scanResult = await scanner.scan();
                log(scanResult.toString(), name: "QR Result");

                if (scanResult != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScanPage(
                              isEntry: false,
                              email: scanResult
                                  .substring(scanResult.indexOf("=") + 1))));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
