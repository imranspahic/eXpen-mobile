import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:expen/models/Subcategory.dart';

class EditPotkategorijaEkran extends StatefulWidget {
  final Subcategory potKategorija;
  EditPotkategorijaEkran(this.potKategorija);

  @override
  _EditPotkategorijaEkranState createState() => _EditPotkategorijaEkranState();
}

class _EditPotkategorijaEkranState extends State<EditPotkategorijaEkran> {
  Widget _icon;
  TextEditingController _nazivController = TextEditingController();
  Color _tempMainColor;
  Color mainColor;
  Color _shadeColor = Colors.blue[800];
  String stariNaziv;
  Color staraBoja;
  int staraIkona;

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context,
        title: Text("Izaberi ikonu"),
        searchHintText: "Pretraži",
        closeChild: Text("Zatvori"),
        showSearchBar: false);

    icon != null
        ? _icon = Icon(
            IconData(icon.codePoint, fontFamily: 'MaterialIcons'),
            size: 40,
          )
        : _icon = Icon(
            IconData(widget.potKategorija.icon, fontFamily: 'MaterialIcons'),
            size: 40,
          );
    setState(() {
      if (icon != null) {
        staraIkona = widget.potKategorija.icon;
        widget.potKategorija.icon = icon.codePoint;
      }
    });

    debugPrint('Picked Icon:  $icon');
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 500, minHeight: 400),
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: Text(title),
            content: content,
            actions: [
              FlatButton(
                child: Text('ODUSTANI'),
                onPressed: Navigator.of(context).pop,
              ),
              FlatButton(
                child: Text('SAČUVAJ'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    staraBoja = mainColor;
                    mainColor = _tempMainColor;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Izaberi boju",
      MaterialColorPicker(
        allowShades: false,
        selectedColor: _shadeColor,
        onMainColorChange: (color) => _tempMainColor = color,
      ),
    );
  }

  @override
  void initState() {
    _nazivController.text = '${widget.potKategorija.naziv}';
    stariNaziv = widget.potKategorija.naziv;
    staraIkona = widget.potKategorija.icon;
    staraBoja = widget.potKategorija.bojaIkone;

    super.initState();
  }

  @override
  void dispose() {
    _nazivController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Spremi promjene?'),
                content: Text('Da li želiš spremiti promjene?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        setState(() {
                          if (staraIkona != null) {
                            widget.potKategorija.icon = staraIkona;
                          }
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Ne')),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        if (mainColor != null) {
                          if (_nazivController.text.length < 25) {
                            widget.potKategorija.naziv = _nazivController.text;
                          } else {
                            //throw error
                          }
                          widget.potKategorija.bojaIkone = mainColor;
                          Provider.of<SubcategoryNotifier>(context,
                                  listen: false)
                              .snimiPromjene(
                            widget.potKategorija.idPot,
                            widget.potKategorija.naziv,
                            widget.potKategorija.bojaIkone,
                            widget.potKategorija.icon.toString(),
                          );
                        } else {
                          if (_nazivController.text.length < 25) {
                            widget.potKategorija.naziv = _nazivController.text;
                          } else {
                            //throw error
                          }
                          Provider.of<SubcategoryNotifier>(context,
                                  listen: false)
                              .snimiPromjene(
                            widget.potKategorija.idPot,
                            widget.potKategorija.naziv,
                            widget.potKategorija.bojaIkone,
                            widget.potKategorija.icon.toString(),
                          );
                        }

                        Navigator.of(context).pop();
                      },
                      child: Text('Da')),
                ],
              );
            });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Uredi: ${widget.potKategorija.naziv}'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Spremi promjene?'),
                      content: Text('Da li želiš spremiti promjene?'),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              setState(() {
                                if (staraIkona != null) {
                                  widget.potKategorija.icon = staraIkona;
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text('Ne')),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              if (mainColor != null) {
                                if (_nazivController.text.length < 25) {
                                  widget.potKategorija.naziv =
                                      _nazivController.text;
                                } else {
                                  //throw error
                                }
                                widget.potKategorija.bojaIkone = mainColor;
                                Provider.of<SubcategoryNotifier>(context,
                                        listen: false)
                                    .snimiPromjene(
                                  widget.potKategorija.idPot,
                                  widget.potKategorija.naziv,
                                  widget.potKategorija.bojaIkone,
                                  widget.potKategorija.icon.toString(),
                                );
                              } else {
                                if (_nazivController.text.length < 25) {
                                  widget.potKategorija.naziv =
                                      _nazivController.text;
                                } else {
                                  //throw error
                                }
                                Provider.of<SubcategoryNotifier>(context,
                                        listen: false)
                                    .snimiPromjene(
                                  widget.potKategorija.idPot,
                                  widget.potKategorija.naziv,
                                  widget.potKategorija.bojaIkone,
                                  widget.potKategorija.icon.toString(),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            child: Text('Da')),
                      ],
                    );
                  });
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                if (mainColor != null) {
                  if (_nazivController.text.length < 25) {
                  } else {
                    //throw error
                  }
                  widget.potKategorija.bojaIkone = mainColor;
                  Provider.of<SubcategoryNotifier>(context, listen: false)
                      .snimiPromjene(
                    widget.potKategorija.idPot,
                    widget.potKategorija.naziv,
                    widget.potKategorija.bojaIkone,
                    widget.potKategorija.icon.toString(),
                  );
                } else {
                  if (_nazivController.text.length < 25) {
                    widget.potKategorija.naziv = _nazivController.text;
                  } else {
                    //throw error
                  }
                  Provider.of<SubcategoryNotifier>(context, listen: false)
                      .snimiPromjene(
                    widget.potKategorija.idPot,
                    widget.potKategorija.naziv,
                    widget.potKategorija.bojaIkone,
                    widget.potKategorija.icon.toString(),
                  );
                }
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(
                  IconData(widget.potKategorija.icon,
                      fontFamily: 'MaterialIcons'),
                  size: 90,
                  color: mainColor == null
                      ? widget.potKategorija.bojaIkone
                      : mainColor,
                ),
                title: Container(
                    width: 100,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                        child: Text(widget.potKategorija.naziv,
                            style: TextStyle(fontSize: 40)))),
                subtitle:
                    Divider(color: Colors.orange, height: 10, thickness: 2),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 100,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Form(
                  child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _nazivController,
                    decoration: InputDecoration(
                      labelText: 'Promijeni naziv',
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onFieldSubmitted: (val) {
                      if (val.isNotEmpty && val.length < 25) {
                        setState(() {
                          widget.potKategorija.naziv = val;
                        });
                      }
                    },
                  ),
                ],
              )),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(top: 5),
              child: RaisedButton(
                onPressed: _pickIcon,
                child: Text('Izaberi ikonu'),
              ),
            ),
            AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _icon != null
                    ? _icon
                    : Icon(
                        IconData(widget.potKategorija.icon,
                            fontFamily: 'MaterialIcons'),
                      )),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: _openColorPicker,
                child: const Text('Izaberi boju'),
              ),
            ),
            AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: Container(
                    height: 30,
                    width: 30,
                    color: mainColor == null
                        ? widget.potKategorija.bojaIkone
                        : mainColor)),
            Container(
              height: 50,
              width: 200,
              margin: EdgeInsets.only(top: 50),
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.save,
                          size: 35,
                          color: Colors.deepPurple,
                        )),
                    Text(
                      'Sačuvaj',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ],
                ),
                onPressed: () {
                  if (mainColor != null) {
                    if (_nazivController.text.length < 25) {
                      widget.potKategorija.naziv = _nazivController.text;
                    } else {
                      //throw error
                    }
                    widget.potKategorija.naziv = _nazivController.text;
                    widget.potKategorija.bojaIkone = mainColor;
                    Provider.of<SubcategoryNotifier>(context, listen: false)
                        .snimiPromjene(
                      widget.potKategorija.idPot,
                      widget.potKategorija.naziv,
                      widget.potKategorija.bojaIkone,
                      widget.potKategorija.icon.toString(),
                    );
                  } else {
                    if (_nazivController.text.length < 25) {
                      widget.potKategorija.naziv = _nazivController.text;
                    } else {
                      //throw error
                    }
                    Provider.of<SubcategoryNotifier>(context, listen: false)
                        .snimiPromjene(
                      widget.potKategorija.idPot,
                      widget.potKategorija.naziv,
                      widget.potKategorija.bojaIkone,
                      widget.potKategorija.icon.toString(),
                    );
                  }

                  Navigator.of(context).pop();
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
