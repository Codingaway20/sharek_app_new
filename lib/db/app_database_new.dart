import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'package:sharek_app_new/controllers/app_controller.dart';

import '../classes/user.dart';

class AppDatabase {
  String buyerEmailValue = '';
  String sellerEmailValue = '';
  String passwordValue = '';
  String mobileValue = '';
  String companyNameValue = '';
  String landlineValue = '';
  String fNameValue = '';
  String lNameValue = '';

  PostgreSQLConnection? connection;
  PostgreSQLResult? newSellerRegisterResult, newBuyerRegisterResult;
  PostgreSQLResult? sellerAlreadyRegistered, buyerAlreadyRegistered;

  PostgreSQLResult? Users;

  PostgreSQLResult? loginResult, userRegisteredResult;

  PostgreSQLResult? updateBuyerResult;
  PostgreSQLResult? updateSellerResult;

  static String? sellerEmailAddress, buyerEmailAddress;

  static int numberOfCustomers = 10;

  final AppController _appController = Get.find();

  AppDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
            // for external device like mobile phone use domain.com or
            // your computer machine IP address (i.e,192.168.0.1,etc)
            // when using AVD add this IP 10.0.2.2
            //'10.0.2.2',
            '192.168.0.113',
            //'10.143.14.176', //metu address
            5432,
            'sharek_app_database',
            //username: 'postgres',
            username: 'postgres',
            //password: 'admin123@',
            password: 'admin123@',
            timeoutInSeconds: 30,
            queryTimeoutInSeconds: 30,
            timeZone: 'UTC',
            useSSL: false,
            isUnixSocket: false,
          )
        : connection);
  }

  Future<void> readAllUsersData() async {
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        //Stage 1 : Make sure email or mobile not registered.
        Users = await newSellerConn.query(
          //where Name = @emailValue'
          '''select * from "User"
          ''',
          //substitutionValues: {'emailValue': 'John Doe'},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
      for (var element in Users!) {
        print("\n$element");
      }
    } catch (exc) {
      print("\n---------------------------------------------\n$exc\n\n");
    }
  }

  // Register Database Section
  Future<void> registerUser(User newUser) async {
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        newSellerRegisterResult = await newSellerConn.query(
          '''insert into "User" ("Email","Name","PhonNum","ProfilePic","Customer_flag","Driver_flag","password","available","licence","Last_apperance")'''
          "values('${newUser.email}','${newUser.name}','${newUser.phoneNumber}','${newUser.profilePicture}',${newUser.customerFlag},${newUser.driverFlag},'${newUser.password}', true ,'${newUser.licence}','${newUser.lastApperance}')",
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        numberOfCustomers++;
        Fluttertoast.showToast(
          msg: "Registred successfully!",
          textColor: Colors.green,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
  }

  Future<bool> userLogin(String email, String password) async {
    bool returnStatus = false;

    PostgreSQLResult loggedInUser;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        loggedInUser = await newSellerConn.query(
          '''
              select * from "User" where "Email" = '$email' and "password" = '$password'
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (loggedInUser.isNotEmpty) {
          _appController.isCurrentUserDriver.value = loggedInUser[0][6];

          Fluttertoast.showToast(
            msg: "Login successfully!",
            textColor: Colors.green,
          );
          returnStatus = true;
        } else {
          Fluttertoast.showToast(
            msg: "try again ",
            textColor: Colors.red,
          );
          returnStatus = false;
        }
      });
    } catch (exc) {
      Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);

      returnStatus = false;
    }
    return returnStatus;
  }

  Future<int> getUserId(String email) async {
    PostgreSQLResult? loggedInUserid;

    print("\n\n\nEmail is =>$email");

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        loggedInUserid = await newSellerConn.query(
          '''
              select * from "User" where "Email" = '$email'
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }

    print("\nloggedInUserid =>\n $loggedInUserid");

    if (loggedInUserid == null) {
      return -1;
    } else {
      return loggedInUserid![0][0];
    }
  }

  //getting all customers posts
  Future<List<List<dynamic>>> getAllCustomersPosts() async {
    PostgreSQLResult? customersPosts;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        customersPosts = await newSellerConn.query(
          '''
              select * from "Customer_Post"
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
    if (customersPosts != null) {
      return customersPosts as List<List<dynamic>>;
    } else {
      return [[]];
    }
  }

  //getting filtred customers posts
  Future<List<List<dynamic>>> getFilteredCustomersPosts(
      String pessengersRange, String from, String to) async {
    PostgreSQLResult? filtredCustomersPosts;
    try {
      //and "number_of_custmers" <${int.parse(pessengersRange)}
      //"shared_option" = ${_appController.filterIsShared}
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        filtredCustomersPosts = await newSellerConn.query(
          '''
              select * from "Customer_Post" where "city_from" = '$from' and "city_to" = '$to' and "shared_option" = ${_appController.filterIsShared} and "number_of_custmers" <${int.parse(pessengersRange)} 
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
    if (filtredCustomersPosts != null) {
      print("filtredCustomersPosts\n$filtredCustomersPosts");
      return filtredCustomersPosts as List<List<dynamic>>;
    } else {
      return [[]];
    }
  }

  //getting all bus Companies info
  Future<List<List<dynamic>>> getAllBusCompanies() async {
    PostgreSQLResult? busCompanies;
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        busCompanies = await newSellerConn.query(
          '''
              select * from "Bus Company Location"
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
    if (busCompanies != null) {
      return busCompanies as List<List<dynamic>>;
    } else {
      return [[]];
    }
  }

  //getting all available drivers
  Future<List<List<dynamic>>> getAllAvailbeDrivers() async {
    PostgreSQLResult? availableDrivers;
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        availableDrivers = await newSellerConn.query(
          '''
              select * from "User" where "Driver_flag" = true and "available" = true
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
    if (availableDrivers != null) {
      return availableDrivers as List<List<dynamic>>;
    } else {
      return [[]];
    }
  }

  //getting all driverVehicles
  Future<Map<String, List<List<dynamic>>>> getdriverVehicles() async {
    PostgreSQLResult? driverRelatedPlateNumbers;
    PostgreSQLResult? driverVehicles;

    Map<String, List<List<dynamic>>> PlateToVhicle = {};

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        driverRelatedPlateNumbers = await newSellerConn.query(
          '''
              select "PlateNumber" from "Driver_Vehicle" where "Driver_ID" = ${_appController.currentCustomerId}
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        if (driverRelatedPlateNumbers != null) {
          for (int i = 0; i < driverRelatedPlateNumbers!.length; i++) {
            driverVehicles = await newSellerConn.query(
              '''
              select * from "Vehicle" where "platenumber" = '${driverRelatedPlateNumbers![i][0]}'
              ''',
              allowReuse: true,
              timeoutInSeconds: 30,
            );
            PlateToVhicle[driverRelatedPlateNumbers![i][0]] = driverVehicles!;
          }
        }
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
    return PlateToVhicle;
  }

  //create new Customer post
  Future<void> createNewCustomerPost(
      DateTime trip_date,
      String note,
      DateTime post_date,
      String city_to,
      String city_from,
      int number_of_customers,
      int price,
      bool shared_option,
      int CUSTOMER_ID) async {
    bool returnStatus = false;
    PostgreSQLResult newPost;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        newPost = await newSellerConn.query(
          '''insert into "Customer_Post" ("Post_ID","trip_date","note","post_date","city_to","city_from","number_of_custmers","price","shared_option","CUSTOMER_ID")'''
          "values(${_appController.numberOfCustomersPosts.value++},'$trip_date','$note','$post_date','$city_to','$city_from',$number_of_customers,$price,$shared_option,$CUSTOMER_ID)",
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        Fluttertoast.showToast(
          msg: "Post Created , see feeds ",
          textColor: Colors.green,
        );
      });
    } catch (exc) {
      print("\n\nerror creating post\n${exc.toString()}");
      Fluttertoast.showToast(
        msg: exc.toString(),
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  //delete custoner given ID
  Future<void> deleteCustoner(int postID) async {
    PostgreSQLResult? deletedCustomer;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        deletedCustomer = await newSellerConn.query(
          '''
              delete from "Customer_Post" where "Post_ID" = $postID
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
  }

  //add new car
  Future<void> createNewVehicle(String plateNumber, int capacity, String model,
      String color, String registrationNumber) async {
    bool returnStatus = false;
    PostgreSQLResult newCar;
    PostgreSQLResult newCar_Driver;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        newCar = await newSellerConn.query(
          '''insert into "Vehicle" ("platenumber","Capacity","model","color","registration number")'''
          "values('$plateNumber',$capacity,'$model','$color','$registrationNumber')",
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        newCar_Driver = await newSellerConn.query(
          '''insert into "Driver_Vehicle" ("Driver_ID","PlateNumber")'''
          "values(${_appController.currentCustomerId},'$plateNumber')",
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        Fluttertoast.showToast(
          msg: "Vehicle added ",
          textColor: Colors.green,
        );
      });
    } catch (exc) {
      print("\n\nerror adding  Vehicle\n${exc.toString()}");
      Fluttertoast.showToast(
        msg: exc.toString(),
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  // ///add new Bus Company
  // Future<void> addNewBusCompany(String companyName) async {
  //   PostgreSQLResult newBusCompany;
  //   try {
  //     await connection!.open();
  //     await connection!.transaction((newSellerConn) async {
  //       newBusCompany = await newSellerConn.query(
  //         '''insert into "Bus Company" ("name")'''
  //         "values('$companyName')",
  //         allowReuse: true,
  //         timeoutInSeconds: 30,
  //       );

  //       Fluttertoast.showToast(
  //         msg: "company  added ",
  //         textColor: Colors.green,
  //       );
  //     });
  //   } catch (exc) {
  //     print("\n\nerror adding  company\n${exc.toString()}");
  //     Fluttertoast.showToast(
  //       msg: exc.toString(),
  //       textColor: Colors.red,
  //       gravity: ToastGravity.CENTER,
  //       toastLength: Toast.LENGTH_LONG,
  //     );
  //   }
  // }

  //Update username
  Future<void> updateUsername(String userName) async {
    //await conn.execute('UPDATE your_table SET column1 = value1, column2 = value2 WHERE condition');
    PostgreSQLResult updateResult;
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        updateResult = await newSellerConn.query(
          '''
            update "User" set "Name" = '$userName' where "USER_ID" = ${_appController.currentCustomerId}
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        Fluttertoast.showToast(
          msg: "name Updated",
          textColor: Colors.green,
        );
      });
    } catch (exc) {
      print("\n\nerror updating   username\n${exc.toString()}");
      Fluttertoast.showToast(
        msg: exc.toString(),
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  //Update phone number
  Future<void> updatePhoneNumber(String phoneNumber) async {
    //await conn.execute('UPDATE your_table SET column1 = value1, column2 = value2 WHERE condition');
    PostgreSQLResult updateResult;
    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        updateResult = await newSellerConn.query(
          '''
            update "User" set "PhonNum" = '$phoneNumber' where "USER_ID" = ${_appController.currentCustomerId}
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );

        Fluttertoast.showToast(
          msg: "phoneNumber Updated ",
          textColor: Colors.green,
        );
      });
    } catch (exc) {
      print("\n\nerror updating phoneNumber\n${exc.toString()}");
      Fluttertoast.showToast(
        msg: exc.toString(),
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
