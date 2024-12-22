import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/populate_users.dart';
import 'package:netwealth_vjti/models/professional.dart' as ModelUser;
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/api_marketplace.dart';
import 'package:netwealth_vjti/screens/chat_screen.dart/chat_screen.dart';
import 'package:netwealth_vjti/screens/chat_screen.dart/search_screen.dart';
import 'package:netwealth_vjti/screens/image_to_text.dart';
import 'package:netwealth_vjti/screens/job_matching.dart';
import 'package:netwealth_vjti/screens/networking_screen.dart';
import 'package:netwealth_vjti/screens/news_app_screen.dart';
import 'package:netwealth_vjti/screens/posts_screen/feed_screen.dart';
import 'package:netwealth_vjti/screens/projects/projects_screen.dart';
import 'package:netwealth_vjti/screens/user_profile.dart';
import 'package:netwealth_vjti/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

// class MainLayoutScreen extends StatelessWidget {
//    MainLayoutScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;
//     return  Scaffold(
//       appBar: AppBar(
//         title: Text("Main Layout"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Text("Hello ${user!.name}"),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NetworkingScreen()));
//               }, child: Text("Network")),
//                ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>JobMatchingScreen()));
//               }, child: Text("Job matching")),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedScreen()));
//               }, child: Text("Posts")),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsScreen()));
//               }, child: Text("News")),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MarketplaceScreen()));
//               }, child: Text("Market")),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
//               }, child: Text("Chat")),
//               ElevatedButton(onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageToTextScreen()));
//               }, child: Text("Image")),
// //               ElevatedButton(
// //   onPressed: () async {
// //     final populator = FirebasePopulator();
// //     await populator.populateAPIs();
// //   },
// //   child: Text('Populate Firebase'),
// // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class MainLayoutScreen extends StatefulWidget {
  @override
  _MainLayoutScreenState createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;

  // List of pages for each BottomNavigationBar item
  final List<Widget> _pages = [
    FeedScreen(),
    NetworkingScreen(),
    JobMatchingScreen(),
    ViewProjectsScreen(),
    UserProfileScreen(userId: "vdpMVD2MLVSmPIIWTx3ko3pNC0I2",),
  ];

  // Function to handle item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromRGBO(55, 27, 52, 1),
        unselectedItemColor: const Color.fromRGBO(205, 208, 227, 1),
        currentIndex: _selectedIndex, // Current selected index
        onTap: _onItemTapped, // Update index on item tap
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
