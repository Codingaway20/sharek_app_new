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
    customersPosts.clear();
    //Now get the posts from DB
    List<List<dynamic>> result = await AppDatabase().getAllCustomersPosts();

    for (int i = 0; i < result.length; i++) {
      //fill Containers with info
      customersPosts.add(Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //info like notes and plate number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Notes
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: result[i][2].toString(),
                      fontSize: 17,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.amber,
                    );
                  },
                  icon: const Icon(
                    Icons.note,
                    color: Colors.amber,
                  ),
                ),
                //Plate Number
                IconButton(
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Plate Number: ${result[i][4]}",
                      fontSize: 17,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.amber,
                    );
                  },
                  icon: const Icon(
                    Icons.info_rounded,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            //dates
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(),
                const Text(
                  "Post Date:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][3].toString().substring(0, 10)),
                Spacer(),
                const Text(
                  "Trip Date:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][1].toString().substring(0, 10)),
                Spacer(),
              ],
            ),
            //city from -city to
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "From:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][6].toString()),
                const Text(
                  "To:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][5].toString()),
              ],
            ),
            //price - shared - number of customers
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Price:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][8].toString()),
                Spacer(),
                const Text(
                  "shared:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][9].toString() == "true" ? "yes" : "no"),
                Spacer(),
                const Text(
                  "number of customers:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(result[i][7].toString()),
                Spacer(),
              ],
            ),
          ],
        ),
      ));
      customersPosts.add(Container(
        child: const Divider(
          height: 4,
          color: Colors.black,
          thickness: 2,
        ),
      ));
      customersPosts.add(Container(
        child: Spacer(),
      ));
    }
  }

  //-------------------------------------//

  // --------------  Home page Controller---------------//
  var pageindex = 0.obs;
  //-------------------------------------//
}
