import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vreme/data/api/rest_api.dart';
import 'package:vreme/data/models/napoved_text.dart';
import 'package:vreme/style/custom_icons.dart';
import 'package:sliver_fab/sliver_fab.dart';

class TekstovnaNapoved extends StatefulWidget {
  TekstovnaNapoved({Key key}) : super(key: key);

  @override
  _TekstovnaNapovedState createState() => _TekstovnaNapovedState();
}

class _TekstovnaNapovedState extends State<TekstovnaNapoved> {
  TextNapoved napoved;
  RestApi restApi = RestApi();
  dynamic playButton;
  bool playing = false;
  final String url =
      "https://meteo.arso.gov.si/uploads/probase/www/fproduct/media/sl/fcast_si_audio_hbr.mp3";
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    napoved = restApi.getTekstovnaNapoved();
    playButton = Icon(Icons.play_arrow);
    super.initState();
  }

  @override
  void dispose() {
    player.release();
    super.dispose();
  }

  Future<void> playTrack() async {
    if (playing) {
      playing = false;
      setState(() {
        playButton = Icon(Icons.play_arrow);
      });
      await player.pause();
    } else {
      setState(() {
        playButton = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SpinKitRipple(color: Colors.white24),
            Icon(Icons.file_download)
          ],
        );
      });

      try {
        await player.resume();
      } on Exception catch (_) {
        await player.play(url, isLocal: false);
      }
      playing = true;
      setState(() {
        playButton = Icon(Icons.pause);
      });
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [CustomColors.blue, CustomColors.blue2],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (context) => SliverFab(
              floatingWidget: FloatingActionButton(
                onPressed: playTrack,
                child: playButton,
                backgroundColor: CustomColors.darkGrey,
              ),
              floatingPosition: FloatingPosition(right: 10),
              expandedHeight: 300,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: CustomColors.blue,
                  pinned: true,
                  expandedHeight: 300,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Tekstovna napoved",
                      style: TextStyle(fontFamily: "Montserrat"),
                    ),
                  ),
                ),
                _buildTitle("Napoved za Slovenijo"),
                _buildParagraph(napoved.napovedSlo1),
                _buildParagraph(napoved.napovedSlo2),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                _buildTitle("Napoved za sosednje pokrajine"),
                _buildParagraph(napoved.napovedSos1),
                _buildParagraph(napoved.napovedSos2),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                _buildTitle("Vremenska slika"),
                _buildParagraph(napoved.slikaEu1),
                _buildParagraph(napoved.slikaEu2),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                _buildTitle("Obeti"),
                _buildParagraph(napoved.obeti),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                _buildTitle("Opozorilo"),
                _buildParagraph(napoved.opozorilo),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildTitle(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 15),
        child: Text(
          title,
          style: TextStyle(
              fontSize: 32,
              fontFamily: "Montserrat",
              color: Colors.white,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.8),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(left: 20, top: 10, right: 10),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
