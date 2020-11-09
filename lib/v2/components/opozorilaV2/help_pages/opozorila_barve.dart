import 'package:flutter/material.dart';
import 'package:vreme/style/custom_icons.dart';

class InforOpozorilaBarvnaLestvica extends StatelessWidget {
  const InforOpozorilaBarvnaLestvica({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    List<_BarvaWrapper> textObjects = [
      _BarvaWrapper(
          color: CustomColors.yellow,
          title: 'Rumeno opozorilo (1. stopnja)',
          description: [
            'Vremenske razmere so lahko neugodne.',
            'Napovedani možni vremenski pojavi niso neobičajni, vendar bodite pozorni, če načrtujete dejavnosti, ki so odvisne od vremenskih razmer.',
            'Priporočamo, da se sproti seznanjate s predvidenimi vremenskimi razmerami in ne tvegajte, kadar ni potrebno.'
          ]),
      _BarvaWrapper(
          color: CustomColors.orange,
          title: 'Oranžno opozorilo (2. stopnja)',
          description: [
            'Vremenske razmere so lahko nevarne.',
            'Napovedani možni meteorološki pojavi so neobičajni oziroma se pojavljajo manj pogosto. Gmotna škoda in žrtve so možne.',
            'Bodite zelo pozorni in se redno seznanjajte s podrobnostmi v zvezi z napovedanimi vremenskimi razmerami. Zavedajte se tveganj, ki se jim morda ne boste mogli izogniti. Upoštevajte uradno izdana priporočila.'
          ]),
      _BarvaWrapper(
          color: CustomColors.red,
          title: 'Rdeče opozorilo (3. stopnja)',
          description: [
            'Vremenske razmere so lahko zelo nevarne.',
            ' Možni so zelo burni meteorološki pojavi. Na širšem območju je možen nastanek večje gmotne škode in nesreč, ogrožena so lahko človeška življenja.',
            'Čim pogosteje se seznanjajte s podrobnostmi v zvezi z napovedanimi vremenskimi razmerami in tveganji. Brezpogojno upoštevajte uradne ukaze in priporočila, bodite pripravljeni na izredne ukrepe.'
          ])
    ];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [CustomColors.blue, CustomColors.blue2],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Pomoč in podpora',
                style: TextStyle(fontFamily: "Montserrat")),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02, horizontal: screenWidth * 0.03),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.help_outline,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: screenWidth * 0.05,
                      ),
                      Flexible(
                          child: Text(
                        'Barvna lestvica in stopnje izdanih opozoril',
                        style: Theme.of(context).textTheme.headline1,
                      )),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Vsa ARSO opozorila so izdana s podatki o tipu opozorila, pokrajini izdaje opozorila in stopnji opozorila. Stopnja opozorila določa nevarnost določenega vremenskega pojava za katerega je izdano opozorilo. Stopnja je označena številčno in barvno.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Obstajajo štiri stopnje opozoril. Zelena stopnja oz. opozorilo ničte stopnje je osnovna stopnja, ki nakazuje, da nevarnosti ni. Sledijo: opozorilo 1. stopnje (rumeno opozorilo), 2. stopnje (oranžno opozorilo) in 3. stopnje (rdeče opozorilo). Vsako izmed opozoril višjih stopenj nakazuje na potencialno nevarnost vremenskega pojava.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                for (_BarvaWrapper w in textObjects)
                  SliverToBoxAdapter(
                    child: _buildExpansionTile(w, context),
                  )
              ],
            ),
          )),
    );
  }

  Widget _buildExpansionTile(_BarvaWrapper wrapper, BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);

    return Container(
      child: Theme(
        data: theme,
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: wrapper.color,
          ),
          trailing: Icon(
            Icons.ac_unit,
            color: Colors.transparent,
          ),
          title: Text(
            wrapper.title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          children: <Widget>[
            for (String s in wrapper.description)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  s,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _BarvaWrapper {
  String title;
  List<String> description;
  Color color;

  _BarvaWrapper({this.title, this.description, this.color});
}
