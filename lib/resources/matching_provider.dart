// // // import 'package:flutter/foundation.dart';
// // // import 'package:netwealth_vjti/matcher_service.dart';
// // // import 'package:netwealth_vjti/models/match_details.dart';
// // // import 'package:netwealth_vjti/models/professional.dart';
// // // import 'package:netwealth_vjti/resources/user_provider.dart';

// // // class MatchingProvider with ChangeNotifier {
// // //   final MatcherService _matcherService = MatcherService();
// // //   final UserProvider _userProvider;

// // //   Professional? _currentProfile;
// // //   List<ScoredCandidate> _matches = [];
// // //   bool _isLoading = false;

// // //   MatchingProvider(this._userProvider) {
// // //     _userProvider.addListener(_onUserChanged);
// // //     _onUserChanged();
// // //   }

// // //   Professional? get currentProfile => _currentProfile;
// // //   List<ScoredCandidate> get matches => _matches;
// // //   bool get isLoading => _isLoading;

// // //   void _onUserChanged() {
// // //     final user = _userProvider.getUser;
// // //     if (user != null) {
// // //       _currentProfile = user;
// // //       findMatches();
// // //     } else {
// // //       _currentProfile = null;
// // //       _matches.clear();
// // //     }
// // //     notifyListeners();
// // //   }

// // //   Future<void> findMatches() async {
// // //     if (_currentProfile == null) return;

// // //     _isLoading = true;
// // //     notifyListeners();

// // //     try {
// // //       final candidates = _generateDemoCandidates();
// // //       _matches = await _matcherService.findMatches(_currentProfile!, candidates);
// // //     } finally {
// // //       _isLoading = false;
// // //       notifyListeners();
// // //     }
// // //   }

// // //   void updateProfile(Professional updatedProfile) {
// // //     _currentProfile = updatedProfile;
// // //     _userProvider.updateUser(updatedProfile); // Updates in UserProvider
// // //     notifyListeners();
// // //   }

// // //   List<Professional> _generateDemoCandidates() {
// // //     return [
// // //             Professional(
// // //         id: '1',
// // //         name: 'Alice Johnson',
// // //         technicalSkills: ['Python', 'Machine Learning', 'Data Analysis'],
// // //         regulatoryExpertise: ['GDPR', 'MiFID II'],
// // //         financialStandards: ['ISO20022', 'SWIFT'],
// // //         industryFocus: ['FinTech', 'AI'],
// // //         jurisdiction: 'EU',
// // //         yearsExperience: 6,
// // //       ),
// // //       Professional(
// // //   id: '2',
// // //   name: 'John Smith',
// // //   technicalSkills: ['Java', 'Cloud Computing', 'Cybersecurity'],
// // //   regulatoryExpertise: ['HIPAA', 'SOX'],
// // //   financialStandards: ['PCI DSS', 'ISO27001'],
// // //   industryFocus: ['Healthcare', 'Cloud Services'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 8,
// // // ),

// // // Professional(
// // //   id: '3',
// // //   name: 'Emily Davis',
// // //   technicalSkills: ['R', 'Data Visualization', 'Statistics'],
// // //   regulatoryExpertise: ['CCPA', 'GDPR'],
// // //   financialStandards: ['XBRL', 'BASEL III'],
// // //   industryFocus: ['RegTech', 'Banking'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 5,
// // // ),

// // // Professional(
// // //   id: '4',
// // //   name: 'Michael Brown',
// // //   technicalSkills: ['C++', 'Embedded Systems', 'IoT'],
// // //   regulatoryExpertise: ['ISO26262', 'REACH'],
// // //   financialStandards: ['FATCA', 'IFRS'],
// // //   industryFocus: ['Automotive', 'IoT'],
// // //   jurisdiction: 'APAC',
// // //   yearsExperience: 10,
// // // ),

// // // Professional(
// // //   id: '5',
// // //   name: 'Sophia Martinez',
// // //   technicalSkills: ['Ruby', 'Web Development', 'Agile Methodologies'],
// // //   regulatoryExpertise: ['FERPA', 'COPPA'],
// // //   financialStandards: ['SOC2', 'ISO22301'],
// // //   industryFocus: ['EdTech', 'Software Development'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 4,
// // // ),

