import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  Future<bool> addUser({
    required String userId,
    required String firstname,
    required String lastname,
    required String email,
    required String mobilenumber,
    required String password,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      String hashedPassword = _hashPassword(password);

      await users.doc(userId).set({
        'user_id': userId,
        'email': email,
        'first_name': firstname,
        'last_name': lastname,
        'mobile_number': mobilenumber,
        'password': hashedPassword, // Storing hashed password
      });

      return true; // Successfully added the user
    } catch (e) {
      print('Error adding user: ${e.toString()}');
      return false;
    }
  }

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Data being hashed
    return sha256.convert(bytes).toString();
  }
}
