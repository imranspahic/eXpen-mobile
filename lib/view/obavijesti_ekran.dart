import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notificationNotifier.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:intl/intl.dart';
import 'package:expen/providers/subcategoryNotifier.dart';

class ObavijestiEkran extends StatefulWidget {

  final NotificationModel otvorenaObavijest;
  ObavijestiEkran({this.otvorenaObavijest});
  @override
  _ObavijestiEkranState createState() => _ObavijestiEkranState();
}

class _ObavijestiEkranState extends State<ObavijestiEkran> {
  Future obavijestiFuture;

  @override
  void initState() {
    if(widget.otvorenaObavijest !=null) {
      Provider.of<NotificationNotifier>(context, listen:false).procitajObavijest(widget.otvorenaObavijest.id, true);
    }
    obavijestiFuture = Provider.of<NotificationNotifier>(context, listen: false)
        .fetchAndSetObavijesti();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final obavijestiData = Provider.of<NotificationNotifier>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Text(
                'Obavijesti',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                  future: obavijestiFuture,
                  builder: (ctx, snapshot) => Column(children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 20.0, top: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Ukupno obavijesti: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Raleway',
                                              color: Colors.blue[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          obavijestiData
                                              .listaSvihObavijesti.length
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 30.0, top: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Nove obavijesti: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Raleway',
                                              color: Colors.red[800],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          obavijestiData
                                              .neprocitaneObavijesti()
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[800]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    width: 2, height: 60, color: Colors.cyan),
                              ),
                              SizedBox(width: 20),
                              Row(children: [
                                InkWell(
                                  child: Icon(Icons.remove_red_eye,
                                      color: Colors.cyan, size: 30),
                                  onTap: () {
                                    Provider.of<NotificationNotifier>(context,
                                            listen: false)
                                        .procitajSveObavijesti();
                                  },
                                ),
                                SizedBox(width: 15),
                                InkWell(
                                  child: Icon(
                                    Icons.delete_sweep,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    Provider.of<NotificationNotifier>(context,
                                            listen: false)
                                        .izbrisiSveObavijesti();
                                  },
                                )
                              ]),
                            ]),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(
                            thickness: 2,
                            color: Colors.cyan,
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: ListView.builder(
                            itemCount:
                                obavijestiData.listaSvihObavijesti.length,
                            itemBuilder: (ctx, index) {
                              return ObavijestWidget(
                                  obavijest: obavijestiData
                                      .listaSvihObavijestiReversed[index]);
                            },
                          ),
                        ),
                      ]))),
        ));
  }
}

class ObavijestWidget extends StatefulWidget {
  final NotificationModel obavijest;
  ObavijestWidget({this.obavijest});

  @override
  _ObavijestWidgetState createState() => _ObavijestWidgetState();
}

class _ObavijestWidgetState extends State<ObavijestWidget> {
  
  @override
  void initState() {
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final katData = Provider.of<CategoryNotifier>(context);
    final potKatData = Provider.of<SubcategoryNotifier>(context);

    return Card(
      child: Row(
        children: [
          Flexible(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyan, width: 1),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Wrap(
                  
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                    Container(margin: EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple)),
                        child: Text(
                          DateFormat.yMMMd().format(widget.obavijest.datum),
                        )),
                    SizedBox(width: 15),
                    if (widget.obavijest.idKategorije != null)
                      Container(
                        margin: EdgeInsets.only(top: 0),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange)),
                          child:  Text(
                                katData.dobijNazivKategorije(
                                    widget.obavijest.idKategorije)),
                          ),
                          SizedBox(width: 15),
                          if (widget.obavijest.idPotKategorije != 'nemaPotkategorija')
                      Container(
                        margin: EdgeInsets.only(top: 0),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green)),
                          child:  Text(
                                potKatData.dobijNazivPotKategorije(
                                    widget.obavijest.idPotKategorije)),
                          ),
                          SizedBox(width: 15),
                          if (widget.obavijest.jeLiProcitano == 'ne')
                      Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red), color: Colors.red),
                          child: Text(
                                'NOVO', style: TextStyle(color:Colors.white),),
                          ),
                  ]),
                  SizedBox(height: 5),
                  AutoSizeText(
                    widget.obavijest.sadrzaj,
                    style: TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: widget.obavijest.jeLiProcitano == 'ne' ? FontWeight.bold : FontWeight.normal),
                    maxLines: 10,
                  )
                ],
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                                children: [
                                   Container(
                    child: InkWell(
                      child: Icon(
                        Icons.remove_red_eye,
                        color: widget.obavijest.jeLiProcitano == 'ne' ? Colors.deepPurple : Colors.grey,
                        size: 30,
                      ),
                      onTap: widget.obavijest.jeLiProcitano == 'ne' ? () {
                        Provider.of<NotificationNotifier>(context, listen: false)
                            .procitajObavijest(widget.obavijest.id, false);
                      } : null,
                    ),
                  ),SizedBox(width: 10),
                                  Container(
                    child: InkWell(
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 30,
                      ),
                      onTap: () {
                        Provider.of<NotificationNotifier>(context, listen: false)
                            .izbrisiObavijest(widget.obavijest.id);
                      },
                    ),
                  ),
                                ] 
                ),
              )),
        ],
      ),
    );
  }
}
