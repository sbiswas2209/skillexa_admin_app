import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillexa_admin_app/services/participants_service.dart';
import 'package:skillexa_admin_app/views/home_page.dart';
import 'package:skillexa_admin_app/views/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final ParticipantService _participantService = Get.put(ParticipantService());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Obx(() => _participantService.participants.isNotEmpty
            ? const HomePage()
            : const LoadingScreen()));
  }
}
