import 'dart:convert';

WarningsNaprava warningsNapravaFromJson(String str) => WarningsNaprava.fromJson(json.decode(str));

String warningsNapravaToJson(WarningsNaprava data) => json.encode(data.toJson());

class WarningsNaprava {
    WarningsNaprava({
        this.fcmId,
        this.fcmIdOld,
        this.napravaId,
    });

    String fcmId;
    String fcmIdOld;
    String napravaId;

    factory WarningsNaprava.fromJson(Map<String, dynamic> json) => WarningsNaprava(
        fcmId: json["fcmId"],
        fcmIdOld: json["fcmIdOld"],
        napravaId: json["napravaId"],
    );

    String toJson() {
      String json = '{"fcmId": "$fcmId"';

      if(fcmIdOld != null)
        json += ', "fcmIdOld": "$fcmIdOld"';

      return json + '}';
    }
}