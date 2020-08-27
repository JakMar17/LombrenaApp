class WarningPrijava {
  Naprava naprava;
  List<Pokrajine> pokrajine;
  List<Tipi> tipi;
  Stopnja stopnja;

  WarningPrijava({this.naprava, this.pokrajine, this.tipi, this.stopnja});

  WarningPrijava.fromJson(Map<String, dynamic> json) {
    naprava =
        json['naprava'] != null ? new Naprava.fromJson(json['naprava']) : null;
    if (json['pokrajine'] != null) {
      pokrajine = new List<Pokrajine>();
      json['pokrajine'].forEach((v) {
        pokrajine.add(new Pokrajine.fromJson(v));
      });
    }
    if (json['tipi'] != null) {
      tipi = new List<Tipi>();
      json['tipi'].forEach((v) {
        tipi.add(new Tipi.fromJson(v));
      });
    }
    stopnja =
        json['stopnja'] != null ? new Stopnja.fromJson(json['stopnja']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.naprava != null) {
      data['naprava'] = this.naprava.toJson();
    }
    if (this.pokrajine != null) {
      data['pokrajine'] = this.pokrajine.map((v) => v.toJson()).toList();
    }
    if (this.tipi != null) {
      data['tipi'] = this.tipi.map((v) => v.toJson()).toList();
    }
    if (this.stopnja != null) {
      data['stopnja'] = this.stopnja.toJson();
    }
    return data;
  }
}

class Naprava {
  String fcmId;
  Null id;
  Null fcmIdOld;

  Naprava({this.fcmId, this.id, this.fcmIdOld});

  Naprava.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcmId'];
    id = json['id'];
    fcmIdOld = json['fcmIdOld'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcmId'] = this.fcmId;
    data['id'] = this.id;
    data['fcmIdOld'] = this.fcmIdOld;
    return data;
  }
}

class Pokrajine {
  Null idPokrajine;
  String imePokrajine;
  Null url;
  Drzava drzava;

  Pokrajine({this.idPokrajine, this.imePokrajine, this.url, this.drzava});

  Pokrajine.fromJson(Map<String, dynamic> json) {
    idPokrajine = json['idPokrajine'];
    imePokrajine = json['imePokrajine'];
    url = json['url'];
    drzava =
        json['drzava'] != null ? new Drzava.fromJson(json['drzava']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idPokrajine'] = this.idPokrajine;
    data['imePokrajine'] = this.imePokrajine;
    data['url'] = this.url;
    if (this.drzava != null) {
      data['drzava'] = this.drzava.toJson();
    }
    return data;
  }
}

class Drzava {
  String imeDrzave;

  Drzava({this.imeDrzave});

  Drzava.fromJson(Map<String, dynamic> json) {
    imeDrzave = json['imeDrzave'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeDrzave'] = this.imeDrzave;
    return data;
  }
}

class Tipi {
  String imeTipa;

  Tipi({this.imeTipa});

  Tipi.fromJson(Map<String, dynamic> json) {
    imeTipa = json['imeTipa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeTipa'] = this.imeTipa;
    return data;
  }
}

class Stopnja {
  String tipStopnje;
  int stopnja;
  String opis1;
  String opis2;
  String opis3;

  Stopnja({this.tipStopnje, this.stopnja, this.opis1, this.opis2, this.opis3});

  Stopnja.fromJson(Map<String, dynamic> json) {
    tipStopnje = json['tipStopnje'];
    stopnja = json['stopnja'];
    opis1 = json['opis1'];
    opis2 = json['opis2'];
    opis3 = json['opis3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipStopnje'] = this.tipStopnje;
    data['stopnja'] = this.stopnja;
    data['opis1'] = this.opis1;
    data['opis2'] = this.opis2;
    data['opis3'] = this.opis3;
    return data;
  }
}