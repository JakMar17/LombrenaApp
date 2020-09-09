import 'dart:convert';

WarningsNaprava warningsNapravaFromJson(String str) =>
    WarningsNaprava.fromJson(json.decode(str));

String warningsNapravaToJson(WarningsNaprava data) =>
    json.encode(data.toJson());

class WarningsNaprava {
  String fcmId;
  String id;
  String fcmIdOld;
  String osIme;
  String osVerzija;
  String osSdk;
  String appVerzija;
  String napravaProizvajalec;
  String napravaModel;

  WarningsNaprava(
      {this.fcmId,
      this.id,
      this.fcmIdOld,
      this.osIme,
      this.osVerzija,
      this.osSdk,
      this.appVerzija,
      this.napravaProizvajalec,
      this.napravaModel});

  WarningsNaprava.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcmId'];
    id = json['id'];
    fcmIdOld = json['fcmIdOld'];
    osIme = json['osIme'];
    osVerzija = json['osVerzija'];
    osSdk = json['osSdk'];
    appVerzija = json['appVerzija'];
    napravaProizvajalec = json['napravaProizvajalec'];
    napravaModel = json['napravaModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcmId'] = this.fcmId;
    data['id'] = this.id;
    data['fcmIdOld'] = this.fcmIdOld;
    data['osIme'] = this.osIme;
    data['osVerzija'] = this.osVerzija;
    data['osSdk'] = this.osSdk;
    data['appVerzija'] = this.appVerzija;
    data['napravaProizvajalec'] = this.napravaProizvajalec;
    data['napravaModel'] = this.napravaModel;
    return data;
  }
}
