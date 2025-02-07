class CustomUser {
  String username;
  String email;
  List<dynamic> items;

  CustomUser({required this.username, required this.email, required this.items});

  CustomUser.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          email: json['email']! as String,
          items: json['items']! as List,
        );

  CustomUser copyWith({
    String? username,
    String? email,
    List? items,
  }) {
    return CustomUser(
      username: username ?? this.username,
      email: email ?? this.email,
      items: items ?? this.items,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "username": username,
      "email": email,
      "items": items,
    };
  }
}
