import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:semir_potrosnja/model/data_provider.dart';
import 'package:semir_potrosnja/widgets/pdf_builder.dart';

class PreuzmiPDF extends StatefulWidget {
  final String nazivDokumenta;
  final KategorijaModel kategorija;
  PreuzmiPDF({@required this.nazivDokumenta, this.kategorija});
  @override
  _PreuzmiPDFState createState() => _PreuzmiPDFState();
}

class _PreuzmiPDFState extends State<PreuzmiPDF> {
  Future<void> _loadingFuture() async {
    final pdfBuilder = PdfBuilderFunc();
    if (widget.kategorija != null) {
      return pdfBuilder.buildPdf(context, false, widget.kategorija);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.55,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: Theme.of(context).textTheme.headline6,
                        children: [
                          TextSpan(text: 'Izrađujem '),
                          TextSpan(
                              text: 'pdf ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.red[500],
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: 'dokument!'),
                        ])),
                SizedBox(height: 40),
                Container(
                    width: 90,
                    height: 90,
                    child: Image.asset('assets/images/pdf-logo.png')),
                SizedBox(height: 30),
                Spacer(),
                FutureBuilder(
                    future: _loadingFuture(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        );
                      } else {
                        return Column(
                          children: <Widget>[
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline5,
                                  children: [
                                    TextSpan(text: 'Dokument '),
                                    TextSpan(
                                      text: '${widget.nazivDokumenta}.pdf ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600]),
                                    ),
                                    TextSpan(text: 'kreiran!'),
                                  ]),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline5,
                                  children: [
                                    TextSpan(text: 'Direktorij: '),
                                    TextSpan(
                                      text: '/storage/emulated/0/Download ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                           
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    width: 100,
                                    child: RaisedButton(
                                      color: Colors.red[700],
                                      onPressed: () {
                                        String path =
                                            '/storage/emulated/0/Download/${widget.nazivDokumenta}.pdf';

                                        OpenFile.open(path);
                                      },
                                      child: Text(
                                        'Otvori',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                Container(
                                    width: 100,
                                    child: RaisedButton(
                                      color: Colors.red[700],
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Izađi',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            )
                          ],
                        );
                      }
                    })
              ],
            ),
          ),
        )
      ],
    );
  }
}
