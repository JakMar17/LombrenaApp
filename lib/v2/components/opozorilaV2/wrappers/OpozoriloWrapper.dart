class OpozorilaWrapper {
  List<Pokrajine> pokrajine;

  OpozorilaWrapper({this.pokrajine});

  OpozorilaWrapper.fromJson(Map<String, dynamic> json) {
    if (json['pokrajine'] != null) {
      pokrajine = new List<Pokrajine>();
      json['pokrajine'].forEach((v) {
        pokrajine.add(new Pokrajine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pokrajine != null) {
      data['pokrajine'] = this.pokrajine.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pokrajine {
  String pokrajinaIme;
  String drzavaIme;
  List<OpozorilaPoTipih> opozorilaPoTipih;

  Pokrajine({this.pokrajinaIme, this.drzavaIme, this.opozorilaPoTipih});

  Pokrajine.fromJson(Map<String, dynamic> json) {
    if(json['pokrajinaIme'] == 'jugovzhod')
      pokrajinaIme = 'jugovzhodna';
    else if(json['pokrajinaIme'] == 'jugozahod')
      pokrajinaIme = 'jugozahodna';
    else
      pokrajinaIme = json['pokrajinaIme'];
    drzavaIme = json['drzavaIme'];
    if (json['opozorilaPoTipih'] != null) {
      opozorilaPoTipih = new List<OpozorilaPoTipih>();
      json['opozorilaPoTipih'].forEach((v) {
        opozorilaPoTipih.add(new OpozorilaPoTipih.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pokrajinaIme'] = this.pokrajinaIme;
    data['drzavaIme'] = this.drzavaIme;
    if (this.opozorilaPoTipih != null) {
      data['opozorilaPoTipih'] =
          this.opozorilaPoTipih.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OpozorilaPoTipih {
  String imeTipa;
  List<Opozorila> opozorila;

  OpozorilaPoTipih({this.imeTipa, this.opozorila});

  OpozorilaPoTipih.fromJson(Map<String, dynamic> json) {
    imeTipa = json['imeTipa'];
    if (json['opozorila'] != null) {
      opozorila = new List<Opozorila>();
      json['opozorila'].forEach((v) {
        opozorila.add(new Opozorila.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeTipa'] = this.imeTipa;
    if (this.opozorila != null) {
      data['opozorila'] = this.opozorila.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Opozorila {
  DateTime veljavnoOd;
  DateTime veljavnoDo;
  String stopnja;
  int stopnjaN;
  int stopnjaMax;
  String opis;
  String navodila;

  Opozorila(
      {this.veljavnoOd,
      this.veljavnoDo,
      this.stopnja,
      this.stopnjaN,
      this.stopnjaMax,
      this.opis,
      this.navodila});

  Opozorila.fromJson(Map<String, dynamic> json) {
    veljavnoOd = DateTime.fromMillisecondsSinceEpoch(json['veljavnoOd']);
    veljavnoDo = DateTime.fromMillisecondsSinceEpoch(json['veljavnoDo']);
    stopnja = json['stopnja'];
    stopnjaN = json['stopnjaN'];
    stopnjaMax = json['stopnjaMax'];
    opis = json['opis'];
    navodila = json['navodila'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['veljavnoOd'] = this.veljavnoOd.millisecondsSinceEpoch;
    data['veljavnoDo'] = this.veljavnoDo.millisecondsSinceEpoch;
    data['stopnja'] = this.stopnja;
    data['stopnjaN'] = this.stopnjaN;
    data['stopnjaMax'] = this.stopnjaMax;
    data['opis'] = this.opis;
    data['navodila'] = this.navodila;
    return data;
  }
}