// // // Professional(
// // //   id: '6',
// // //   name: 'Daniel Lee',
// // //   technicalSkills: ['Kotlin', 'Mobile Development', 'Blockchain'],
// // //   regulatoryExpertise: ['GDPR', 'PSD2'],
// // //   financialStandards: ['ISO20022', 'SWIFT'],
// // //   industryFocus: ['FinTech', 'Blockchain'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 7,
// // // ),

// // // Professional(
// // //   id: '7',
// // //   name: 'Olivia Taylor',
// // //   technicalSkills: ['JavaScript', 'React', 'UI/UX Design'],
// // //   regulatoryExpertise: ['ADA', 'WCAG'],
// // //   financialStandards: ['PCI DSS', 'SOC1'],
// // //   industryFocus: ['E-Commerce', 'Design'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 6,
// // // ),

// // // Professional(
// // //   id: '8',
// // //   name: 'William Johnson',
// // //   technicalSkills: ['Go', 'Kubernetes', 'DevOps'],
// // //   regulatoryExpertise: ['SOX', 'GDPR'],
// // //   financialStandards: ['ISO27001', 'COBIT'],
// // //   industryFocus: ['DevOps', 'Cloud Infrastructure'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 9,
// // // ),

// // // Professional(
// // //   id: '9',
// // //   name: 'Ava Wilson',
// // //   technicalSkills: ['Swift', 'Mobile App Development', 'AR/VR'],
// // //   regulatoryExpertise: ['COPPA', 'GDPR'],
// // //   financialStandards: ['SOC2', 'ISO22301'],
// // //   industryFocus: ['Gaming', 'Mobile Apps'],
// // //   jurisdiction: 'APAC',
// // //   yearsExperience: 5,
// // // ),

// // // Professional(
// // //   id: '10',
// // //   name: 'James Anderson',
// // //   technicalSkills: ['PHP', 'MySQL', 'Backend Development'],
// // //   regulatoryExpertise: ['HIPAA', 'CCPA'],
// // //   financialStandards: ['SOC1', 'BASEL II'],
// // //   industryFocus: ['Healthcare', 'Data Management'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 8,
// // // ),
// // //   Professional(
// // //   id: '11',
// // //   name: 'Liam Thompson',
// // //   technicalSkills: ['Scala', 'Big Data', 'Hadoop'],
// // //   regulatoryExpertise: ['GDPR', 'CCPA'],
// // //   financialStandards: ['BASEL III', 'ISO20022'],
// // //   industryFocus: ['FinTech', 'Data Engineering'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 7,
// // // ),

// // // Professional(
// // //   id: '12',
// // //   name: 'Isabella Moore',
// // //   technicalSkills: ['MATLAB', 'Control Systems', 'Robotics'],
// // //   regulatoryExpertise: ['ISO13485', 'FDA Regulations'],
// // //   financialStandards: ['IFRS', 'SOC2'],
// // //   industryFocus: ['MedTech', 'Automation'],
// // //   jurisdiction: 'APAC',
// // //   yearsExperience: 6,
// // // ),

// // // Professional(
// // //   id: '13',
// // //   name: 'Ethan White',
// // //   technicalSkills: ['Perl', 'Network Security', 'Ethical Hacking'],
// // //   regulatoryExpertise: ['FISMA', 'GDPR'],
// // //   financialStandards: ['ISO27001', 'PCI DSS'],
// // //   industryFocus: ['Cybersecurity', 'Telecommunications'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 10,
// // // ),

// // // Professional(
// // //   id: '14',
// // //   name: 'Mia Martinez',
// // //   technicalSkills: ['HTML', 'CSS', 'SEO'],
// // //   regulatoryExpertise: ['ADA', 'GDPR'],
// // //   financialStandards: ['SOC1', 'SOC2'],
// // //   industryFocus: ['Digital Marketing', 'E-Commerce'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 4,
// // // ),

// // // Professional(
// // //   id: '15',
// // //   name: 'Alexander Garcia',
// // //   technicalSkills: ['Node.js', 'MongoDB', 'API Development'],
// // //   regulatoryExpertise: ['SOX', 'HIPAA'],
// // //   financialStandards: ['ISO22301', 'PCI DSS'],
// // //   industryFocus: ['HealthTech', 'Web Services'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 5,
// // // ),

// // // Professional(
// // //   id: '16',
// // //   name: 'Charlotte Walker',
// // //   technicalSkills: ['Python', 'Deep Learning', 'Natural Language Processing'],
// // //   regulatoryExpertise: ['GDPR', 'CCPA'],
// // //   financialStandards: ['BASEL II', 'SOC2'],
// // //   industryFocus: ['AI', 'RegTech'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 9,
// // // ),

