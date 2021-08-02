import 'package:expen/models/Category.dart';
import 'package:expen/services/categoryServices/openCategoryService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/categorySettingsScreen/pages/postavke_kategorija.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:expen/models/Expense.dart';
import 'package:expen/models/Subcategory.dart';

class PotrosnjaKategorija extends StatefulWidget {
  //statefull zbog ukupno potrosnji varijable koja se mijenja

  final Category category;
  PotrosnjaKategorija(this.category);

  @override
  _PotrosnjaKategorijaState createState() => _PotrosnjaKategorijaState();
}

class _PotrosnjaKategorijaState extends State<PotrosnjaKategorija> {
  void postavkeKategorija(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return PostavkeKategorija(kategorija: widget.category);
    }));
  }

  Future potKategorijafuture;
  Future potrosnjefuture;
  var ukupnoPotrosnji = 0;
  var ukupnoPotkategorija = 0;

  var ukupUPot = 0;

  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context);
    final SubcategoryNotifier subcategoryNotifier =
        Provider.of<SubcategoryNotifier>(context);
    final expenseNotifier = Provider.of<ExpenseNotifier>(context);
    final SettingsNotifier settingsNotifier =
        Provider.of<SettingsNotifier>(context);
    return InkWell(
      onTap: () => OpenCategoryService.open(context, widget.category),
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
                    widget.category.slikaUrl == 'assets/images/nema-slike.jpg'
                        ? Image.asset(
                            widget.category.slikaUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                          )
                        : Hero(
                            tag: widget.category.id,
                            child: Image.memory(
                              widget.category.slikaEncoded,
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
                          widget.category.naziv,
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
                              subcategoryNotifier
                                  .potKategorijePoKategoriji(widget.category.id)
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
                              expenseNotifier
                                  .potrosnjePoKategoriji(widget.category.id)
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
                          settingsNotifier.brisanjeKategorija
                              ? IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 35,
                                    color: Colors.red[600],
                                  ),
                                  onPressed: () {
                                    final ExpenseNotifier expenseNotifier =
                                        Provider.of<ExpenseNotifier>(context,
                                            listen: false);
                                    final SubcategoryNotifier
                                        subcategoryNotifier =
                                        Provider.of<SubcategoryNotifier>(
                                            context,
                                            listen: false);
                                    List<Expense> listaPotrosnji =
                                        expenseNotifier
                                            .potrosnjePoKategorijilista(
                                                widget.category.id);
                                    List<Subcategory> listaPotkategorija =
                                        subcategoryNotifier
                                            .potKategorijePoKategorijilista(
                                                widget.category.id);

                                    categoryNotifier.izbrisiKategoriju(
                                        widget.category.id,
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
