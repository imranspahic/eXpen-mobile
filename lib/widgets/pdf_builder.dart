import 'package:flutter/material.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'dart:io';

class PdfBuilderFunc {
  pw.Widget _contentKategorija(BuildContext buildContext, pw.Context pdfCTX) {

   return _contentTable(buildContext, pdfCTX, true);
  }

  pw.Widget _contentTable(BuildContext buildContext, pw.Context pdfCTX, bool isGeneralno,
      [CategoryModel kategorija]) {
    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(buildContext, listen: false);
    List<ExpenseModel> data = !isGeneralno ? 
        expenseNotifier.potrosnjePoKategorijilista(kategorija.id) : expenseNotifier.listaSvihPotrosnji;
    data.sort((a, b) {
      return -a.trosak.compareTo(b.trosak);
    });
    var tableHeaders;
    if(isGeneralno) {
       tableHeaders = [
      'Broj',
      'Naziv potrošnje',
      'Trošak',
      'Datum',
      'Kategorija',  
    ];
    }
    else {
      tableHeaders = [
      'Broj',
      'Naziv potrošnje',
      'Trošak',
      'Datum',
    ];
    }
     

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 5,
        color: PdfColor.fromHex('#cc820c'),
      ),
      headerHeight: 30,
      cellHeight: 50,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        color: PdfColor.fromHex('#ffffff'),
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: pw.TextStyle(
        color: PdfColor.fromHex('#db9316'),
        fontSize: 15,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          color: PdfColor.fromHex('#7d6337'),
          width: .5,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        data.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => data[row].getIndex(row, col),
        ),
      ),
    );
  }

  Future buildPdf(BuildContext buildContext, bool isGeneralno,
      [CategoryModel kategorija]) async {
    final List<CategoryModel> _listaKategorija =
        Provider.of<CategoryNotifier>(buildContext, listen: false)
            .kategorijaLista;
    final int brojKategorija = _listaKategorija.length;

    var datum = DateTime.now();
    var timeStamp = DateTime(datum.year, datum.month, datum.day, datum.hour,
        datum.minute, datum.second);

    final ExpenseNotifier expenseNotifier =
        Provider.of<ExpenseNotifier>(buildContext, listen: false);
    final pdf = pw.Document();
    PdfImage image = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load('assets/images/logo_coin.png'))
          .buffer
          .asUint8List(),
    );
    final font = await rootBundle.load('assets/fonts/Lato-Regular.ttf');
    final font1 =
        await rootBundle.load('assets/fonts/RobotoCondensed-Bold.ttf');
        
    pdf.addPage(pw.MultiPage(
        footer: (pw.Context context) {
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                pw.Padding(
                  padding: pw.EdgeInsets.only(left: 10),
                  child: pw.RichText(
                      text: pw.TextSpan(
                          style: pw.TextStyle(
                              font: pw.Font.ttf(font),
                              color: PdfColor.fromHex('#858381'),
                              fontSize: 18),
                          children: [
                        pw.TextSpan(text: 'Vrijeme generisanja: '),
                        pw.TextSpan(
                            text:
                                '${DateFormat('dd/MM/yyyy HH:mm:ss').format(timeStamp)}',
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#4d4b49')))
                      ])),
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.only(right: 10),
                    child: pw.Text(
                      'Strana: ${context.pageNumber}',
                      style: pw.TextStyle(
                          font: pw.Font.ttf(font),
                          color: PdfColor.fromHex('#858381'),
                          fontSize: 18),
                    ))
              ]);
        },
        theme: pw.ThemeData(
            defaultTextStyle: pw.TextStyle(
                font: pw.Font.ttf(font), fontBold: pw.Font.ttf(font1))),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Image(image, width: 100, height: 100),
              pw.SizedBox(width: 20),
              pw.RichText(
                  text: pw.TextSpan(
                      style: pw.TextStyle(
                          fontSize: 80,
                          color: PdfColor.fromHex('#4a4f4c'),
                          font: pw.Font.ttf(font)),
                      children: [
                    pw.TextSpan(text: 'e'),
                    pw.TextSpan(
                        text: 'X',
                        style:
                            pw.TextStyle(color: PdfColor.fromHex('#fcd226'))),
                    pw.TextSpan(text: 'pen'),
                  ])),
            ]),
            pw.Divider(color: PdfColor.fromHex('#edc626'), thickness: 2),
            pw.SizedBox(height: 10),
            pw.Container(
              color: PdfColor.fromHex('#dedcd3'),
              width: double.infinity,
              height: 50,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Padding(
                        padding: pw.EdgeInsets.only(left: 30),
                        child: pw.Text(
                            !isGeneralno ? 'Kategorija:' : 'Broj kategorija:',
                            style: pw.TextStyle(
                                fontSize: 30,
                                color: PdfColor.fromHex('#75746f')))),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 30),
                      child: pw.Text(
                          !isGeneralno
                              ? '${kategorija.naziv}'
                              : '$brojKategorija',
                          style: pw.TextStyle(
                              fontSize: 30,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#dba904'))),
                    ),
                  ]),
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              color: PdfColor.fromHex('#dedcd3'),
              width: double.infinity,
              height: 50,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Padding(
                        padding: pw.EdgeInsets.only(left: 30),
                        child: pw.Text('Broj potrošnji:',
                            style: pw.TextStyle(
                                fontSize: 30,
                                color: PdfColor.fromHex('#75746f')))),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 30),
                      child: pw.Text(
                          !isGeneralno
                              ? '${expenseNotifier.potrosnjePoKategorijilista(kategorija.id).length}'
                              : '${expenseNotifier.listaSvihPotrosnji.length}',
                          style: pw.TextStyle(
                              fontSize: 30,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#dba904'))),
                    ),
                  ]),
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              color: PdfColor.fromHex('#dedcd3'),
              width: double.infinity,
              height: 50,
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Padding(
                        padding: pw.EdgeInsets.only(left: 30),
                        child: pw.Text('Ukupni trošak:',
                            style: pw.TextStyle(
                                fontSize: 30,
                                color: PdfColor.fromHex('#75746f')))),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(right: 30),
                      child: pw.Text(
                          !isGeneralno
                              ? '${expenseNotifier.trosakPoKategoriji(kategorija.id)} KM'
                              : '${expenseNotifier.ukupniTrosakSvihPotrosnji()} KM',
                          style: pw.TextStyle(
                              fontSize: 30,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#dba904'))),
                    ),
                  ]),
            ),
            pw.SizedBox(height: 10),
            pw.Divider(
              thickness: 2,
              color: PdfColor.fromHex('#edc626'),
            ),
            pw.SizedBox(height: 20),
            if(isGeneralno) _contentKategorija(buildContext, context),
            if(!isGeneralno) _contentTable(buildContext, context,  false, kategorija),
          ];
        }));
    File pdfFile = File(!isGeneralno
        ? '/storage/emulated/0/Download/eXpen-${kategorija.naziv}-podaci.pdf'
        : '/storage/emulated/0/Download/eXpen-podaci.pdf');
    pdfFile.writeAsBytesSync(pdf.save());
  }
}
