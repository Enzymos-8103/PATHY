class User {
  final String FirstName;
  final String LastName;
  final String UserName;
  final String gmail;
  final String password;
  final int points;

  // Constructor
  User({
    required this.FirstName,
    required this.LastName,
    required this.UserName,
    required this.gmail,
    required this.password,
    required this.points,
  });

  // Factory constructor to create a User from JSON (Map)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      FirstName: json['FirstName'] as String,
      LastName: json['LastName'] as String,
      UserName: json['UserName'] as String,
      gmail: json['gmail'] as String,
      password: json['password'] as String,
      points: json['points'] as int,


    );
  }

  // Convert a User to JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'FirstName': FirstName,
      'LastName': LastName,
      'UserName': UserName,
      'gmail': gmail,
      'password': password,
      'points': points,
    };
  }
}
