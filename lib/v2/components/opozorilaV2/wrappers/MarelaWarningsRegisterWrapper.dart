import 'package:vreme/v2/components/opozorilaV2/wrappers/OpozoriloWrapper.dart';

class MarelaWarningsRegisterWrapper {
  Naprava naprava;
  List<Pokrajine> pokrajine;
  List<Tipi> tipi;
  Stopnja stopnja;

  MarelaWarningsRegisterWrapper(
      {this.naprava, this.pokrajine, this.tipi, this.stopnja});

  MarelaWarningsRegisterWrapper.fromJson(Map<String, dynamic> json) {
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

  Naprava({this.fcmId});

  Naprava.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcmId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcmId'] = this.fcmId;
    return data;
  }
}

class Drzava {
  String drzavaIme;

  Drzava({this.drzavaIme});

  Drzava.fromJson(Map<String, dynamic> json) {
    drzavaIme = json['drzavaIme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['drzavaIme'] = this.drzavaIme;
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
  int stopnja;

  Stopnja({this.stopnja});

  Stopnja.fromJson(Map<String, dynamic> json) {
    stopnja = json['stopnja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stopnja'] = this.stopnja;
    return data;
  }
}