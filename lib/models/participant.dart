import 'dart:developer';

class Participant {
  String id;
  String name;
  String email;
  String phone;
  String regno;
  bool rsvp;
  bool present;
  bool confirmed;

  Participant(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.regno,
      required this.confirmed,
      required this.present,
      required this.rsvp});

  factory Participant.fromJson({required Map<String, dynamic> json}) {
    log(json.toString(), name: "Participant Model");
    return Participant(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["contact"],
        regno: json["regno"],
        confirmed: json["confirmed"],
        present: json["present"],
        rsvp: json["rsvp"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "email": this.email,
      "contact": this.phone,
      "regno": this.regno,
      "rsvp": this.rsvp,
      "present": this.present,
      "confirmed": this.confirmed
    };
  }
}
