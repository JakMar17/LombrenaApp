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
        this.typeOfData
    });

    String id;
    String title;
    String geoLat;
    String geoLon;
    bool favorite;
    String url;
    String typeOfData;

    factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
        id: json["id"],
        title: json["title"],
        geoLat: json["geoLat"],
        geoLon: json["geoLon"],
        favorite: json["favorite"] == 0 ? false : true,
        url: json["url"],
        typeOfData: json["typeOfData"]
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "geoLat": geoLat,
        "geoLon": geoLon,
        "favorite": favorite ? 1 : 0,
        "url": url,
        "typeOfData": typeOfData
    };
}
