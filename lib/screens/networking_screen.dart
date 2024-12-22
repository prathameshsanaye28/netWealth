// // lib/screens/networking_screen.dart
// import 'package:flutter/material.dart';
// import 'package:netwealth_vjti/models/professional.dart';
// import 'package:netwealth_vjti/resources/matching_provider.dart';
// import 'package:netwealth_vjti/models/match_details.dart';
// import 'package:netwealth_vjti/models/professional.dart' as ModelUser;
// import 'package:netwealth_vjti/resources/user_provider.dart';
// import 'package:netwealth_vjti/widgets/widgets.dart';
// import 'package:provider/provider.dart';

// class NetworkingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Professional Network'),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Matches'),
//               Tab(text: 'Profile'),
//             ],
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.filter_list),
//               onPressed: () => _showFilters(context),
//             ),
//           ],
//         ),
//         body: TabBarView(
//           children: [
//             _MatchesTab(),
//             _ProfileTab(),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showFilters(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => FilterSheet(),
//     );
//   }
// }

// class _MatchesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MatchingProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (provider.matches.isEmpty) {
//           return EmptyMatchesView();
//         }

//         return RefreshIndicator(
//           onRefresh: provider.findMatches,
//           child: MatchList(matches: provider.matches),
//         );
//       },
//     );
//   }
// }

// class _ProfileTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MatchingProvider>(
//       builder: (context, provider, child) {
//         if (provider.currentProfile == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         return SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ProfileEditor(
//                 //   profile: provider.currentProfile!,
//                 //   onSave: provider.updateProfile,
//                 // ),
//                 ProfileEditor(
//   profile: provider.currentProfile!,
//   onSave: (updatedProfile) => provider.updateProfile(updatedProfile),
// ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // lib/widgets/match_list.dart
// class MatchList extends StatelessWidget {
//   final List<ScoredCandidate> matches;

//   const MatchList({Key? key, required this.matches}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: matches.length,
//       itemBuilder: (context, index) {
//         return MatchCard(candidate: matches[index]);
//       },
//     );
//   }
// }

// class MatchCard extends StatelessWidget {
//   final ScoredCandidate candidate;

//   const MatchCard({Key? key, required this.candidate}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final professional = candidate.professional;
//     final score = (candidate.score * 100).round();

//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: InkWell(
//         onTap: () => _showDetails(context, professional),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               _buildAvatar(professional),
//               SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       professional.name??'',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     Text(
//                       '${professional.jurisdiction} • ${professional.yearsExperience}y exp',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       professional.skillsPreview,
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 16),
//               _buildMatchScore(context, score),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAvatar(Professional professional) {
//     return CircleAvatar(
//       radius: 30,
//       backgroundColor: Colors.amber,
//       backgroundImage: NetworkImage(professional.photoUrl??'')
//     );
//   }

//   Widget _buildMatchScore(BuildContext context, int score) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _getScoreColor(score),
//       ),
//       child: Center(
//         child: Text(
//           '$score%',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getScoreColor(int score) {
//     if (score >= 80) return Colors.green;
//     if (score >= 60) return Colors.orange;
//     return Colors.red;
//   }

//   void _showDetails(BuildContext context, Professional professional) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => ProfessionalDetails(professional: professional),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/match_details.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/resources/matching_provider.dart';
import 'package:netwealth_vjti/widgets/widgets.dart';
import 'package:provider/provider.dart';

class NetworkingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Network'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: _MatchesTab(),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FilterSheet(),
    );
  }
}

class _MatchesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchingProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.matches.isEmpty) {
          return EmptyMatchesView();
        }

        return RefreshIndicator(
          onRefresh: provider.findMatches,
          child: MatchList(matches: provider.matches),
        );
      },
    );
  }
}

class MatchList extends StatelessWidget {
  final List<ScoredCandidate> matches;

  const MatchList({Key? key, required this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return MatchCard(candidate: matches[index]);
      },
    );
  }
}

class MatchCard extends StatelessWidget {
  final ScoredCandidate candidate;

  const MatchCard({Key? key, required this.candidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final professional = candidate.professional;
    final score = (candidate.score * 100).round();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showDetails(context, professional),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              _buildAvatar(professional),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      professional.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${professional.jurisdiction} • ${professional.yearsExperience}y exp',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: 8),
                    Text(
                      professional.skillsPreview,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              _buildMatchScore(context, score),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Professional professional) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.amber,
      backgroundImage: NetworkImage(professional.photoUrl ?? ''),
    );
  }

  Widget _buildMatchScore(BuildContext context, int score) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getScoreColor(score),
      ),
      child: Center(
        child: Text(
          '$score%',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  void _showDetails(BuildContext context, Professional professional) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ProfessionalDetails(professional: professional),
    );
  }
}




