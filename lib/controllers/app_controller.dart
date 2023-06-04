import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

class AppController extends GetxController {
  // --------------DataBase---------------//
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
  //-------------------------------------//

  // --------------TextFields---------------//
  bool checkFields(List<TextEditingController> fields) {
    for (var field in fields) {
      if (field.text.isEmpty) {
        return false;
      }
    }
    return true;
  }
  //-------------------------------------//

  // --------------Current User Info---------------//

  var currentUserEmail =
      "".obs; //this will be filled after a successful registarion/ login

  var customersPosts = [Container()].obs;
  var driverPosts = [Container()].obs;
  Future<void> getAllCustomersPosts() async {

    //Now get the posts from DB
    var result = await AppDatabase().getAllCustomersPosts();
    
    //fill Containers with info
    



  }

  //-------------------------------------//

  // --------------  Home page Controller---------------//
  var pageindex = 0.obs;
  //-------------------------------------//
}
