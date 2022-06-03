import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendSalonRegstrationThanksMail({
  fullName,
  text,
}) async {
  try {
    await FirebaseFunctions.instance
        .httpsCallable('sendSalonRegistrationThanksMail')
        .call({
      'mail': FirebaseAuth.instance.currentUser?.email,
      'fullName': fullName,
      'text': text
    });
  } on FirebaseFunctionsException catch (e) {
    print(e);
  }
}
