import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:sharek_app_new/db/app_database_new.dart';

class AppController extends GetxController {
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

  var currentUserEmail = "".obs;
  var currentCustomerId =
      -1.obs; //this will be filled after a successful registarion/ login

  RxMap<int, bool> deletePostButtonVisiblityMap = {-1: false}.obs;
  var numberOfCustomersPosts = 0.obs;

  var customersPosts = [Container()].obs;
  var driverPosts = [Container()].obs;
  Future<void> getAllCustomersPosts() async {
    customersPosts.clear();
    //Now get the posts from DB
    List<List<dynamic>> result = await AppDatabase().getAllCustomersPosts();

    numberOfCustomersPosts.value = result.length;

    for (int i = 0; i < result.length; i++) {
      if (result[i][10] != currentCustomerId) {
        deletePostButtonVisiblityMap[i] = false;
      } else {
        deletePostButtonVisiblityMap[i] = true;
      }
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
                //Delete button
                Obx(
                  () => Visibility(
                    visible: deletePostButtonVisiblityMap[i]!,
                    child: InkWell(
                      onTap: () {
                        Fluttertoast.showToast(
                          msg: "Long press to confirm delete",
                          textColor: Colors.red,
                          gravity: ToastGravity.TOP,
                        );
                      },
                      onLongPress: () async {
                        try {
                          //remove from DB
                          AppDatabase().deleteCustoner(result[i][0]);
                          //Remove from screen
                          customersPosts.removeAt(i);
                          Fluttertoast.showToast(
                            msg: "Post has been removed successfully",
                            textColor: Colors.green,
                            gravity: ToastGravity.CENTER,
                          );
                        } catch (e) {
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            textColor: Colors.red,
                          );
                        }
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
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
          child: const SizedBox(
        height: 20,
      )));
    }
  }

  //-------------------------------------//

  // --------------  Home page Controller---------------//
  var pageindex = 1.obs;
  //-------------------------------------//

  // --------------  Customers Post pgae Controller---------------//
  var isShared = false.obs;

  //-------------------------------------//
}
