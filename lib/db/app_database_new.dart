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
          Fluttertoast.showToast(
            msg: "Login successfully!",
            textColor: Colors.green,
          );
          returnStatus = true;
        } else {
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
}
