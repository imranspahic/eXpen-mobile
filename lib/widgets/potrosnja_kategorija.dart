import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semir_potrosnja/view/categorySettingsScreen/pages/postavke_kategorija.dart';
import 'package:semir_potrosnja/view/tab_kategorija_ekran.dart';
import '../model/data_provider.dart';

class PotrosnjaKategorija extends StatefulWidget {
  //statefull zbog ukupno potrosnji varijable koja se mijenja

  final KategorijaModel kategorija;
  PotrosnjaKategorija(this.kategorija);

  @override
  _PotrosnjaKategorijaState createState() => _PotrosnjaKategorijaState();
}

class _PotrosnjaKategorijaState extends State<PotrosnjaKategorija> {
  void postavkeKategorija(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return PostavkeKategorija(kategorija: widget.kategorija);
    }));
  }

  Future potKategorijafuture;
  Future potrosnjefuture;
  var ukupnoPotrosnji = 0;
  var ukupnoPotkategorija = 0;

  var ukupUPot = 0;

  @override
  void initState() {
    potKategorijafuture =
        Provider.of<PotKategorijaLista>(context, listen: false)
            .fetchAndSetPotkategorije();
    potrosnjefuture = Provider.of<PotrosnjaLista>(context, listen: false)
        .fetchAndSetPotrosnje();
    super.initState();
  }

  void otvoriKategoriju(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return TabKategorijaEkran(widget.kategorija, false);
    }));
  }

  @override
  Widget build(BuildContext context) {
    final katData = Provider.of<KategorijaLista>(context);
    final potKatData = Provider.of<PotKategorijaLista>(context);
    final potData = Provider.of<PotrosnjaLista>(context);
    final postavkeData = Provider.of<SveKategorije>(context);
    return InkWell(
      onTap: () => otvoriKategoriju(context),
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Stack(children: <Widget>[
              ClipRRect(
                child:
                    widget.kategorija.slikaUrl == 'assets/images/nema-slike.jpg'
                        ? Image.asset(
                            widget.kategorija.slikaUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          )
                        : Hero(
                            tag: widget.kategorija.id,
                            child: Image.memory(
                              widget.kategorija.slikaEncoded,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 250,
                            ),
                          ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                      height: 50,
                      width: 250,
                      color: Colors.black54,
                      child: FittedBox(
                        child: Text(
                          widget.kategorija.naziv,
                          style: Theme.of(context).textTheme.subtitle2,
                          textAlign: TextAlign.right,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ))),
            ]),
            Container(
              color: Colors.orangeAccent[100],
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.folder,
                            size: 35,
                            color: Colors.brown[600],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          FutureBuilder(
                            future: potKategorijafuture,
                            builder: (ctx, snapshot) => Text(
                              //ukupno potkategorija prikaz
                              potKatData
                                  .potKategorijePoKategoriji(
                                      widget.kategorija.id)
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800]),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.work,
                            size: 35,
                            color: Colors.orange[800],
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          FutureBuilder(
                            future: potrosnjefuture,
                            builder: (ctx, snapshot) => Text(
                              //ukupno potrosnji prikaz
                              potData
                                  .potrosnjePoKategoriji(widget.kategorija.id)
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800]),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          postavkeData.brisanjeKategorija
                              ? IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 35,
                                    color: Colors.red[600],
                                  ),
                                  onPressed: () {
                                    final potrosnjaData =
                                        Provider.of<PotrosnjaLista>(context,
                                            listen: false);
                                    final potKategorijaData =
                                        Provider.of<PotKategorijaLista>(context,
                                            listen: false);
                                    List<PotrosnjaModel> listaPotrosnji =
                                        potrosnjaData
                                            .potrosnjePoKategorijilista(
                                                widget.kategorija.id);
                                    List<PotKategorija> listaPotkategorija =
                                        potKategorijaData
                                            .potKategorijePoKategorijilista(
                                                widget.kategorija.id);

                                    katData.izbrisiKategoriju(
                                        widget.kategorija.id,
                                        listaPotrosnji,
                                        listaPotkategorija);
                                  })
                              : Container(),
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              size: 35,
                              color: Colors.grey[600],
                            ),
                            onPressed: () => postavkeKategorija(context),
                          ),
                        ],
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
