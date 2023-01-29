class User {
  String email;
  String firstName;
  String lastName;
  String phoneNumber;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber = '',
  });
}
