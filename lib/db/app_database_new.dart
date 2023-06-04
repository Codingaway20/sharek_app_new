import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:postgres/postgres.dart';

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

  AppDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
            // for external device like mobile phone use domain.com or
            // your computer machine IP address (i.e,192.168.0.1,etc)
            // when using AVD add this IP 10.0.2.2
            '10.0.2.2',
            //'192.168.0.113',
            //'192.168.23.1',
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
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
      returnStatus = false;
    }
    return returnStatus;
  }

  Future<int> getUserId(String email) async {
    PostgreSQLResult? loggedInUserid;

    try {
      await connection!.open();
      await connection!.transaction((newSellerConn) async {
        loggedInUserid = await newSellerConn.query(
          '''
              select "USER_ID" from "User" where "Email" = '$email'
          ''',
          allowReuse: true,
          timeoutInSeconds: 30,
        );
      });
    } catch (exc) {
      //Fluttertoast.showToast(msg: exc.toString(), textColor: Colors.red);
      print("\n-----------------------${exc.toString()}\n");
    }
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
}
