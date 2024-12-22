// // import 'package:aura_techwizard/components/utils.dart';
// // import 'package:aura_techwizard/resources/firestore_methods.dart';
// // import 'package:aura_techwizard/resources/user_provider.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:netwealth_vjti/resources/firestore_methods.dart';
// // import 'package:netwealth_vjti/resources/user_provider.dart';
// // import 'package:netwealth_vjti/widgets/utils.dart';
// // import 'package:provider/provider.dart';

// // class AddPostScreen extends StatefulWidget {
// //   const AddPostScreen({Key? key}) : super(key: key);

// //   @override
// //   _AddPostScreenState createState() => _AddPostScreenState();
// // }

// // class _AddPostScreenState extends State<AddPostScreen> {
// //   final TextEditingController _titleController = TextEditingController();
// //   final TextEditingController _descriptionController = TextEditingController();
// //   bool isLoading = false;

// //   void postContent(String id, String name, Uint8List profImage) async {
// //     setState(() {
// //       isLoading = true;
// //     });
// //     try {
// //       String res = await FireStoreMethods().uploadPost(
// //         _descriptionController.text,
// //         profImage,
// //         _titleController.text,
// //         id,
// //         name,
// //       );
// //       if (res == "success") {
// //         setState(() {
// //           isLoading = false;
// //         });
// //         if (context.mounted) {
// //           showSnackBar(
// //             'Posted!',
// //             context,
// //           );
// //         }
// //         clearPost();
// //       } else {
// //         if (context.mounted) {
// //           showSnackBar(res,context);
// //         }
// //       }
// //     } catch (err) {
// //       setState(() {
// //         isLoading = false;
// //       });
// //       showSnackBar(
// //         err.toString(),
// //         context,
        
// //       );
// //     }
// //   }

// //   void clearPost() {
// //     setState(() {
// //       _titleController.clear();
// //       _descriptionController.clear();
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _titleController.dispose();
// //     _descriptionController.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final UserProvider userProvider = Provider.of<UserProvider>(context);

// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: clearPost,
// //         ),
// //         title: const Text('Create a Post'),
// //         centerTitle: false,
// //         actions: <Widget>[
// //           TextButton(
// //             onPressed: () => postContent(
// //               userProvider.getUser?.id??'',
// //               userProvider.getUser?.name??'',
// //               userProvider.getUser?.photoUrl??'',
// //             ),
// //             child: const Text(
// //               "Post",
// //               style: TextStyle(
// //                   color: Colors.blueAccent,
// //                   fontWeight: FontWeight.bold,
// //                   fontSize: 16.0),
// //             ),
// //           )
// //         ],
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           isLoading
// //               ? const LinearProgressIndicator()
// //               : const Padding(padding: EdgeInsets.only(top: 0.0)),
// //           const Divider(),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //             child: TextField(
// //               controller: _titleController,
// //               decoration: const InputDecoration(
// //                 hintText: "Enter post title...",
// //                 border: InputBorder.none,
// //               ),
// //             ),
// //           ),
// //           const Divider(),
// //           Expanded(
// //             child: Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
// //               child: TextField(
// //                 controller: _descriptionController,
// //                 decoration: const InputDecoration(
// //                   hintText: "Write your post...",
// //                   border: InputBorder.none,
// //                 ),
// //                 maxLines: null,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }



// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:netwealth_vjti/resources/firestore_methods.dart';
// import 'package:netwealth_vjti/resources/user_provider.dart';
// import 'package:netwealth_vjti/widgets/utils.dart';
// import 'package:provider/provider.dart';

// class AddPostScreen extends StatefulWidget {
//   const AddPostScreen({Key? key}) : super(key: key);

//   @override
//   _AddPostScreenState createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//   Uint8List? _file;
//   bool isLoading = false;
//   final TextEditingController _descriptionController = TextEditingController();

