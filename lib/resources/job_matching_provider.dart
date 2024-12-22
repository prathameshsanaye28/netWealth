// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:netwealth_vjti/models/jobapplication.dart';
// import 'package:netwealth_vjti/models/scored_job.dart';
// import 'package:netwealth_vjti/resources/job_matcher_service.dart';
// import 'package:netwealth_vjti/models/match_details.dart';
// import 'package:netwealth_vjti/models/professional.dart';
// import 'package:netwealth_vjti/resources/user_provider.dart';

// class JobMatchingProvider with ChangeNotifier {
//   final JobMatcherService _jobMatcherService = JobMatcherService();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final UserProvider _userProvider;
//   bool _isLoading = false;
//   List<ScoredJobApplication> _jobMatches = [];

//   JobMatchingProvider(this._userProvider) {
//     _initializeProvider();
//   }

//   void _initializeProvider() {
//     _userProvider.removeListener(_onUserChanged);
//     _userProvider.addListener(_onUserChanged);
    
//     if (_userProvider.getUser != null) {
//       findJobMatches();
//     }
//   }

//   List<ScoredJobApplication> get jobMatches => _jobMatches;
//   bool get isLoading => _isLoading;

//   void _onUserChanged() {
//     if (_userProvider.getUser != null) {
//       findJobMatches();
//     } else {
//       _jobMatches.clear();
//       notifyListeners();
//     }
//   }

//   Future<void> findJobMatches() async {
//     final currentUser = _userProvider.getUser;
//     if (currentUser == null) return;

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final jobs = await _fetchJobsFromFirebase();
//       _jobMatches = await _jobMatcherService.findJobMatches(currentUser, jobs);
//       _jobMatches.sort((a, b) => b.score.compareTo(a.score));
//     } catch (e) {
//       print('Error finding job matches: $e');
//       _jobMatches = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<List<JobApplication>> _fetchJobsFromFirebase() async {
//     try {
//       final QuerySnapshot querySnapshot = await _firestore
//           .collection('jobs')
//           .orderBy('postedDate', descending: true)
//           .get();

//       return querySnapshot.docs
//           .map((doc) => JobApplication.fromSnap(doc))
//           .toList();
//     } catch (e) {
//       print('Error fetching jobs from Firebase: $e');
//       return [];
//     }
//   }

//   @override
//   void dispose() {
//     _userProvider.removeListener(_onUserChanged);
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/jobapplication.dart';
import 'package:netwealth_vjti/models/scored_job.dart';
import 'package:netwealth_vjti/resources/job_matcher_service.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';

class JobMatchingProvider with ChangeNotifier {
  final JobMatcherService _jobMatcherService = JobMatcherService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProvider _userProvider;
  bool _isLoading = false;
  List<ScoredJobApplication> _jobMatches = [];
  // Add the missing field declaration here
  List<JobApplication> _appliedJobs = [];

  JobMatchingProvider(this._userProvider) {
    _initializeProvider();
  }

  List<ScoredJobApplication> get jobMatches => _jobMatches;
  bool get isLoading => _isLoading;
  List<JobApplication> get appliedJobs => _appliedJobs;

  void _initializeProvider() {
    _userProvider.removeListener(_onUserChanged);
    _userProvider.addListener(_onUserChanged);
    
    if (_userProvider.getUser != null) {
      findJobMatches();
      fetchAppliedJobs();
    }
  }

  Future<void> fetchAppliedJobs() async {
    final currentUser = _userProvider.getUser;
    if (currentUser == null) return;

    try {
      final QuerySnapshot appliedJobsSnap = await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('appliedJobs')
          .get();

      List<String> appliedJobIds = appliedJobsSnap.docs.map((doc) => doc['jobId'] as String).toList();

      List<JobApplication> jobs = [];
      for (String jobId in appliedJobIds) {
        final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
        if (jobDoc.exists) {
          jobs.add(JobApplication.fromSnap(jobDoc));
        }
      }

      _appliedJobs = jobs;
      notifyListeners();
    } catch (e) {
      print('Error fetching applied jobs: $e');
      _appliedJobs = [];
      notifyListeners();
    }
  }

  Future<void> applyToJob(JobApplication job) async {
    final currentUser = _userProvider.getUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUser.id)
          .collection('appliedJobs')
          .doc(job.id)
          .set({
        'jobId': job.id,
        'appliedDate': DateTime.now().toIso8601String(),
        'status': 'pending'
      });

      await fetchAppliedJobs();
    } catch (e) {
      print('Error applying to job: $e');
      rethrow;
    }
  }

  void _onUserChanged() {
    if (_userProvider.getUser != null) {
      findJobMatches();
      fetchAppliedJobs();
    } else {
      _jobMatches.clear();
      _appliedJobs.clear();
      notifyListeners();
    }
  }

  Future<void> findJobMatches() async {
    final currentUser = _userProvider.getUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final jobs = await _fetchJobsFromFirebase();
      _jobMatches = await _jobMatcherService.findJobMatches(currentUser, jobs);
      _jobMatches.sort((a, b) => b.score.compareTo(a.score));
    } catch (e) {
      print('Error finding job matches: $e');
      _jobMatches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<JobApplication>> _fetchJobsFromFirebase() async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('jobs')
          .orderBy('postedDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => JobApplication.fromSnap(doc))
          .toList();
    } catch (e) {
      print('Error fetching jobs from Firebase: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _userProvider.removeListener(_onUserChanged);
    super.dispose();
  }
}