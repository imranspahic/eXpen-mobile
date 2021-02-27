import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ExcelExportDialog extends StatefulWidget {
  @override
  _ExcelExportDialogState createState() => _ExcelExportDialogState();
}

class _ExcelExportDialogState extends State<ExcelExportDialog> {
  Future<void> _loadingFuture() {
    return Future.delayed(Duration(seconds: 2));
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
                              text: 'excel',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.green[600],
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: '/'),
                          TextSpan(
                              text: 'csv ',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold)),
                          TextSpan(text: 'dokument!'),
                        ])),
                SizedBox(height: 10),
                Container(
                    width: 70,
                    height: 70,
                    child: Image.asset('assets/images/excel-logo.png')),
                SizedBox(height: 30),
                FutureBuilder(
                    future: _loadingFuture(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
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
                                      text: 'eXpen-potrosnje.csv ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[600]),
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
                                      color: Colors.green[700],
                                      onPressed: () {
                                        String path =
                                            '/storage/emulated/0/Download/eXpen-potrosnje.csv';

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
                                      color: Colors.green[700],
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
