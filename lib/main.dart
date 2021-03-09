import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/providers/expenseNotifier.dart';
import 'package:expen/providers/settingsNotifier.dart';
import 'package:expen/providers/subcategoryNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expen/view/sifra_ekran.dart';
import 'providers/notesNotifier.dart';
import 'providers/notificationNotifier.dart';
import 'providers/salaryNotifier.dart';
import 'providers/expenseCategoryNotifier.dart';
import 'package:expen/providers/categoryNotifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CategoryNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ExpenseNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SubcategoryNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SettingsNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NoteNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SalaryNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ExpenseCategoryNotifier(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileNotifier(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'eXpen',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            accentColor: Colors.brown,
            textTheme: ThemeData.light().textTheme.copyWith(
                headline2: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6),
                headline6:
                    TextStyle(fontSize: 30, fontFamily: 'RobotoCondensed'),
                subtitle2: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Raleway',
                  color: Colors.orangeAccent[100],
                ),
                caption: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Lato',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                subtitle1: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                button: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Raleway',
                    color: Colors.brown[900],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0),
                headline5: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    color: Colors.brown[700],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0))),
        routes: {
          '/': (ctx) => SifraEkran(),
        },
      ),
    );
  }
}
