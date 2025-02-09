class CustomUser {
  String username;
  String email;
  List<dynamic> items;
  List<dynamic> history;
  List<dynamic> buyingList;

  CustomUser(
      {required this.username,
      required this.email,
      required this.items,
      required this.history,
      required this.buyingList});

  CustomUser.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          email: json['email']! as String,
          items: json['items']! as List,
          history: json['history']! as List,
          buyingList: json['buyingList']! as List,
        );

  CustomUser copyWith({String? username, String? email, List? items, List? history, List? buyingList}) {
    return CustomUser(
      username: username ?? this.username,
      email: email ?? this.email,
      items: items ?? this.items,
      history: history ?? this.history,
      buyingList: buyingList ?? this.buyingList,
    );
  }

  Map<String, Object?> toJson() {
    return {
      "username": username,
      "email": email,
      "items": items,
      "history": history,
      "buyingList": buyingList,
    };
  }
}
