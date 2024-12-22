// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:netwealth_vjti/screens/posts_screen/add_post.dart';
// import 'package:netwealth_vjti/screens/posts_screen/post_card.dart';

// class FeedScreen extends StatelessWidget {
//   const FeedScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Community'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .orderBy('datePublished', descending: true)
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (ctx, index) => PostCard(
//               snap: snapshot.data!.docs[index].data(),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => const AddPostScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/professional.dart';
import 'package:netwealth_vjti/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:netwealth_vjti/models/professional.dart' as model;
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/posts_screen/add_post.dart';
import 'package:netwealth_vjti/screens/posts_screen/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isUserInitialized) {
      await userProvider.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Professional? user = Provider.of<UserProvider>(context).getUser;
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final model.Professional? user = userProvider.getUser;

        return Scaffold(
          drawer: AppDrawer(currentRoute: '/home'),
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datePublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No posts yet'),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              );
            },
          ),
          floatingActionButton: user != null
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddPostScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}