// // // Professional(
// // //   id: '17',
// // //   name: 'Benjamin Harris',
// // //   technicalSkills: ['Rust', 'Distributed Systems', 'Concurrency'],
// // //   regulatoryExpertise: ['GDPR', 'MiFID II'],
// // //   financialStandards: ['ISO20022', 'XBRL'],
// // //   industryFocus: ['FinTech', 'Blockchain'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 8,
// // // ),

// // // Professional(
// // //   id: '18',
// // //   name: 'Amelia Clark',
// // //   technicalSkills: ['Java', 'Spring Boot', 'Microservices'],
// // //   regulatoryExpertise: ['HIPAA', 'FERPA'],
// // //   financialStandards: ['ISO27001', 'SOC2'],
// // //   industryFocus: ['EdTech', 'HealthTech'],
// // //   jurisdiction: 'US',
// // //   yearsExperience: 6,
// // // ),

// // // Professional(
// // //   id: '19',
// // //   name: 'Lucas Lewis',
// // //   technicalSkills: ['Ruby on Rails', 'PostgreSQL', 'Web App Development'],
// // //   regulatoryExpertise: ['CCPA', 'GDPR'],
// // //   financialStandards: ['SOC1', 'PCI DSS'],
// // //   industryFocus: ['E-Commerce', 'Startups'],
// // //   jurisdiction: 'APAC',
// // //   yearsExperience: 5,
// // // ),

// // // Professional(
// // //   id: '20',
// // //   name: 'Harper Hall',
// // //   technicalSkills: ['C#', '.NET', 'Game Development'],
// // //   regulatoryExpertise: ['COPPA', 'GDPR'],
// // //   financialStandards: ['SOC2', 'ISO22301'],
// // //   industryFocus: ['Gaming', 'Entertainment'],
// // //   jurisdiction: 'EU',
// // //   yearsExperience: 4,
// // // ),
// // //       // Add demo candidates here, as in the original implementation
// // //     ];
// // //   }

// // //   @override
// // //   void dispose() {
// // //     _userProvider.removeListener(_onUserChanged);
// // //     super.dispose();
// // //   }
// // // }




// // import 'package:flutter/foundation.dart';
// // import 'package:netwealth_vjti/matcher_service.dart';
// // import 'package:netwealth_vjti/models/match_details.dart';
// // import 'package:netwealth_vjti/models/professional.dart';
// // import 'package:netwealth_vjti/resources/user_provider.dart';

// // class MatchingProvider with ChangeNotifier {
// //   final MatcherService _matcherService = MatcherService();
// //   UserProvider _userProvider;
// //   bool _isLoading = false;
// //   List<ScoredCandidate> _matches = [];

// //   MatchingProvider(this._userProvider) {
// //     _initializeProvider();
// //   }

// //   void updateUserProvider(UserProvider newProvider) {
// //     _userProvider = newProvider;
// //     _initializeProvider();
// //   }

// //   void _initializeProvider() {
// //     // Clear existing listener before adding new one
// //     _userProvider.removeListener(_onUserChanged);
// //     _userProvider.addListener(_onUserChanged);
    
// //     // Initial load if user exists
// //     if (_userProvider.getUser != null) {
// //       findMatches();
// //     }
// //   }

// //   Professional? get currentProfile => _userProvider.getUser;
// //   List<ScoredCandidate> get matches => _matches;
// //   bool get isLoading => _isLoading;

// //   void _onUserChanged() {
// //     if (_userProvider.getUser != null) {
// //       findMatches();
// //     } else {
// //       _matches.clear();
// //       notifyListeners();
// //     }
// //   }

// //   Future<void> findMatches() async {
// //     final currentUser = _userProvider.getUser;
// //     if (currentUser == null) return;

// //     _isLoading = true;
// //     notifyListeners();

// //     try {
// //       final candidates = await _fetchCandidates();
// //       // Filter out the current user from candidates
// //       final filteredCandidates = candidates
// //           .where((candidate) => candidate.id != currentUser.id)
// //           .toList();

// //       _matches = await _matcherService.findMatches(currentUser, filteredCandidates);
// //       _matches.sort((a, b) => b.score.compareTo(a.score));
// //     } catch (e) {
// //       print('Error finding matches: $e');
// //       _matches = [];
// //     } finally {
// //       _isLoading = false;
// //       notifyListeners();
// //     }
// //   }

