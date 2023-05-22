// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:postgres/postgres.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppDataBase {
  String username;
  String password;
  String host;
  int port;
  String name;
  PostgreSQLConnection? _databaseConnection;

  AppDataBase({
    required this.username,
    required this.password,
    required this.host,
    required this.port,
    required this.name,
  }) {
    makeConnection();
    initConnection();
  }

  void makeConnection() {
    try {
      _databaseConnection = PostgreSQLConnection(
        host,
        port,
        name,
        queryTimeoutInSeconds: 3600,
        timeoutInSeconds: 3600,
        username: username,
        password: password,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<int> initConnection() async {
    try {
      await _databaseConnection!.open();
      Fluttertoast.showToast(msg: "dataBase connected ");
      return 1;
    } catch (e) {
      Fluttertoast.showToast(msg: "dataBase not connected ");
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
      print("\n-------------------------------------------\n${e.toString()}\n");
      return -1;
    }
  }

  Future<List<List<dynamic>>> readData(String sql) async {
    List<List<dynamic>> result = [
      ["nothing"]
    ];
    result.clear();

    try {
      result = await _databaseConnection!.query(sql);
      return result;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), toastLength: Toast.LENGTH_LONG);
      print("\n-------------------------------------------\n${e.toString()}\n");
      return result;
    }
  }
}