//   _selectImage(BuildContext parentContext) async {
//     return showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Take a photo'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   Uint8List file = await pickImage(ImageSource.camera);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: const Text('Choose from Gallery'),
//                 onPressed: () async {
//                   Navigator.of(context).pop();
//                   Uint8List file = await pickImage(ImageSource.gallery);
//                   setState(() {
//                     _file = file;
//                   });
//                 }),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   void postImage(String uid, String username, String profImage) async {
//     setState(() {
//       isLoading = true;
//     });
//     // start the loading
//     try {
//       // upload to storage and db
//       String res = await FireStoreMethods().uploadPost(
//         _descriptionController.text,
//         _file!,
//         uid,
//         username,
//         profImage,
//       );
//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });
//         if (context.mounted) {
//           showSnackBar(
            
//             'Posted!',
//             context
//           );
//         }
//         clearImage();
//       } else {
//         if (context.mounted) {
//           showSnackBar(res,context);
//         }
//       }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       showSnackBar(
//         err.toString(),context,
        
//       );
//     }
//   }

//   void clearImage() {
//     setState(() {
//       _file = null;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final UserProvider userProvider = Provider.of<UserProvider>(context);

//     return _file == null
//         ? Center(
//             child: IconButton(
//               icon: const Icon(
//                 Icons.upload,
//               ),
//               onPressed: () => _selectImage(context),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               //backgroundColor: mobileBackgroundColor,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: clearImage,
//               ),
//               title: const Text(
//                 'Post to',
//               ),
//               centerTitle: false,
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => postImage(
//                     userProvider.getUser?.id??'',
//                     userProvider.getUser?.name??'',
//                     userProvider.getUser?.photoUrl??'',
//                   ),
//                   child: const Text(
//                     "Post",
//                     style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0),
//                   ),
//                 )
//               ],
//             ),
//             // POST FORM
//             body: Column(
//               children: <Widget>[
//                 isLoading
//                     ? const LinearProgressIndicator()
//                     : const Padding(padding: EdgeInsets.only(top: 0.0)),
//                 const Divider(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         userProvider.getUser?.photoUrl??'',
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width * 0.3,
//                       child: TextField(
//                         controller: _descriptionController,
//                         decoration: const InputDecoration(
//                             hintText: "Write a caption...",
//                             border: InputBorder.none),
//                         maxLines: 8,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 45.0,
//                       width: 45.0,
//                       child: AspectRatio(
//                         aspectRatio: 487 / 451,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               image: DecorationImage(
//                             fit: BoxFit.fill,
//                             alignment: FractionalOffset.topCenter,
//                             image: MemoryImage(_file!),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Divider(),
//               ],
//             ),
//           );
//   }
// }



import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:netwealth_vjti/models/professional.dart' as ModelUser;
import 'package:netwealth_vjti/resources/firestore_methods.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/widgets/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add a Photo'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postContent(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        uid,
        username,
        profImage,
        file: _file,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        if (context.mounted) {
          showSnackBar('Posted!', context);
        }
        clearPost();
        Navigator.pop(context);
      } else {
        if (context.mounted) {
          showSnackBar(res, context);
        }
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(err.toString(), context);
    }
  }

  void clearPost() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser.Professional? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create a Post'),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            onPressed: () => postContent(
              user?.id ?? '',
              user?.name ?? '',
              user!.photoUrl ?? '',
            ),
            child: const Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(padding: EdgeInsets.only(top: 0.0)),
            const Divider(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: TextField(
            //     controller: _titleController,
            //     decoration: const InputDecoration(
            //       hintText: "Enter post title...",
            //       border: InputBorder.none,
            //     ),
            //     style: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "What's on your mind?",
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(height: 20),
            if (_file != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    width: double.infinity,
                    child: Image.memory(
                      _file!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        setState(() {
                          _file = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _selectImage(context),
              icon: const Icon(Icons.add_photo_alternate),
              label: Text(_file == null ? 'Add Photo' : 'Change Photo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}