// //   Future<List<Professional>> _fetchCandidates() async {
// //     // In a real app, you would fetch this from your backend
// //     // For now, using the demo data
// //     return _generateDemoCandidates();
// //   }

// //   List<Professional> _generateDemoCandidates() {
// //     // Your existing demo candidates list
// //     return [
// //                  Professional(
// //         id: '1',
// //         name: 'Alice Johnson',
// //         technicalSkills: ['Python', 'Machine Learning', 'Data Analysis'],
// //         regulatoryExpertise: ['GDPR', 'MiFID II'],
// //         financialStandards: ['ISO20022', 'SWIFT'],
// //         industryFocus: ['FinTech', 'AI'],
// //         jurisdiction: 'EU',
// //         yearsExperience: 6,
// //       ),
// //       Professional(
// //   id: '2',
// //   name: 'John Smith',
// //   technicalSkills: ['Java', 'Cloud Computing', 'Cybersecurity'],
// //   regulatoryExpertise: ['HIPAA', 'SOX'],
// //   financialStandards: ['PCI DSS', 'ISO27001'],
// //   industryFocus: ['Healthcare', 'Cloud Services'],
// //   jurisdiction: 'US',
// //   yearsExperience: 8,
// // ),

// // Professional(
// //   id: '3',
// //   name: 'Emily Davis',
// //   technicalSkills: ['R', 'Data Visualization', 'Statistics'],
// //   regulatoryExpertise: ['CCPA', 'GDPR'],
// //   financialStandards: ['XBRL', 'BASEL III'],
// //   industryFocus: ['RegTech', 'Banking'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 5,
// // ),

// // Professional(
// //   id: '4',
// //   name: 'Michael Brown',
// //   technicalSkills: ['C++', 'Embedded Systems', 'IoT'],
// //   regulatoryExpertise: ['ISO26262', 'REACH'],
// //   financialStandards: ['FATCA', 'IFRS'],
// //   industryFocus: ['Automotive', 'IoT'],
// //   jurisdiction: 'APAC',
// //   yearsExperience: 10,
// // ),

// // Professional(
// //   id: '5',
// //   name: 'Sophia Martinez',
// //   technicalSkills: ['Ruby', 'Web Development', 'Agile Methodologies'],
// //   regulatoryExpertise: ['FERPA', 'COPPA'],
// //   financialStandards: ['SOC2', 'ISO22301'],
// //   industryFocus: ['EdTech', 'Software Development'],
// //   jurisdiction: 'US',
// //   yearsExperience: 4,
// // ),

// // Professional(
// //   id: '6',
// //   name: 'Daniel Lee',
// //   technicalSkills: ['Kotlin', 'Mobile Development', 'Blockchain'],
// //   regulatoryExpertise: ['GDPR', 'PSD2'],
// //   financialStandards: ['ISO20022', 'SWIFT'],
// //   industryFocus: ['FinTech', 'Blockchain'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 7,
// // ),

// // Professional(
// //   id: '7',
// //   name: 'Olivia Taylor',
// //   technicalSkills: ['JavaScript', 'React', 'UI/UX Design'],
// //   regulatoryExpertise: ['ADA', 'WCAG'],
// //   financialStandards: ['PCI DSS', 'SOC1'],
// //   industryFocus: ['E-Commerce', 'Design'],
// //   jurisdiction: 'US',
// //   yearsExperience: 6,
// // ),

// // Professional(
// //   id: '8',
// //   name: 'William Johnson',
// //   technicalSkills: ['Go', 'Kubernetes', 'DevOps'],
// //   regulatoryExpertise: ['SOX', 'GDPR'],
// //   financialStandards: ['ISO27001', 'COBIT'],
// //   industryFocus: ['DevOps', 'Cloud Infrastructure'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 9,
// // ),

// // Professional(
// //   id: '9',
// //   name: 'Ava Wilson',
// //   technicalSkills: ['Swift', 'Mobile App Development', 'AR/VR'],
// //   regulatoryExpertise: ['COPPA', 'GDPR'],
// //   financialStandards: ['SOC2', 'ISO22301'],
// //   industryFocus: ['Gaming', 'Mobile Apps'],
// //   jurisdiction: 'APAC',
// //   yearsExperience: 5,
// // ),

