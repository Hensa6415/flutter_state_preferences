class User {
  final String name;
  final String email;
  final bool isLoggedIn;

  User({
    required this.name,
    required this.email,
    this.isLoggedIn = false,
  });

  User copyWith({
    String? name,
    String? email,
    bool? isLoggedIn,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}