import 'package:mppo_app/etc/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String databasePath = 'users';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  // В конструкоре класса создается референс к базе данных
  // Который автоматически обрабатывает входные и выходные данные
  DatabaseService() {
    _usersRef = _firestore.collection(databasePath).withConverter<CustomUser>(
        fromFirestore: (snapshots, _) => CustomUser.fromJson(snapshots.data()!),
        toFirestore: (user, _) => user.toJson());
  }

  // Получить данные (Stream)
  // Нужен только для init state (ради оптимизации)
  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  // Добавить в базу данных пользователя
  // Входные данные: используется инстанс класса CustomUser с заполненными данными
  Future<void> addUser(CustomUser user) async {
    await _usersRef.doc(user.email).set(user);
  }

  // Обновление данных (используются все параметры пользователя)
  // Входные данные: используется инстанс класса CustomUser c теми
  // заполненными данными, которые вы хотите изменить
  Future<void> updateUser(CustomUser user) async {
    await _usersRef.doc(user.email).update(user.toJson());
  }

  // Удаление пользователя из базы данных
  // Входные данные: почта аккаунта
  Future<void> deleteUser(String email) async {
    await _usersRef.doc(email).delete();
  }
}
