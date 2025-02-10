import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

// апи для работы с аунтефикацией
// Реализованы основные функции аунтефикации

// Формат выходных данных - список, где 0 эл. - код ошибки (0 - успешно, 1 - есть ошибка)

class AuthService {
  final _auth = FirebaseAuth.instance;

  // Регистрация
  // Входные данные: е-маил, пароль
  // Выходные данные: либо [0 и инстанс пользователя], либо [1 и описание ошибки]
  Future<List?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return [0, cred.user];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return [1, 'format'];
      } else if (e.code == 'email-already-in-use') {
        return [1, 'exists'];
      } else if (e.code == 'weak-password') {
        return [1, 'weak'];
      }
    }
    return [1, 'unknown'];
  }

  // Логин
  // Входные данные: е-маил, пароль
  // Выходные данные: либо [0 и инстанс пользователя], либо [1 и описание ошибки]
  Future<List> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return [0, cred.user];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return [1, 'format'];
      } else if (e.code == 'user-not-found') {
        return [1, 'not_found'];
      } else if (e.code == 'wrong-password') {
        return [1, 'wrong'];
      } else if (e.code == 'invalid-credential') {
        return [1, 'wrong_or_not_found'];
      }
    }
    return [1, 'unknown'];
  }

  // Выход из сессии
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Ошибка $e");
    }
  }

  // Выслать письмо для верификации
  Future<void> sendVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      log("Ошибка $e");
    }
  }

  // Смена пароля
  // Входные данные: е-маил, текущий пароль, новый пароль
  // Выходные данные: либо [0], либо [1 и описание ошибки]
  Future<List> changePassword(String email, String currentPassword, String newPassword) async {
    try {
      User user = _auth.currentUser!;
      AuthCredential cred = EmailAuthProvider.credential(email: email, password: currentPassword);
      final result = await user.reauthenticateWithCredential(cred);
      result.user!.updatePassword(newPassword);
      return [0];
    } on FirebaseAuthException catch (e) {
      log("Ошибка $e");
    }
    return [1, 'unknown'];
  }

  // Удаление аккаунта
  // Входные данные: е-маил, текущий пароль
  // Выходные данные: либо [0], либо [1 и описание ошибки]
  Future<List> deleteAccount(String email, String password, bool check) async {
    try {
      User user = _auth.currentUser!;
      AuthCredential cred = EmailAuthProvider.credential(email: email, password: password);
      final result = await user.reauthenticateWithCredential(cred);
      if (check) await result.user!.delete();
      return [0];
    } on FirebaseAuthException catch (e) {
      log("Ошибка $e");
    }
    return [1, 'unknown'];
  }

  // Сброс пароля (восстановление по почте)
  // Входные данные: е-маил
  // Выходные данные: либо [0], либо [1 и описание ошибки]
  Future<List> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return [0];
    } on FirebaseAuthException catch (e) {
      if (e.toString() == "auth/invalid-email") return [1, 'format'];
    }
    return [1, 'unknown'];
  }
}
