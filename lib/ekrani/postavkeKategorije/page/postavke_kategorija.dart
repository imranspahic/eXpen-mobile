import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semir_potrosnja/ekrani/postavkeKategorije/widgets/gridOpcija.dart';
import '../../../model/data_provider.dart';
import 'package:provider/provider.dart';
import '../../../widgets/pdf_builder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/pdf_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PostavkeKategorija extends StatefulWidget {
  final KategorijaModel kategorija;
  PostavkeKategorija({this.kategorija});

  @override
  _PostavkeKategorijaState createState() => _PostavkeKategorijaState();
}

class _PostavkeKategorijaState extends State<PostavkeKategorija> {
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future _izaberiSliku() async {
    final slika = await picker.getImage(source: ImageSource.gallery);
    List<int> slikaBytes = await slika.readAsBytes();

    String slikaEncode = base64Encode(slikaBytes);

    if (slikaEncode.length > 970000) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 15),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Slika je veća od ',
              ),
              TextSpan(
                  text: '700KB',
                  style: TextStyle(
                      color: Colors.blue[300], fontWeight: FontWeight.bold)),
              TextSpan(text: ', izaberite drugu!')
            ])),
          ],
        ),
        duration: Duration(seconds: 4),
      ));
      return;
    } else {
      final katData = Provider.of<KategorijaLista>(context, listen: false);
      setState(() {
        katData.updateSlikuKategorije(slikaEncode, widget.kategorija.id);
      });
    }
  }

  void _promijeniNaziv() {
    showDialog(
        context: context,
        builder: (ctx) {
          return PromijeniNaziv(kategorijaId: widget.kategorija.id);
        }).then((value) {
      if (value == 'promijenjeno') {
        setState(() {});
      }
    });
  }

  Future<void> _preuzmiPodatkePDF() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    showDialog(
        context: context,
        builder: (ctx) {
          return PreuzmiPDF(
            nazivDokumenta: 'eXpen-${widget.kategorija.naziv}-podaci',
            kategorija: widget.kategorija,
          );
        });
  }

  void _postaviIkonuZaPotrosnje() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Postavke: ${widget.kategorija.naziv}'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: widget.kategorija.slikaUrl ==
                                'assets/images/nema-slike.jpg'
                            ? Image.asset('assets/images/nema-slike.jpg',
                                fit: BoxFit.cover)
                            : Image.memory(
                                widget.kategorija.slikaEncoded,
                                fit: BoxFit.cover,
                              )),
                  ),
                  Positioned(
                      bottom: 20,
                      right: 20,
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
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 3 / 3,
                  ),
                  children: [
                    GridOpcija(
                      naziv: 'Izaberi/promijeni sliku',
                      ikona: Icons.image,
                      funkcija: _izaberiSliku,
                    ),
                    GridOpcija(
                      naziv: 'Promijeni naziv',
                      ikona: Icons.edit,
                      funkcija: _promijeniNaziv,
                    ),
                    GridOpcija(
                      naziv: 'Postavi ikonu za potrošnje',
                      ikona: Icons.insert_emoticon,
                    ),
                    GridOpcija(
                      naziv: 'Preuzmi podatke u PDF',
                      slika: Image.asset('assets/images/pdf-logo.png'),
                      funkcija: _preuzmiPodatkePDF,
                    ),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: _izaberiSliku,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.green[100]),
              //     width: MediaQuery.of(context).size.width,
              //     height: 60,
              //     child: FittedBox(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 10.0, vertical: 5.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Icon(Icons.image, size: 50, color: Colors.green),
              //             SizedBox(width: 15),
              //             Text(
              //               'Izaberi sliku',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .subtitle1
              //                   .copyWith(color: Colors.green[700]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // GestureDetector(
              //   onTap: _promijeniNaziv,
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.orange[200]),
              //     width: MediaQuery.of(context).size.width,
              //     height: 60,
              //     child: FittedBox(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 10.0, vertical: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Icon(Icons.edit,
              //                 size: 50, color: Colors.orange[700]),
              //             SizedBox(width: 15),
              //             Text(
              //               'Promijeni naziv',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .subtitle1
              //                   .copyWith(color: Colors.orange[800]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // GestureDetector(
              //   onTap: () async {
              //     var status = await Permission.storage.status;
              //     if (!status.isGranted) {
              //       await Permission.storage.request();
              //     }
              //     final pdfBuilder = PdfBuilderFunc();
              //     await pdfBuilder.buildPdf(
              //         context, false, widget.kategorija);
              //     showDialog(
              //         context: context,
              //         builder: (ctx) {
              //           return PreuzmiPDF(
              //             nazivDokumenta:
              //                 'eXpen-${widget.kategorija.naziv}-podaci',
              //           );
              //         });
              //   },
              //   child: Container(
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         color: Colors.red[500].withOpacity(0.4)),
              //     width: MediaQuery.of(context).size.width,
              //     height: 60,
              //     child: FittedBox(
              //       child: Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 10.0, vertical: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Container(
              //                 width: 50,
              //                 height: 50,
              //                 child:
              //                     Image.asset('assets/images/pdf-logo.png')),
              //             SizedBox(width: 15),
              //             Text(
              //               'Preuzmi podatke u PDF',
              //               softWrap: false,
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .subtitle1
              //                   .copyWith(color: Colors.red[800]),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ));
  }
}

class PromijeniNaziv extends StatefulWidget {
  final String kategorijaId;
  PromijeniNaziv({this.kategorijaId});
  @override
  _PromijeniNazivState createState() => _PromijeniNazivState();
}

class _PromijeniNazivState extends State<PromijeniNaziv> {
  TextEditingController _nazivController = TextEditingController();

  void _sacuvaj() {
    final naziv = _nazivController.text;
    final katData = Provider.of<KategorijaLista>(context, listen: false);
    katData.updateNazivKategorije(naziv, widget.kategorijaId);
    Navigator.of(context).pop('promijenjeno');
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.edit, color: Colors.orange[700], size: 60),
                    SizedBox(width: 10),
                    Text(
                      'Promijeni naziv',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.orange[800]),
                    ),
                  ],
                ),
                Divider(color: Colors.orange, thickness: 2),
                SizedBox(height: 30),
                Container(
                    width: 200,
                    child: TextField(
                      controller: _nazivController,
                      decoration: InputDecoration(hintText: 'Unesi naziv'),
                    )),
                Spacer(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          width: 100,
                          child: RaisedButton(
                            onPressed: _sacuvaj,
                            color: Colors.orange,
                            child: Text(
                              'Sačuvaj',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                      Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.grey,
                            child: Text(
                              'Odustani',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          )),
                    ])
              ],
            ),
          ),
        )
      ],
    );
  }
}
