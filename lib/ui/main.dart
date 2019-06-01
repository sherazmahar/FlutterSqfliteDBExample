import 'package:flutter/material.dart';
import 'package:sqflite_app/database/appdatabaseinfo.dart';
import 'package:sqflite_app/database/dbInformer.dart';
import 'package:sqflite_app/database/dbhelper.dart';
import 'package:sqflite_app/ui/usersscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements DBInformer {
  var isErrorWhileCreatingDB = false;

  @override
  void initState() {
    super.initState();
    DBHelper.dbHelper.openDB(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: splashView(),
    );
  }

  @override
  void onDBCreated() {
    DBHelper.dbHelper.init(AppDatabaseInfo()).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UsersScreen()));
    }).catchError((error) {
      setState(() {
        isErrorWhileCreatingDB = true;
      });
      print('error while creating tables: ' + error.toString());
    });
  }

  Widget splashView() {
    if (isErrorWhileCreatingDB) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Center(
            child: Text(
                'There is some error in Database, \nplease restart the application')),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}

