// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromMap(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toMap());

class DataModel {
    DataModel({
        this.id,
        this.title,
        this.geoLat,
        this.geoLon,
        this.favorite,
        this.url,
        this.type
    });

    String id;
    String title;
    String geoLat;
    String geoLon;
    bool favorite;
    String url;
    String type;

    factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        title: json["title"],
        geoLat: json["geoLat"],
        geoLon: json["geoLon"],
        favorite: json["favorite"] == 0 ? false : true,
        url: json["url"],
        type: json["type"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "geoLat": geoLat,
        "geoLon": geoLon,
        "favorite": favorite ? 1 : 0,
        "url": url,
        "type": type
    };
}
