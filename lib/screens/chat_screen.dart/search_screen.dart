import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/chat_screen.dart/chat_methods.dart';
import 'package:netwealth_vjti/screens/chat_screen.dart/chat_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchResults;
  QuerySnapshot? allUsers;

  String? currentUserId; // Store the current user's UID

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Get current user's ID
  }

  // Fetch the current user's UID
  void fetchCurrentUser() async {
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
    fetchAllUsers(); // Fetch all users after getting the current user
  }

  // Fetch all users excluding the current user
  void fetchAllUsers() async {
    if (currentUserId == null) return; // Make sure the user ID is available

    setState(() {
      isLoading = true;
    });

    allUsers = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isNotEqualTo: currentUserId) // Exclude current user
        .get();

    setState(() {
      isLoading = false;
    });
  }

  void searchUsers(String query) async {
    setState(() {
      isLoading = true;
    });

    searchResults = await ChatMethods().searchUsers(query);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search users...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchUsers(_searchController.text),
                ),
              ),
              onFieldSubmitted: searchUsers,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : (searchResults == null && allUsers == null)
                    ? Center(child: Text('No users available'))
                    : ListView.builder(
                        itemCount: searchResults?.docs.length ?? allUsers!.docs.length,
                        itemBuilder: (context, index) {
                          var userData = (searchResults != null
                              ? searchResults!.docs[index].data()
                              : allUsers!.docs[index].data()) as Map<String, dynamic>;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userData['photoUrl']),
                            ),
                            title: Text(userData['name']),
                            subtitle: Text(userData['email']),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    userId: userData['id'],
                                    username: userData['name'],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

