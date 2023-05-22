import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';

import '../db/app_dataBase.dart';

class AppController extends GetxController {
  // static AppDataBase sqldatabse = AppDataBase(
  //   username: "postgres",
  //   password: "admin123@",
  //   host: "10.0.2.2",
  //   port: 5432,
  //   //name: "sharek_app_database",
  //   name: "postgres",
  // );

  PostgreSQLConnection? databaseConnection;

  Future<void> initConnection() async {
    databaseConnection = PostgreSQLConnection(
      '10.0.2.2',
      5432,
      'sharek_app_database',
      queryTimeoutInSeconds: 3600,
      timeoutInSeconds: 3600,
      username: 'postgres',
      password: 'admin123@',
    );

    try {
      await databaseConnection!.open();
      Fluttertoast.showToast(msg: "dataBase connected ");
    } catch (e) {
      Fluttertoast.showToast(msg: "dataBase not connected ");
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
      print("\n-------------------------------------------\n${e.toString()}\n");
    }
  }

  Future<void> read() async {
    try {
      //var result = await databaseConnection!.query("SELECT * FROM Post");

      var result = await databaseConnection!.query('''
            SELECT table_name
            FROM information_schema.tables
            WHERE table_schema = 'sharek_app_database';

            ''');
      print("\n\nresult is => $result\n\n");
      Fluttertoast.showToast(
          msg: result.toString(), toastLength: Toast.LENGTH_LONG);
      for (var element in result) {
        print("\n--------------\n$element");
      }
    } catch (e) {
      print("\n\n${e.toString()}");
    }
  }
}
