import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:sharek_app_new/db/app_database_new.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppController extends GetxController {
  List<String> listOfCities = [
    "Girne",
    "Güzelyurt",
    "Kalkanlı",
    "Lefke",
    "Lefkoşa",
    "Mağusa",
    "Kalkanli",
  ];

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
  var busCompnaies = [Container()].obs;
  var driverVehicles = [Container()].obs;
  var availableDrivers = [Container()].obs;

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

  Future<void> getFilteredCustomersPosts(
      String pessengersRange, String from, String to) async {
    customersPosts.clear();
    List<List<dynamic>> filtredPosts = await AppDatabase()
        .getFilteredCustomersPosts(pessengersRange, from, to);

    numberOfCustomersPosts.value = filtredPosts.length;

    for (int i = 0; i < filtredPosts.length; i++) {
      if (filtredPosts[i][10] != currentCustomerId) {
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
                      msg: filtredPosts[i][2].toString(),
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
                      msg: "Plate Number: ${filtredPosts[i][4]}",
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
                          AppDatabase().deleteCustoner(filtredPosts[i][0]);
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
                Text(filtredPosts[i][3].toString().substring(0, 10)),
                Spacer(),
                const Text(
                  "Trip Date:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(filtredPosts[i][1].toString().substring(0, 10)),
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
                Text(filtredPosts[i][6].toString()),
                const Text(
                  "To:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(filtredPosts[i][5].toString()),
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
                Text(filtredPosts[i][8].toString()),
                Spacer(),
                const Text(
                  "shared:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(filtredPosts[i][9].toString() == "true" ? "yes" : "no"),
                Spacer(),
                const Text(
                  "number of customers:  ",
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(filtredPosts[i][7].toString()),
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

  Future<void> getAllBusCompanies() async {
    busCompnaies.clear();
    List<List<dynamic>> busCompaniesResult =
        await AppDatabase().getAllBusCompanies();

    for (int i = 0; i < busCompaniesResult.length; i++) {
      busCompnaies.add(Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.orange,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Company_name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                busCompaniesResult[i][0],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "City",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                busCompaniesResult[i][1],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "phone_number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                busCompaniesResult[i][2],
              ),
              const SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  launchUrlString("tel://${busCompaniesResult[i][2]}");
                },
                icon: const Icon(Icons.call),
                color: Colors.green,
              )
            ],
          ),
        ]),
      ));
      busCompnaies.add(
        Container(
          child: const SizedBox(
            height: 50,
            child: Divider(
              color: Colors.black,
            ),
          ),
        ),
      );
    }
  }

  Future<void> getAllAvailableDrivers() async {
    availableDrivers.clear();
    var availableDriversResult = await AppDatabase().getAllAvailbeDrivers();

    for (List<dynamic> driver in availableDriversResult) {
      availableDrivers.add(
        Container(
          child: Column(children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
              ],
            ),
            Row(
              children: [
                Text("Name:   ", style: driverVehiclesTextStyle),
                Text(driver[2]),
              ],
            ),
            Row(
              children: [
                Text("Phone:   ", style: driverVehiclesTextStyle),
                Text(driver[3]),
              ],
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  launchUrlString("tel://${driver[3]}");
                },
                icon: const Icon(Icons.call),
                color: Colors.green,
              ),
            )
          ]),
        ),
      );
      availableDrivers.add(Container(
        child: const SizedBox(
          height: 50,
        ),
      ));
    }
  }

  TextStyle driverVehiclesTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
    color: Colors.amber,
  );
  Future<void> getCurrentDriverVehicles() async {
    driverVehicles.clear();
    Map<String, List<List<dynamic>>>? plateNumToCar;
    plateNumToCar = await AppDatabase().getdriverVehicles();

    for (var plateNumber in plateNumToCar.keys) {
      var currentCar = plateNumToCar[plateNumber];
      driverVehicles.add(Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            children: [
              Text(
                "platenumber:   ",
                style: driverVehiclesTextStyle,
              ),
              Text(currentCar![0][0]),
            ],
          ),
          Row(
            children: [
              Text(
                "Capacity:   ",
                style: driverVehiclesTextStyle,
              ),
              Text(currentCar[0][1].toString()),
            ],
          ),
          Row(
            children: [
              Text(
                "model:   ",
                style: driverVehiclesTextStyle,
              ),
              Text(currentCar[0][2]),
            ],
          ),
          Row(
            children: [
              Text(
                "color:   ",
                style: driverVehiclesTextStyle,
              ),
              Text(currentCar[0][3]),
            ],
          ),
          Row(
            children: [
              Text(
                "registration number:   ",
                style: driverVehiclesTextStyle,
              ),
              Text(currentCar[0][4]),
            ],
          ),
        ]),
      ));
      driverVehicles.add(Container(
        child: const SizedBox(
          height: 50,
          child: Divider(
            color: Colors.black,
          ),
        ),
      ));
    }
  }

  //-------------------------------------//

  // --------------  Home page Controller---------------//
  var pageindex = 1.obs;
  final drawerTextSize = 18.0;
  var isCurrentUserDriver = false.obs;
  var filterIsShared = false.obs;
  var filterIsSharedPressed = false.obs;

  //-------------------------------------//

  // --------------  Customers Post pgae Controller---------------//
  var isShared = false.obs;
  //-------------------------------------//
}
