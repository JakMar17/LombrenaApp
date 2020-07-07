
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/type_of_data.dart';

class MerilnoMestoVodotok {

  final String type = TypeOfData.vodotok;
  bool isFavourite = false;
  String url;
  
  String sifra;
  String id;
  
  /* geolocation */
  double geoLat;
  double geoLon;

  String reka;
  String merilnoMesto;
  String datum;

  double vodostaj;
  double pretok;
  String pretokZnacilni;
  String vodostajZnacilni;
  double tempVode;

  double prviPretok;
  double drugiPretok;
  double tretjiPretok;

  double prviVodostaj;
  double drugiVodostaj;
  double tretjiVodostaj;

  double znacilnaVisina;
  String smerValovanja;

  MerilnoMestoVodotok({
    this.sifra,
    this.geoLat,
    this.geoLon,
    this.reka,
    this.merilnoMesto,
    this.datum,
    this.vodostaj,
    this.pretok,
    this.pretokZnacilni,
    this.vodostajZnacilni,
    this.tempVode,
    this.prviPretok,
    this.drugiPretok,
    this.tretjiPretok,
    this.prviVodostaj,
    this.drugiVodostaj,
    this.tretjiVodostaj,
    this.znacilnaVisina,
    this.smerValovanja
  }) {
    id = sifra;
  }

  Map<String, dynamic> toJson() => {
    'id': id
  };
}

class VodotokReka {
  String reka;
  List<MerilnoMestoVodotok> vodotoki = [];

  VodotokReka({
    this.reka
  });

  bool addVodotok(MerilnoMestoVodotok merilnoMestoVodotok) {
    vodotoki.add(merilnoMestoVodotok);
  }
}

class VodotokiPoRekah {

  static RestApi restApi;
  List<VodotokReka> vodotokiPoRekah = [];

  VodotokiPoRekah () {
    if(restApi == null)
      restApi = RestApi();
  }

  List<VodotokReka> fetchVodotokiPoRekah() {
    List<MerilnoMestoVodotok> vodotoki = restApi.getVodotoki();
    
    for (MerilnoMestoVodotok v in vodotoki) {
      bool inserted = false;
      for(VodotokReka vr in vodotokiPoRekah) {
        if(vr.reka == v.reka) {
          vr.addVodotok(v);
          inserted = true;
          break;
        }
      }

      if(!inserted) {
        VodotokReka vr = VodotokReka(reka: v.reka);
        vr.addVodotok(v);
        vodotokiPoRekah.add(vr);
      }
    }

    return vodotokiPoRekah;
  }
}