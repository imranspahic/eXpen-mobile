import 'dart:io';
import 'package:flutter/material.dart';
import 'package:semir_potrosnja/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:semir_potrosnja/view/settingsScreen/widgets/excelExportDialog.dart';

class SettingsExcelExport extends StatelessWidget {
  const SettingsExcelExport({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final kategorijaData =
            Provider.of<KategorijaLista>(context, listen: false);
        final providerData =
            Provider.of<PotrosnjaLista>(context, listen: false);
        final potkategorijaData =
            Provider.of<PotKategorijaLista>(context, listen: false);

        List<PotrosnjaModel> data = providerData.listaSvihPotrosnji;
        data.forEach((potrosnja) {
          if (potrosnja.naziv.contains('š')) {
            potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('š'), 's');
          }
          if (potrosnja.naziv.contains('č')) {
            potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('č'), 'c');
          }
          if (potrosnja.naziv.contains('ć')) {
            potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('ć'), 'c');
          }
          if (potrosnja.naziv.contains('ž')) {
            potrosnja.naziv = potrosnja.naziv.replaceFirst(RegExp('ž'), 'z');
          }
        });
        List<List<dynamic>> csvData = [
          <String>['Naziv', 'Trosak', 'Datum', 'Kategorija', 'Potkategorija'],
          ...data.map((item) => [
                ' ${item.naziv}',
                '  ${item.trosak.toStringAsFixed(2)} KM',
                '  ${DateFormat.yMMMMd().format(item.datum)}',
                '${kategorijaData.dobijKategorijuPoId(item.idKategorije).naziv}',
                '${potkategorijaData.potKategorijaPoId(item.idPotKategorije)}',
              ])
        ];
        String csv = const ListToCsvConverter().convert(csvData);

        final String dir = '/storage/emulated/0/Download';

        final String path = '$dir/eXpen-potrosnje.csv';
        final File file = File(path);
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        await file.writeAsString(csv);

        showDialog(
            context: context,
            builder: (ctx) {
              return ExcelExportDialog();
            });
      },
      title: Text(
        'Izvezi potrošnje',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Kreiraj .csv fajl sa potrošnjama'),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
            width: 40,
            child:
                Image.asset('assets/images/excel-logo.png', fit: BoxFit.cover)),
      ),
    );
  }
}
