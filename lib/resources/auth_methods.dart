
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netwealth_vjti/models/professional.dart' as model;
import 'package:netwealth_vjti/resources/storage_methods.dart';


class AuthMethods{
 final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<model.Professional> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.Professional.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Uint8List file,
    required String jurisdiction,
    required int yearsExperience,
    required List<String> financialStandards,
    required List<String> industryFocus,
    required List<String> regulatoryExpertise,
    required String role,
    required List<String> technicalSkills,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && 
          password.isNotEmpty && 
          name.isNotEmpty && 
          phone.isNotEmpty && 
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
        
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.Professional user = model.Professional(
          id: cred.user!.uid,
          name: name,
          email: email,
          jurisdiction: jurisdiction,
          photoUrl: photoUrl,
          yearsExperience: yearsExperience,
          financialStandards: financialStandards,
          industryFocus: industryFocus,
          phone: phone,
          regulatoryExpertise: regulatoryExpertise,
          role: role,
          technicalSkills: technicalSkills,
          
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      } 
    } on FirebaseAuthException catch(err) {
      if (err.code == 'invalid-email') {
        res = 'The email is invalid';
      }
      if (err.code == 'weak-password') {
        res = 'Password is weak';
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }
  //logging in
  Future<String> loginUser({
    required String email,
    required String password
  })async{
    String res = 'Some error occured';
    try{
      if(email.isNotEmpty || password.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
      else{
        res = 'Please enter all details';
      }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }
  
  Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}


}