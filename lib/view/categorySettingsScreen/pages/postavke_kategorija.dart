import 'package:flutter/material.dart';
import 'package:semir_potrosnja/view/categorySettingsScreen/widgets/gridOpcija.dart';
import 'package:semir_potrosnja/viewModel/categoryViewModel/pickCategoryImageViewModel.dart';
import 'package:semir_potrosnja/viewModel/categoryViewModel/showChangeCategoryNameDialog.dart';
import '../../../model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../widgets/pdf_dialog.dart';

class PostavkeKategorija extends StatefulWidget {
  final KategorijaModel kategorija;
  PostavkeKategorija({this.kategorija});

  @override
  _PostavkeKategorijaState createState() => _PostavkeKategorijaState();
}

class _PostavkeKategorijaState extends State<PostavkeKategorija> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _postaviIkonuZaPotrosnje() {}

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
                    child: Consumer<KategorijaLista>(
                      builder: (context, providerData, child) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: widget.kategorija.slikaUrl ==
                                    'assets/images/nema-slike.jpg'
                                ? Image.asset('assets/images/nema-slike.jpg',
                                    fit: BoxFit.cover)
                                : Image.memory(
                                    widget.kategorija.slikaEncoded,
                                    fit: BoxFit.cover,
                                  ));
                      },
                    ),
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
              Flexible(
               
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 7 / 8,
                  ),
                  children: [
                    GridOpcija(
                      naziv: 'Izaberi/promijeni sliku',
                      ikona: Icons.image,
                      funkcija: () => pickCategoryImage(
                          context, _scaffoldKey, widget.kategorija),
                    ),
                    GridOpcija(
                      naziv: 'Promijeni naziv',
                      ikona: Icons.edit,
                      funkcija: () => showChangeCategoryNameDialog(
                          context, widget.kategorija.id),
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
              Divider()

           
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
