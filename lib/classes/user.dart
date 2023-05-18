// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  int userId;
  String email;
  String name;
  String phoneNumber;
  String profilePicture;
  bool available;
  String licence;
  String lastApperance;
  bool driverFlag;
  bool customerFlag;
  User({
    required this.userId,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.available,
    required this.licence,
    required this.lastApperance,
    required this.driverFlag,
    required this.customerFlag,
  });
}
