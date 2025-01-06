class CustomUser {
  String username;
  String email;

  CustomUser({required this.username, required this.email});

  CustomUser.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          email: json['email']! as String,
        );

  CustomUser copyWith({
    String? username,
    String? email,
  }) {
    return CustomUser(username: username ?? this.username, email: email ?? this.email);
  }

  Map<String, Object?> toJson() {
    return {
      "username": username,
      "email": email,
    };
  }
}