// // Professional(
// //   id: '10',
// //   name: 'James Anderson',
// //   technicalSkills: ['PHP', 'MySQL', 'Backend Development'],
// //   regulatoryExpertise: ['HIPAA', 'CCPA'],
// //   financialStandards: ['SOC1', 'BASEL II'],
// //   industryFocus: ['Healthcare', 'Data Management'],
// //   jurisdiction: 'US',
// //   yearsExperience: 8,
// // ),
// //   Professional(
// //   id: '11',
// //   name: 'Liam Thompson',
// //   technicalSkills: ['Scala', 'Big Data', 'Hadoop'],
// //   regulatoryExpertise: ['GDPR', 'CCPA'],
// //   financialStandards: ['BASEL III', 'ISO20022'],
// //   industryFocus: ['FinTech', 'Data Engineering'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 7,
// // ),

// // Professional(
// //   id: '12',
// //   name: 'Isabella Moore',
// //   technicalSkills: ['MATLAB', 'Control Systems', 'Robotics'],
// //   regulatoryExpertise: ['ISO13485', 'FDA Regulations'],
// //   financialStandards: ['IFRS', 'SOC2'],
// //   industryFocus: ['MedTech', 'Automation'],
// //   jurisdiction: 'APAC',
// //   yearsExperience: 6,
// // ),

// // Professional(
// //   id: '13',
// //   name: 'Ethan White',
// //   technicalSkills: ['Perl', 'Network Security', 'Ethical Hacking'],
// //   regulatoryExpertise: ['FISMA', 'GDPR'],
// //   financialStandards: ['ISO27001', 'PCI DSS'],
// //   industryFocus: ['Cybersecurity', 'Telecommunications'],
// //   jurisdiction: 'US',
// //   yearsExperience: 10,
// // ),

// // Professional(
// //   id: '14',
// //   name: 'Mia Martinez',
// //   technicalSkills: ['HTML', 'CSS', 'SEO'],
// //   regulatoryExpertise: ['ADA', 'GDPR'],
// //   financialStandards: ['SOC1', 'SOC2'],
// //   industryFocus: ['Digital Marketing', 'E-Commerce'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 4,
// // ),

// // Professional(
// //   id: '15',
// //   name: 'Alexander Garcia',
// //   technicalSkills: ['Node.js', 'MongoDB', 'API Development'],
// //   regulatoryExpertise: ['SOX', 'HIPAA'],
// //   financialStandards: ['ISO22301', 'PCI DSS'],
// //   industryFocus: ['HealthTech', 'Web Services'],
// //   jurisdiction: 'US',
// //   yearsExperience: 5,
// // ),

// // Professional(
// //   id: '16',
// //   name: 'Charlotte Walker',
// //   technicalSkills: ['Python', 'Deep Learning', 'Natural Language Processing'],
// //   regulatoryExpertise: ['GDPR', 'CCPA'],
// //   financialStandards: ['BASEL II', 'SOC2'],
// //   industryFocus: ['AI', 'RegTech'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 9,
// // ),

// // Professional(
// //   id: '17',
// //   name: 'Benjamin Harris',
// //   technicalSkills: ['Rust', 'Distributed Systems', 'Concurrency'],
// //   regulatoryExpertise: ['GDPR', 'MiFID II'],
// //   financialStandards: ['ISO20022', 'XBRL'],
// //   industryFocus: ['FinTech', 'Blockchain'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 8,
// // ),

// // Professional(
// //   id: '18',
// //   name: 'Amelia Clark',
// //   technicalSkills: ['Java', 'Spring Boot', 'Microservices'],
// //   regulatoryExpertise: ['HIPAA', 'FERPA'],
// //   financialStandards: ['ISO27001', 'SOC2'],
// //   industryFocus: ['EdTech', 'HealthTech'],
// //   jurisdiction: 'US',
// //   yearsExperience: 6,
// // ),

// // Professional(
// //   id: '19',
// //   name: 'Lucas Lewis',
// //   technicalSkills: ['Ruby on Rails', 'PostgreSQL', 'Web App Development'],
// //   regulatoryExpertise: ['CCPA', 'GDPR'],
// //   financialStandards: ['SOC1', 'PCI DSS'],
// //   industryFocus: ['E-Commerce', 'Startups'],
// //   jurisdiction: 'APAC',
// //   yearsExperience: 5,
// // ),

// // Professional(
// //   id: '20',
// //   name: 'Harper Hall',
// //   technicalSkills: ['C#', '.NET', 'Game Development'],
// //   regulatoryExpertise: ['COPPA', 'GDPR'],
// //   financialStandards: ['SOC2', 'ISO22301'],
// //   industryFocus: ['Gaming', 'Entertainment'],
// //   jurisdiction: 'EU',
// //   yearsExperience: 4,
// // ),
// //       // ... rest of your demo candidates
// //     ];
// //   }

