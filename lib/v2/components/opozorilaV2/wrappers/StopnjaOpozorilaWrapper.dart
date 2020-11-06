class StopnjaOpozorilaWrapper {
  String tipStopnje;
  int stopnja;
  String opis1;
  String opis2;
  String opis3;
  int maxStopnja;

  StopnjaOpozorilaWrapper(
      {this.tipStopnje,
      this.stopnja,
      this.opis1,
      this.opis2,
      this.opis3,
      this.maxStopnja});

  StopnjaOpozorilaWrapper.fromJson(Map<String, dynamic> json) {
    tipStopnje = json['tipStopnje'];
    stopnja = json['stopnja'];
    opis1 = json['opis1'];
    opis2 = json['opis2'];
    opis3 = json['opis3'];
    maxStopnja = json['maxStopnja'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tipStopnje'] = this.tipStopnje;
    data['stopnja'] = this.stopnja;
    data['opis1'] = this.opis1;
    data['opis2'] = this.opis2;
    data['opis3'] = this.opis3;
    data['maxStopnja'] = this.maxStopnja;
    return data;
  }
}