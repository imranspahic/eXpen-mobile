import 'package:flutter/material.dart';
import 'package:expen/widgets/pdf_builder.dart';
import 'package:expen/widgets/pdf_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPDFExport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        final pdfBuilder = PdfBuilderFunc();

        await pdfBuilder.buildPdf(context, true);
        showDialog(
            context: context,
            builder: (ctx) {
              return PreuzmiPDF(
                nazivDokumenta: 'eXpen-podaci',
              );
            });
      },
      title: Text(
        'Izvezi u pdf',
        style: TextStyle(fontSize: 22),
      ),
      subtitle: Text('Kreiraj .pdf fajl sa svim podacima'),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Container(
            width: 40,
            child:
                Image.asset('assets/images/pdf-logo.png', fit: BoxFit.cover)),
      ),
    );
  }
}
