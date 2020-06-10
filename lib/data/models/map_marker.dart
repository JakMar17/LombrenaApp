class MapMarker {
  String title;
  String showData;
  double lat;
  double lon;
  var mark;
  var leading;
  var closing;
  String url;
  var onPress;
  var object;

  MapMarker({
    this.title,
    this.closing,
    this.leading,
    this.mark,
    this.object,
    this.onPress,
    this.url,
    this.showData,
    this.lat,
    this.lon
  });

}