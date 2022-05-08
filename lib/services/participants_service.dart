import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart';
import 'package:skillexa_admin_app/models/participant.dart';

class ParticipantService extends GetxController {
  @override
  void onInit() {
    getAllParticipants();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<Participant> participants = RxList.empty(growable: true);
  RxBool isLoading = false.obs;
  Future<void> getAllParticipants() async {
    await FirebaseAuth.instance.signInAnonymously();
    Response response = await get(Uri.https(
        "alexa-prosperity.herokuapp.com", "/api/participants/skillexa"));
    participants.addAll((jsonDecode(response.body) as List<dynamic>)
        .map((e) => Participant.fromJson(json: e)));
    participants.refresh();
  }

  Future<Map<String, dynamic>> admitParticipant(
      {required String email, required Map<String, dynamic> data}) async {
    try {
      isLoading(true);
      log("/api/attendance/skillexa?email=$email", name: "Email");
      if ((await _firestore
              .collection("participants")
              .where("email", isEqualTo: email)
              .get())
          .docs
          .isNotEmpty) {
        isLoading(false);
        return {"message": "Already Checked In", "result": false};
      }
      Response response = await get(
          Uri.parse(
              "https://alexa-prosperity.herokuapp.com/api/attendance/skillexa?email=$email"),
          headers: {"event": "skillexa"});
      log(response.body.toString(), name: "Response");
      if (response.statusCode == 200) {
        data["foodCollected"] = false;
        _firestore.collection("participants").doc("${data["id"]}").set(data);
        isLoading(false);
        return {"message": "", "result": true};
      } else {
        isLoading(false);
        return {"message": "Unexpected Error", "result": false};
      }
    } catch (e) {
      return {"message": "Unexpected Error", "result": false};
    }
  }

  Future<Map<String, dynamic>> collectFood({required String id}) async {
    try {
      if (!(await _firestore.collection("participants").doc(id).get()).exists) {
        return {"message": "Check In not done", "result": false};
      }
      isLoading(true);
      Map<String, dynamic>? data =
          (await _firestore.collection("participants").doc(id).get()).data();
      if (data!["foodCollected"] == true) {
        isLoading(false);
        return {"message": "Already Collected", "result": false};
      } else {
        isLoading(false);
        await _firestore
            .collection("participants")
            .doc(id)
            .update({"foodCollected": true});
        return {"message": "Success !", "result": true};
      }
    } catch (e) {
      return {"message": "Unexpected Error", "result": false};
    }
  }
}
