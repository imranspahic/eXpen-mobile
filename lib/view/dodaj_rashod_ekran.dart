import 'package:expen/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/salaryNotifier.dart';
import 'package:expen/providers/expenseCategoryNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
//RASHOD ZA POTKATEGORIJU

class DodajRashodEkran extends StatefulWidget {
  final Category kategorija;
  final bool isKategorija;
  DodajRashodEkran({this.kategorija, this.isKategorija});
  @override
  _DodajRashodEkranState createState() => _DodajRashodEkranState();
}

class _DodajRashodEkranState extends State<DodajRashodEkran> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final rashodController = TextEditingController();
  bool rashodPostavljen = false;
  DateTime datum;
  final vrijednostFocus = FocusNode();
  Future rashodKategorijaFuture;
  Future plataFuture;

  @override
  void initState() {
    vrijednostFocus.addListener(vrijednostListener);
    rashodKategorijaFuture = Provider.of<ExpenseCategoryNotifier>(context, listen: false).fetchAndSetRashodKategorija();
    if(!widget.isKategorija) {
     
      plataFuture = Provider.of<SalaryNotifier>(context, listen: false).fetchAndSetPlata();
    }
    super.initState();
  }

  void vrijednostListener() {
    if(!vrijednostFocus.hasFocus) {
      setState(() {
        
      });
    }
  }

  @override
  void dispose() {
    vrijednostFocus.removeListener(vrijednostListener);
    rashodController.dispose();
    vrijednostFocus.dispose();
    super.dispose();
  }

  void submitData(BuildContext context) {
    final unesenaVrijednost = rashodController.text;

    if (double.parse(unesenaVrijednost) < 0) {
      return;
    }
    if (prikazaniMjesec == null) {
      return;
    }
    // final CategoryNotifier categoryNotifier = Provider.of<KategorijaLista>(context, listen: false);
    final plataData = Provider.of<SalaryNotifier>(context, listen: false);
    final rashodKategorijaData = Provider.of<ExpenseCategoryNotifier>(context, listen: false);

    widget.isKategorija ?
    rashodKategorijaData.dodajRashodKategorije(widget.kategorija.id,
        prikazaniMjesec, double.parse(unesenaVrijednost)) : 
        plataData.dodajPlatu(prikazaniMjesec, double.parse(unesenaVrijednost));
    setState(() {
      rashodController.text = '';
      prikazaniMjesec = null;
    });
    widget.isKategorija ?
   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Rashod dodan '), duration: Duration(seconds: 2),))
   :  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Prihod dodan '), duration: Duration(seconds: 2),))
   ;
  }

  Widget buildMonths(String short, String long, int s, int datetime) {
    return InkWell(
      onTap: () {
        s = datetime;
        Navigator.of(context).pop(s);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
        height: 30,
        width: 30,
        child: GridTile(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: FittedBox(
                              child: Text(short,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 50)),
              )),
          footer: Container(
              alignment: Alignment.center,
              child: FittedBox(
                              child: Text(
                  long,
                  style: TextStyle(color: Colors.white, fontSize: 19),
                ),
              ),
              color: Colors.black54),
        ),
      ),
    );
  }

  int izabraniMjesec = DateTime.now().month;
  String prikazaniMjesec;
  void _presentDatePicker() async {
    int s;

    s = await showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Column(
              children: <Widget>[
                Text(
                  'Odaberi mjesec',
                  style: TextStyle(fontSize: 25, fontFamily: 'Lato'),
                ),
                Divider(
                  color: Theme.of(context).primaryColor,
                  thickness: 1,
                ),
              ],
            ),
            titlePadding: EdgeInsets.all(10),
            children: <Widget>[
              Container(
                width: 450,
                height: 400,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 6 / 6,
                  ),
                  children: <Widget>[
                    buildMonths('J', 'Januar', s, DateTime.january),
                    buildMonths('F', 'Februar', s, DateTime.february),
                    buildMonths('M', 'Mart', s, DateTime.march),
                    buildMonths('A', 'April', s, DateTime.april),
                    buildMonths('M', 'Maj', s, DateTime.may),
                    buildMonths('J', 'Juni', s, DateTime.june),
                    buildMonths('J', 'Juli', s, DateTime.july),
                    buildMonths('A', 'August', s, DateTime.august),
                    buildMonths('S', 'Septembar', s, DateTime.september),
                    buildMonths('O', 'Oktobar', s, DateTime.october),
                    buildMonths('N', 'Novembar', s, DateTime.november),
                    buildMonths('D', 'Decembar', s, DateTime.december),
                  ],
                ),
              ),
            ],
          );
        });
    
    izabraniMjesec = s;
    switch (izabraniMjesec) {
      case 1:
        setState(() {
          prikazaniMjesec = 'Januar';
        });

        break;
      case 2:
        setState(() {
          prikazaniMjesec = 'Februar';
        });
        break;
      case 3:
        setState(() {
          prikazaniMjesec = 'Mart';
        });
        break;
      case 4:
        setState(() {
          prikazaniMjesec = 'April';
        });
        break;
      case 5:
        setState(() {
          prikazaniMjesec = 'Maj';
        });
        break;
      case 6:
        setState(() {
          prikazaniMjesec = 'Juni';
        });
        break;
      case 7:
        setState(() {
          prikazaniMjesec = 'Juli';
        });
        break;
      case 8:
        setState(() {
          prikazaniMjesec = 'August';
        });
        break;
      case 9:
        setState(() {
          prikazaniMjesec = 'Septembar';
        });
        break;
      case 10:
        setState(() {
          prikazaniMjesec = 'Oktobar';
        });
        break;
      case 11:
        setState(() {
          prikazaniMjesec = 'Novembar';
        });
        break;
      case 12:
        setState(() {
          prikazaniMjesec = 'Decembar';
        });
        break;
      default:
    }
  }

  List<String> convertKeysToList() {
    List<String> nazivi = [];
    final sveKatData = Provider.of<SettingsNotifier>(context, listen: false);
    nazivi = widget.isKategorija? widget.kategorija.mapaRashoda.keys.toList() : sveKatData.rashodSveKategorijeMapa.keys.toList();
    return nazivi;
  }

  List<double> convertValuesToList() {
    List<double> vrijednosti = [];
    List<double> rashodVrijednosti = [];
    List<double> plataVrijednosti = [];
    List<String> mjeseci = ['Januar', 'Februar', 'Mart', 'April', 'Maj', 'Juni', 'Juli', 'August', 'Septembar', 'Oktobar', 'Novembar', 'Decembar'];
    // final sveKatData = Provider.of<SveKategorije>(context, listen: false);
    final plataData = Provider.of<SalaryNotifier>(context, listen: false);
    final rashodKategorijaData = Provider.of<ExpenseCategoryNotifier>(context, listen: false);
    if(!widget.isKategorija) {
      for(int i=0; i<=11; i++) {
         plataVrijednosti.add(plataData.dobijPlatuPoMjesecu(mjeseci[i]));
      }
    }
    else {
      for(int i=0; i<=11; i++) {
         rashodVrijednosti.add(rashodKategorijaData.dobijRashodKategorijePoMjesecu(widget.kategorija.id, mjeseci[i]));
      }
    }
    vrijednosti = widget.isKategorija? rashodVrijednosti
     : plataVrijednosti;
    return vrijednosti;
  }

  List<String> shortcutMjeseci () {
    List<String> skracenice = ['J', 'F', 'M', 'A' , 'M', 'J', 'J', 'A' , 'S', 'O', 'N' ,'D'];
    return skracenice;
    
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: !widget.isKategorija ? IconThemeData(color: Colors.white) : Theme.of(context).iconTheme,
        backgroundColor: !widget.isKategorija ? Colors.green[700]: Theme.of(context).primaryColor,
        title: widget.isKategorija ? Text('Dodaj rashod za ${widget.kategorija.naziv}',) : Row(children: [
          Icon(Icons.account_balance_wallet, color: Colors.white),
          SizedBox(width: 10),
          Text('Prihod', style: TextStyle(color: Colors.white),),
        ],) ,
        actions: [
          if(widget.isKategorija) Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 5, bottom: 5),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: widget.kategorija.slikaUrl == 'assets/images/nema-slike.jpg' ? AssetImage(widget.kategorija.slikaUrl) : MemoryImage(widget.kategorija.slikaEncoded,),)
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            height: 110,
            padding: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                 
                  focusNode: vrijednostFocus,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 50, color: Colors.green),
                  decoration: InputDecoration(
                    
                      labelStyle: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 20),
                      labelText: 'Dodaj vrijednost',
                      contentPadding: EdgeInsets.only(bottom: 10, top: 0)),
                  controller: rashodController,
                ),
              ),
            ),
          ),
          Container(
            height: 110,
            padding: EdgeInsets.all(10),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        prikazaniMjesec == null
                            ? 'Mjesec: '
                            : 'Mjesec: $prikazaniMjesec',
                        style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).accentColor,
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'Izaberi mjesec',
                          style: widget.isKategorija ? TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.5) :
                              TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.5, color: Colors.green[700]) ,
                        ),
                      ),
                      onPressed: _presentDatePicker,
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 200,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              child: Text(
               widget.isKategorija ? 'Dodaj rashod' : 'Dodaj prihod',
                style: widget.isKategorija ? Theme.of(context).textTheme.button : Theme.of(context).textTheme.button.copyWith(color: Colors.white),
              ),
              onPressed: ()  {
                if(prikazaniMjesec == null) {
                  _scaffoldKey.currentState.hideCurrentSnackBar();
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Niste izabrali mjesec!', textAlign: TextAlign.center ,style: TextStyle(color: Colors.red, fontSize: 23),),duration: Duration(seconds: 2),));
                }
                else {
                  // Provider.of<PlataLista>(context, listen: false).izbrisi();
                  submitData(context);
                }
                },
              color: widget.isKategorija ? Theme.of(context).primaryColor : Colors.green[700],
              textColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35, bottom: 15),
            child: Container(
              child: Center(
                  child: Text(
                widget.isKategorija? 'Dodani rashodi po mjesecima' : 'Prihod po mjesecima',
                style: Theme.of(context).textTheme.subtitle1,
              )),
            ),
          ),
          FutureBuilder(future: widget.isKategorija? rashodKategorijaFuture : plataFuture, builder: (ctx, snapshot) =>
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 900,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 12,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(5),
                      leading: Container(
                        width: 200,
                        margin: EdgeInsets.only(left: 20),
                        child: Row(children: <Widget>[
                          Text(shortcutMjeseci()[index],
                            style: TextStyle(fontFamily: 'Lato', fontSize: 40, color: Theme.of(context).primaryColor)),
                            SizedBox(width: 10,),
                          Text(
                            convertKeysToList()[index],
                            style: TextStyle(fontFamily: 'Lato', fontSize: 18),
                          ),
                        ]),
                      ),
                      trailing: Container(
                        margin: EdgeInsets.only(right:15),
                        child: Text(
                          '${convertValuesToList()[index].toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 23,
                              fontFamily: 'Lato'),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
          ),
          
        ]),
      ),
    );
  }
}
