import 'package:mppo_app/etc/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Класс для обработки сырых данных потока и вывода информации для конкретного пользователя (user)
class GetValues {
  final List _users;
  final User _user;

  GetValues({required List<dynamic> users, required User user})
      : _user = user,
        _users = users;

  CustomUser? getUser() {
    for (var i in _users) {
      if (i.id == _user.email) {
        return i.data();
      }
    }
    return null;
  }
}
