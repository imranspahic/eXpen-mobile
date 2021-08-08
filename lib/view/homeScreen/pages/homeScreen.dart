import 'package:expen/models/Category.dart';
import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/services/dialogServices/showDialogService.dart';
import 'package:expen/view/drawerScreen/pages/drawer.dart';
import 'package:expen/view/homeScreen/widgets/categoryTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/homeScreen/widgets/homeScreenAppBar.dart';
import 'package:expen/providers/categoryNotifier.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final CategoryNotifier categoryNotifier =
        Provider.of<CategoryNotifier>(context);

    final profileNotifier = Provider.of<ProfileNotifier>(context);

    print("ACCES TOKEN = ${profileNotifier.userData["accessToken"]}");

    return Scaffold(
      key: _scaffoldKey,
      drawer: ExpenDrawer(),
      appBar: homeScreenAppBar(
        context,
        _scaffoldKey,
      ),
      body: ReorderableListView(
        children: categoryNotifier.kategorijaLista
            .map((item) => Container(
                height: 320,
                key: Key(item.id),
                child: CategoryTile(item)))
            .toList(),
        onReorder: (start, current) {
          List<Category> _list = categoryNotifier.kategorijaLista;
          if (current >= _list.length) {
            current = _list.length - 1;
          }
          if (start < current) {
            //unijeti current kao redni broj u bazu
            categoryNotifier.updateRedniBrojKategorije(
                start + 1, categoryNotifier.kategorijaLista[current].id);
            categoryNotifier.updateRedniBrojKategorije(
                current + 1, categoryNotifier.kategorijaLista[start].id);
            print('start index: $start');
            print('current index $current');
            int end = current;
            Category startItem = _list[start];
            int i = 0;
            int local = start;
            do {
              _list[local] = _list[++local];
              i++;
            } while (i < end - start);
            _list[end] = startItem;
          }
          // dragging from bottom to top
          //unijeti current +1 kao redni broj u bazu
          else if (start > current) {
            categoryNotifier.updateRedniBrojKategorije(
                start + 1, categoryNotifier.kategorijaLista[current].id);
            categoryNotifier.updateRedniBrojKategorije(
                current + 1, categoryNotifier.kategorijaLista[start].id);
            print('start index: $start');
            print('current index: $current');
            Category startItem = _list[start];
            for (int i = start; i > current; i--) {
              _list[i] = _list[i - 1];
            }
            _list[current] = startItem;
          }

          setState(() {});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            ShowDialogService.addCategoryDialog(context, _scaffoldKey),
      ),
    );
  }
}