// //   @override
// //   void dispose() {
// //     _userProvider.removeListener(_onUserChanged);
// //     super.dispose();
// //   }
// // }





// import 'package:flutter/foundation.dart';
// import 'package:netwealth_vjti/resources/matcher_service.dart';
// import 'package:netwealth_vjti/models/match_details.dart';
// import 'package:netwealth_vjti/models/professional.dart';
// import 'package:netwealth_vjti/resources/user_provider.dart';

// class MatchingProvider with ChangeNotifier {
//   final MatcherService _matcherService = MatcherService();
//   UserProvider _userProvider;
//   bool _isLoading = false;
//   List<ScoredCandidate> _matches = [];

//   MatchingProvider(this._userProvider) {
//     _initializeProvider();
//   }

//   void _initializeProvider() {
//     _userProvider.removeListener(_onUserChanged);
//     _userProvider.addListener(_onUserChanged);
    
//     if (_userProvider.getUser != null) {
//       findMatches();
//     }
//   }

//   Professional? get currentProfile => _userProvider.getUser;
//   List<ScoredCandidate> get matches => _matches;
//   bool get isLoading => _isLoading;

//   void _onUserChanged() {
//     if (_userProvider.getUser != null) {
//       findMatches();
//     } else {
//       _matches.clear();
//       notifyListeners();
//     }
//   }

//   // Add updateProfile method
//   Future<void> updateProfile(Professional updatedProfile) async {
//     await _userProvider.refreshUser(updatedProfile);
//     notifyListeners();
//     await findMatches();
//   }

//   Future<void> findMatches() async {
//     final currentUser = _userProvider.getUser;
//     if (currentUser == null) return;

//     _isLoading = true;
//     notifyListeners();

//     try {
//       final candidates = await _fetchCandidates();
//       final filteredCandidates = candidates
//           .where((candidate) => candidate.id != currentUser.id)
//           .toList();

