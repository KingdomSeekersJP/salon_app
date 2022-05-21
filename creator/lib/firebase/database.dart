import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creator/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DbHandlerAbstract {
  Future updateUser(UserModel userModel);
}

class DbHandler implements DbHandlerAbstract {
  static final String usersColletion = 'users';
  static final String salonsCollection = 'salons';

  var userCollectionRef;
  var salonCollectionRef;

  DbHandler() {
    userCollectionRef = FirebaseFirestore.instance.collection(usersColletion);
    salonCollectionRef =
        FirebaseFirestore.instance.collection(salonsCollection);
  }

  @override
  Future updateUser(UserModel userModel) async =>
      await userCollectionRef.doc(userModel.email).update(userModel.toMap());

  Future addUser(UserModel userModel) async =>
      await userCollectionRef.doc(userModel.email).set(userModel.toMap());

  Future getUser(String email) async {
    var dbObject = await userCollectionRef.doc(email).get();
    return dbObject = UserModel.fromMap(dbObject.data());
  }

  Future<DocumentSnapshot> getUserDoc(String email) async {
    return await userCollectionRef.doc(email).get();
  }

  Future listSalonsByOwner(String email) async {
    return await salonCollectionRef.where('owner', isEqualTo: email).get();
  }
}
