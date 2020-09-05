import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/obavijesti_provider.dart';

class ObavijestiEkran extends StatefulWidget {
  @override
  _ObavijestiEkranState createState() => _ObavijestiEkranState();
}

class _ObavijestiEkranState extends State<ObavijestiEkran> {
  Future obavijestiFuture;

  @override
  void initState() {
    obavijestiFuture = Provider.of<ObavijestiLista>(context, listen:false).fetchAndSetObavijesti();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final obavijestiData = Provider.of<ObavijestiLista>(context);
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
              builder: (ctx, snapshot) => ListView.builder(
                itemCount: obavijestiData.listaSvihObavijesti.length,
                itemBuilder: (ctx, index) {
                  return ObavijestWidget(
                      obavijest: obavijestiData.listaSvihObavijesti[index]);
                },
              ),
            )),
        )
      );
     
    
  }
}

class ObavijestWidget extends StatelessWidget {
  final Obavijest obavijest;
  ObavijestWidget({this.obavijest});
  @override
  Widget build(BuildContext context) {
    return Card( child:
       Container(
         decoration: BoxDecoration(border: Border.all(color: Colors.cyan, width:1), borderRadius: BorderRadius.circular(10)),
         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
         child: Text(obavijest.sadrzaj)),
      
      
    );
  }
}