//       _matches = await _matcherService.findMatches(currentUser, filteredCandidates);
//       _matches.sort((a, b) => b.score.compareTo(a.score));
//     } catch (e) {
//       print('Error finding matches: $e');
//       _matches = [];
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<List<Professional>> _fetchCandidates() async {
//     return _generateDemoCandidates();
//   }

//   List<Professional> _generateDemoCandidates() {
//     return [
//       Professional(
//         id: '1',
//         name: 'Alice Johnson',
//         technicalSkills: ['Python', 'Machine Learning', 'Data Analysis'],
//         regulatoryExpertise: ['GDPR', 'MiFID II'],
//         financialStandards: ['ISO20022', 'SWIFT'],
//         industryFocus: ['FinTech', 'AI'],
//         jurisdiction: 'EU',
//         yearsExperience: 6,
//       ),
//       Professional(
//         id: '2',
//         name: 'John Smith',
//         technicalSkills: ['Java', 'Cloud Computing', 'Cybersecurity'],
//         regulatoryExpertise: ['HIPAA', 'SOX'],
//         financialStandards: ['PCI DSS', 'ISO27001'],
//         industryFocus: ['Healthcare', 'Cloud Services'],
//         jurisdiction: 'US',
//         yearsExperience: 8,
//       ),
//       Professional(
//   id: '3',
//   name: 'Emily Davis',
//   technicalSkills: ['R', 'Data Visualization', 'Statistics'],
//   regulatoryExpertise: ['CCPA', 'GDPR'],
//   financialStandards: ['XBRL', 'BASEL III'],
//   industryFocus: ['RegTech', 'Banking'],
//   jurisdiction: 'EU',
//   yearsExperience: 5,
// ),

// Professional(
//   id: '4',
//   name: 'Michael Brown',
//   technicalSkills: ['C++', 'Embedded Systems', 'IoT'],
//   regulatoryExpertise: ['ISO26262', 'REACH'],
//   financialStandards: ['FATCA', 'IFRS'],
//   industryFocus: ['Automotive', 'IoT'],
//   jurisdiction: 'APAC',
//   yearsExperience: 10,
// ),

// Professional(
//   id: '5',
//   name: 'Sophia Martinez',
//   technicalSkills: ['Ruby', 'Web Development', 'Agile Methodologies'],
//   regulatoryExpertise: ['FERPA', 'COPPA'],
//   financialStandards: ['SOC2', 'ISO22301'],
//   industryFocus: ['EdTech', 'Software Development'],
//   jurisdiction: 'US',
//   yearsExperience: 4,
// ),

// Professional(
//   id: '6',
//   name: 'Daniel Lee',
//   technicalSkills: ['Kotlin', 'Mobile Development', 'Blockchain'],
//   regulatoryExpertise: ['GDPR', 'PSD2'],
//   financialStandards: ['ISO20022', 'SWIFT'],
//   industryFocus: ['FinTech', 'Blockchain'],
//   jurisdiction: 'EU',
//   yearsExperience: 7,
// ),

// Professional(
//   id: '7',
//   name: 'Olivia Taylor',
//   technicalSkills: ['JavaScript', 'React', 'UI/UX Design'],
//   regulatoryExpertise: ['ADA', 'WCAG'],
//   financialStandards: ['PCI DSS', 'SOC1'],
//   industryFocus: ['E-Commerce', 'Design'],
//   jurisdiction: 'US',
//   yearsExperience: 6,
// ),

// Professional(
//   id: '8',
//   name: 'William Johnson',
//   technicalSkills: ['Go', 'Kubernetes', 'DevOps'],
//   regulatoryExpertise: ['SOX', 'GDPR'],
//   financialStandards: ['ISO27001', 'COBIT'],
//   industryFocus: ['DevOps', 'Cloud Infrastructure'],
//   jurisdiction: 'EU',
//   yearsExperience: 9,
// ),

// Professional(
//   id: '9',
//   name: 'Ava Wilson',
//   technicalSkills: ['Swift', 'Mobile App Development', 'AR/VR'],
//   regulatoryExpertise: ['COPPA', 'GDPR'],
//   financialStandards: ['SOC2', 'ISO22301'],
//   industryFocus: ['Gaming', 'Mobile Apps'],
//   jurisdiction: 'APAC',
//   yearsExperience: 5,
// ),

// Professional(
//   id: '10',
//   name: 'James Anderson',
//   technicalSkills: ['PHP', 'MySQL', 'Backend Development'],
//   regulatoryExpertise: ['HIPAA', 'CCPA'],
//   financialStandards: ['SOC1', 'BASEL II'],
//   industryFocus: ['Healthcare', 'Data Management'],
//   jurisdiction: 'US',
//   yearsExperience: 8,
// ),
//   Professional(
//   id: '11',
//   name: 'Liam Thompson',
//   technicalSkills: ['Scala', 'Big Data', 'Hadoop'],
//   regulatoryExpertise: ['GDPR', 'CCPA'],
//   financialStandards: ['BASEL III', 'ISO20022'],
//   industryFocus: ['FinTech', 'Data Engineering'],
//   jurisdiction: 'EU',
//   yearsExperience: 7,
// ),

// Professional(
//   id: '12',
//   name: 'Isabella Moore',
//   technicalSkills: ['MATLAB', 'Control Systems', 'Robotics'],
//   regulatoryExpertise: ['ISO13485', 'FDA Regulations'],
//   financialStandards: ['IFRS', 'SOC2'],
//   industryFocus: ['MedTech', 'Automation'],
//   jurisdiction: 'APAC',
//   yearsExperience: 6,
// ),

// Professional(
//   id: '13',
//   name: 'Ethan White',
//   technicalSkills: ['Perl', 'Network Security', 'Ethical Hacking'],
//   regulatoryExpertise: ['FISMA', 'GDPR'],
//   financialStandards: ['ISO27001', 'PCI DSS'],
//   industryFocus: ['Cybersecurity', 'Telecommunications'],
//   jurisdiction: 'US',
//   yearsExperience: 10,
// ),

// Professional(
//   id: '14',
//   name: 'Mia Martinez',
//   technicalSkills: ['HTML', 'CSS', 'SEO'],
//   regulatoryExpertise: ['ADA', 'GDPR'],
//   financialStandards: ['SOC1', 'SOC2'],
//   industryFocus: ['Digital Marketing', 'E-Commerce'],
//   jurisdiction: 'EU',
//   yearsExperience: 4,
// ),

// Professional(
//   id: '15',
//   name: 'Alexander Garcia',
//   technicalSkills: ['Node.js', 'MongoDB', 'API Development'],
//   regulatoryExpertise: ['SOX', 'HIPAA'],
//   financialStandards: ['ISO22301', 'PCI DSS'],
//   industryFocus: ['HealthTech', 'Web Services'],
//   jurisdiction: 'US',
//   yearsExperience: 5,
// ),

// Professional(
//   id: '16',
//   name: 'Charlotte Walker',
//   technicalSkills: ['Python', 'Deep Learning', 'Natural Language Processing'],
//   regulatoryExpertise: ['GDPR', 'CCPA'],
//   financialStandards: ['BASEL II', 'SOC2'],
//   industryFocus: ['AI', 'RegTech'],
//   jurisdiction: 'EU',
//   yearsExperience: 9,
// ),

// Professional(
//   id: '17',
//   name: 'Benjamin Harris',
//   technicalSkills: ['Rust', 'Distributed Systems', 'Concurrency'],
//   regulatoryExpertise: ['GDPR', 'MiFID II'],
//   financialStandards: ['ISO20022', 'XBRL'],
//   industryFocus: ['FinTech', 'Blockchain'],
//   jurisdiction: 'EU',
//   yearsExperience: 8,
// ),

// Professional(
//   id: '18',
//   name: 'Amelia Clark',
//   technicalSkills: ['Java', 'Spring Boot', 'Microservices'],
//   regulatoryExpertise: ['HIPAA', 'FERPA'],
//   financialStandards: ['ISO27001', 'SOC2'],
//   industryFocus: ['EdTech', 'HealthTech'],
//   jurisdiction: 'US',
//   yearsExperience: 6,
// ),

// Professional(
//   id: '19',
//   name: 'Lucas Lewis',
//   technicalSkills: ['Ruby on Rails', 'PostgreSQL', 'Web App Development'],
//   regulatoryExpertise: ['CCPA', 'GDPR'],
//   financialStandards: ['SOC1', 'PCI DSS'],
//   industryFocus: ['E-Commerce', 'Startups'],
//   jurisdiction: 'APAC',
//   yearsExperience: 5,
// ),

// Professional(
//   id: '20',
//   name: 'Harper Hall',
//   technicalSkills: ['C#', '.NET', 'Game Development'],
//   regulatoryExpertise: ['COPPA', 'GDPR'],
//   financialStandards: ['SOC2', 'ISO22301'],
//   industryFocus: ['Gaming', 'Entertainment'],
//   jurisdiction: 'EU',
//   yearsExperience: 4,
// ),
//       // Add more demo candidates as needed...
//     ];
//   }

//   @override
//   void dispose() {
//     _userProvider.removeListener(_onUserChanged);
//     super.dispose();
//   }
// }



import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netwealth_vjti/resources/matcher_service.dart';
import 'package:netwealth_vjti/models/match_details.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';

class MatchingProvider with ChangeNotifier {
  final MatcherService _matcherService = MatcherService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProvider _userProvider;
  bool _isLoading = false;
  List<ScoredCandidate> _matches = [];

  MatchingProvider(this._userProvider) {
    _initializeProvider();
  }

  void _initializeProvider() {
    _userProvider.removeListener(_onUserChanged);
    _userProvider.addListener(_onUserChanged);
    
    if (_userProvider.getUser != null) {
      findMatches();
    }
  }

  Professional? get currentProfile => _userProvider.getUser;
  List<ScoredCandidate> get matches => _matches;
  bool get isLoading => _isLoading;

  void _onUserChanged() {
    if (_userProvider.getUser != null) {
      findMatches();
    } else {
      _matches.clear();
      notifyListeners();
    }
  }

  Future<void> updateProfile(Professional updatedProfile) async {
    await _userProvider.refreshUser(updatedProfile);
    notifyListeners();
    await findMatches();
  }

  Future<void> findMatches() async {
    final currentUser = _userProvider.getUser;
    if (currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final candidates = await _fetchCandidatesFromFirebase(currentUser.id!);
      _matches = await _matcherService.findMatches(currentUser, candidates);
      _matches.sort((a, b) => b.score.compareTo(a.score));
    } catch (e) {
      print('Error finding matches: $e');
      _matches = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Professional>> _fetchCandidatesFromFirebase(String currentUserId) async {
    try {
      // Query all users except the current user
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'Professional')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .get();

      return querySnapshot.docs
          .map((doc) => Professional.fromSnap(doc))
          .toList();
    } catch (e) {
      print('Error fetching candidates from Firebase: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _userProvider.removeListener(_onUserChanged);
    super.dispose();
  }
}