
// // import 'package:flutter/material.dart';
// // import 'package:netwealth_vjti/models/professional.dart';
// // import 'package:netwealth_vjti/resources/auth_methods.dart';

// // // class UserProvider with ChangeNotifier {
// // //   User? _user;
// // //   final AuthMethods _authMethods = AuthMethods();

// // //   // Getter for user
// // //   User? get getUser => _user;

// // //   Future<void> refreshUser([User? updatedUser]) async {
// // //     if (updatedUser != null) {
// // //       // If user object is provided, use it directly
// // //       _user = updatedUser;
// // //     } else {
// // //       // If no user object provided, fetch from AuthMethods
// // //       _user = await _authMethods.getUserDetails();
// // //     }
// // //     notifyListeners();
// // //   }

// // //   // Method to refresh user from AuthMethods
// // //   Future<void> refreshUserFromAuth() async {
// // //     User user = await _authMethods.getUserDetails();
// // //     _user = user;
// // //     notifyListeners();
// // //   }
// // // }

// // class UserProvider with ChangeNotifier {
// //   Professional? _user;
// //   final AuthMethods _authMethods = AuthMethods();

// //   // Getter for user
// //   Professional? get getUser => _user;

// //    void updateUser(Professional updatedUser) {
// //     _user = updatedUser;
// //     notifyListeners();
// //   }

// //   Future<void> refreshUser([Professional? updatedUser]) async {
// //     if (updatedUser != null) {
// //       // If user object is provided, use it directly
// //       _user = updatedUser;
// //     } else {
// //       // If no user object provided, fetch from AuthMethods
// //       _user = await _authMethods.getUserDetails();
// //     }
// //     notifyListeners();
// //   }

// //   // Method to refresh user from AuthMethods
// //   Future<void> refreshUserFromAuth() async {
// //     Professional user = await _authMethods.getUserDetails();
// //     _user = user;
// //     notifyListeners();
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:netwealth_vjti/models/professional.dart';
// import 'package:netwealth_vjti/resources/auth_methods.dart';

// class UserProvider with ChangeNotifier {
//   Professional? _user;
//   final AuthMethods _authMethods = AuthMethods();

//   Professional? get getUser => _user;

//   Future<void> refreshUser([Professional? updatedUser]) async {
//     try {
//       if (updatedUser != null) {
//         _user = updatedUser;
//       } else {
//         _user = await _authMethods.getUserDetails();
//       }
//       notifyListeners();
//     } catch (e) {
//       print('Error in refreshUser: $e');
//       _user = null;
//       notifyListeners();
//     }
//   }

//   Future<void> refreshUserFromAuth() async {
//     try {
//       _user = await _authMethods.getUserDetails();
//       notifyListeners();
//     } catch (e) {
//       print('Error in refreshUserFromAuth: $e');
//       _user = null;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  Professional? _user;
  final AuthMethods _authMethods = AuthMethods();

  Professional? get getUser => _user;

  // Initialize user
  Future<void> initialize() async {
    try {
      await refreshUserFromAuth();
    } catch (e) {
      print('Error initializing user provider: $e');
    }
  }

  // Update user with validation
  Future<void> updateUser(Professional updatedUser) async {
    try {
      // Validate that required fields are not null
      if (updatedUser.name == null || 
          updatedUser.jurisdiction == null || 
          updatedUser.yearsExperience == null) {
        throw Exception('Required fields cannot be null');
      }

      // Create a new Professional object with validated data
      _user = Professional(
        id: updatedUser.id ?? _user?.id,
        name: updatedUser.name,
        email: updatedUser.email ?? _user?.email,
        phone: updatedUser.phone ?? _user?.phone,
        role: updatedUser.role,
        technicalSkills: updatedUser.technicalSkills.isNotEmpty 
            ? updatedUser.technicalSkills 
            : _user?.technicalSkills ?? [],
        regulatoryExpertise: updatedUser.regulatoryExpertise.isNotEmpty 
            ? updatedUser.regulatoryExpertise 
            : _user?.regulatoryExpertise ?? [],
        financialStandards: updatedUser.financialStandards.isNotEmpty 
            ? updatedUser.financialStandards 
            : _user?.financialStandards ?? [],
        industryFocus: updatedUser.industryFocus.isNotEmpty 
            ? updatedUser.industryFocus 
            : _user?.industryFocus ?? [],
        jurisdiction: updatedUser.jurisdiction,
        yearsExperience: updatedUser.yearsExperience,
        photoUrl: updatedUser.photoUrl ?? _user?.photoUrl
      );

      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Refresh user with provided data or fetch from auth
  Future<void> refreshUser([Professional? updatedUser]) async {
    try {
      if (updatedUser != null) {
        await updateUser(updatedUser);
      } else {
        await refreshUserFromAuth();
      }
    } catch (e) {
      print('Error in refreshUser: $e');
      rethrow;
    }
  }

  // Refresh user from authentication
  Future<void> refreshUserFromAuth() async {
    try {
      final userDetails = await _authMethods.getUserDetails();
      
      // Validate the user details
      if (userDetails.name == null || 
          userDetails.jurisdiction == null || 
          userDetails.yearsExperience == null) {
        throw Exception('Invalid user details from auth');
      }

      _user = Professional(
        id: userDetails.id,
        name: userDetails.name,
        email: userDetails.email,
        phone: userDetails.phone,
        role: userDetails.role,
        technicalSkills: userDetails.technicalSkills,
        regulatoryExpertise: userDetails.regulatoryExpertise,
        financialStandards: userDetails.financialStandards,
        industryFocus: userDetails.industryFocus,
        jurisdiction: userDetails.jurisdiction,
        yearsExperience: userDetails.yearsExperience,
        photoUrl: userDetails.photoUrl
      );

      notifyListeners();
    } catch (e) {
      print('Error in refreshUserFromAuth: $e');
      rethrow;
    }
  }

  // Clear user data
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Check if user is initialized
  bool get isUserInitialized => _user != null;

  // Validate user data
  bool validateUserData() {
    if (_user == null) return false;
    
    return _user!.name != null &&
           _user!.jurisdiction != null &&
           _user!.yearsExperience != null &&
           _user!.technicalSkills.isNotEmpty &&
           _user!.regulatoryExpertise.isNotEmpty &&
           _user!.financialStandards.isNotEmpty &&
           _user!.industryFocus.isNotEmpty;
  }
}