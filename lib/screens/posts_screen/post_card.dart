// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:netwealth_vjti/models/professional.dart' as model;
// // import 'package:netwealth_vjti/resources/firestore_methods.dart';
// // import 'package:netwealth_vjti/resources/user_provider.dart';
// // import 'package:netwealth_vjti/screens/posts_screen/comments_screen.dart';
// // import 'package:netwealth_vjti/screens/posts_screen/like_animation.dart';
// // import 'package:netwealth_vjti/widgets/utils.dart';
// // import 'package:provider/provider.dart';

// // class PostCard extends StatefulWidget {
// //   final snap;
// //   const PostCard({
// //     Key? key,
// //     required this.snap,
// //   }) : super(key: key);

// //   @override
// //   State<PostCard> createState() => _PostCardState();
// // }

// // class _PostCardState extends State<PostCard> {
// //   int commentLen = 0;
// //   bool isLikeAnimating = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchCommentLen();
// //   }

// //   fetchCommentLen() async {
// //     try {
// //       QuerySnapshot snap = await FirebaseFirestore.instance
// //           .collection('posts')
// //           .doc(widget.snap['postId'])
// //           .collection('comments')
// //           .get();
// //       commentLen = snap.docs.length;
// //     } catch (err) {
// //       showSnackBar(err.toString(), context);
// //     }
// //   }

// //   deletePost(String postId) async {
// //     try {
// //       await FireStoreMethods().deletePost(postId);
// //     } catch (err) {
// //       showSnackBar(err.toString(), context);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final model.Professional? user = Provider.of<UserProvider>(context).getUser;

// //     return Container(
// //       color: Colors.white,
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: Column(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
// //             child: Row(
// //               children: <Widget>[
// //                 Hero(
// //                   tag: 'profile_${widget.snap['postId']}',
// //                   child: CircleAvatar(
// //                     radius: 16,
// //                     backgroundImage: NetworkImage(widget.snap['profImage']),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(left: 8),
// //                     child: Column(
// //                       mainAxisSize: MainAxisSize.min,
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: <Widget>[
// //                         Text(
// //                           widget.snap['username'],
// //                           style: const TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   onPressed: () {
// //                     showDialog(
// //                       context: context,
// //                       builder: (context) => Dialog(
// //                         child: ListView(
// //                           padding: const EdgeInsets.symmetric(vertical: 16),
// //                           shrinkWrap: true,
// //                           children: [
// //                             'Delete',
// //                           ].map(
// //                             (e) => InkWell(
// //                               child: Container(
// //                                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// //                                 child: Text(e),
// //                               ),
// //                               onTap: () {
// //                                 deletePost(widget.snap['postId']);
// //                                 Navigator.of(context).pop();
// //                               },
// //                             ),
// //                           ).toList(),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                   icon: const Icon(Icons.more_vert),
// //                 )
// //               ],
// //             ),
// //           ),
// //           GestureDetector(
// //             onDoubleTap: () {
// //               FireStoreMethods().likePost(
// //                 widget.snap['postId'],
// //                 user?.id??'',
// //                 widget.snap['likes'],
// //               );
// //               setState(() {
// //                 isLikeAnimating = true;
// //               });
// //             },
// //             child: Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 Hero(
// //                   tag: 'post_${widget.snap['postId']}',
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Text(
// //                         //   widget.snap['postTitle'],
// //                         //   style: const TextStyle(
// //                         //     fontWeight: FontWeight.bold,
// //                         //     fontSize: 18,
// //                         //   ),
// //                         // ),
// //                         const SizedBox(height: 8),
// //                          if (widget.snap['postUrl'] != null)
// //             GestureDetector(
// //               onDoubleTap: () {
// //                 FireStoreMethods().likePost(
// //                   widget.snap['postId'],
// //                   user?.id ?? '',
// //                   widget.snap['likes'],
// //                 );
// //                 setState(() {
// //                   isLikeAnimating = true;
// //                 });
// //               },
// //               child: Stack(
// //                 alignment: Alignment.center,
// //                 children: [
// //                   SizedBox(
// //                     height: MediaQuery.of(context).size.width * 0.8,
// //                     width: double.infinity,
// //                     child: Image.network(
// //                       widget.snap['postUrl'],
// //                       fit: BoxFit.cover,
// //                     ),
// //                   ),
// //                   AnimatedOpacity(
// //                     duration: const Duration(milliseconds: 200),
// //                     opacity: isLikeAnimating ? 1 : 0,
// //                     child: LikeAnimation(
// //                       isAnimating: isLikeAnimating,
// //                       duration: const Duration(milliseconds: 400),
// //                       onEnd: () {
// //                         setState(() {
// //                           isLikeAnimating = false;
// //                         });
// //                       },
// //                       child: const Icon(Icons.favorite, color: Colors.red, size: 100),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //                         //Text(widget.snap['description']),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 AnimatedOpacity(
// //                   duration: const Duration(milliseconds: 200),
// //                   opacity: isLikeAnimating ? 1 : 0,
// //                   child: LikeAnimation(
// //                     isAnimating: isLikeAnimating,
// //                     duration: const Duration(milliseconds: 400),
// //                     onEnd: () {
// //                       setState(() {
// //                         isLikeAnimating = false;
// //                       });
// //                     },
// //                     child: const Icon(Icons.favorite, color: Colors.red, size: 100),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Row(
// //             children: <Widget>[
// //               LikeAnimation(
// //                 isAnimating: widget.snap['likes'].contains(user?.id??''),
// //                 smallLike: true,
// //                 child: IconButton(
// //                   icon: widget.snap['likes'].contains(user?.id)
// //                       ? const Icon(Icons.favorite, color: Colors.red)
// //                       : const Icon(Icons.favorite_border),
// //                   onPressed: () => FireStoreMethods().likePost(
// //                     widget.snap['postId'],
// //                     user?.id??'',
// //                     widget.snap['likes'],
// //                   ),
// //                 ),
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.comment_outlined),
// //                 onPressed: () => Navigator.of(context).push(
// //                   MaterialPageRoute(
// //                     builder: (context) => CommentsScreen(
// //                       postId: widget.snap['postId'],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Expanded(
// //                 child: Align(
// //                   alignment: Alignment.bottomRight,
// //                   child: IconButton(
// //                     icon: const Icon(Icons.bookmark_border),
// //                     onPressed: () {},
// //                   ),
// //                 ),
// //               )
// //             ],
// //           ),
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: <Widget>[
// //                 DefaultTextStyle(
// //                   style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
// //                   child: Text(
// //                     '${widget.snap['likes'].length} likes',
// //                     style: Theme.of(context).textTheme.bodyMedium,
// //                   )
// //                 ),
// //                 Container(
// //                   width: double.infinity,
// //                   padding: const EdgeInsets.only(top: 8),
// //                   child: RichText(
// //                     text: TextSpan(
// //                       style: const TextStyle(color: Colors.black),
// //                       children: [
// //                         TextSpan(
// //                           text: widget.snap['username'],
// //                           style: const TextStyle(fontWeight: FontWeight.bold),
// //                         ),
// //                         TextSpan(text: ' ${widget.snap['description']}'),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //                 InkWell(
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(vertical: 4),
// //                     child: Text(
// //                       'View all $commentLen comments',
// //                       style: const TextStyle(
// //                         fontSize: 16,
// //                         color: Colors.black54,
// //                       ),
// //                     ),
// //                   ),
// //                   onTap: () => Navigator.of(context).push(
// //                     MaterialPageRoute(
// //                       builder: (context) => CommentsScreen(
// //                         postId: widget.snap['postId'],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(vertical: 4),
// //                   child: Text(
// //                     DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
// //                     style: const TextStyle(
// //                       color: Colors.black54,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:netwealth_vjti/models/professional.dart' as model;
// import 'package:netwealth_vjti/resources/firestore_methods.dart';
// import 'package:netwealth_vjti/resources/user_provider.dart';
// import 'package:netwealth_vjti/screens/posts_screen/comments_screen.dart';
// import 'package:netwealth_vjti/screens/posts_screen/like_animation.dart';
// import 'package:netwealth_vjti/widgets/utils.dart';
// import 'package:provider/provider.dart';

// class PostCard extends StatefulWidget {
//   final snap;
//   const PostCard({
//     Key? key,
//     required this.snap,
//   }) : super(key: key);

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   int commentLen = 0;
//   bool isLikeAnimating = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCommentLen();
//   }

//   fetchCommentLen() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       commentLen = snap.docs.length;
//     } catch (err) {
//       showSnackBar(err.toString(), context);
//     }
//   }

//   deletePost(String postId) async {
//     try {
//       await FireStoreMethods().deletePost(postId);
//     } catch (err) {
//       showSnackBar(err.toString(), context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model.Professional? user = Provider.of<UserProvider>(context).getUser;

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         children: [
//           // Header
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
//             child: Row(
//               children: <Widget>[
//                 Hero(
//                   tag: 'profile_${widget.snap['postId']}',
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundImage: NetworkImage(widget.snap['profImage']),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           widget.snap['username'],
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => Dialog(
//                         child: ListView(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shrinkWrap: true,
//                           children: [
//                             'Delete',
//                           ].map(
//                             (e) => InkWell(
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//                                 child: Text(e),
//                               ),
//                               onTap: () {
//                                 deletePost(widget.snap['postId']);
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ).toList(),
//                         ),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.more_vert),
//                 ),
//               ],
//             ),
//           ),
//           // Post Content
//           GestureDetector(
//             onDoubleTap: () {
//               FireStoreMethods().likePost(
//                 widget.snap['postId'],
//                 user?.id ?? '',
//                 widget.snap['likes'],
//               );
//               setState(() {
//                 isLikeAnimating = true;
//               });
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 widget.snap['postUrl'] != null && widget.snap['postUrl'].isNotEmpty
//                     ? SizedBox(
//                         height: MediaQuery.of(context).size.width * 0.8,
//                         width: double.infinity,
//                         child: Image.network(
//                           widget.snap['postUrl'],
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Container(
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: Text(
//                           widget.snap['description'],
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                       ),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 200),
//                   opacity: isLikeAnimating ? 1 : 0,
//                   child: LikeAnimation(
//                     isAnimating: isLikeAnimating,
//                     duration: const Duration(milliseconds: 400),
//                     onEnd: () {
//                       setState(() {
//                         isLikeAnimating = false;
//                       });
//                     },
//                     child: const Icon(Icons.favorite, color: Colors.red, size: 100),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Post Actions
//           Row(
//             children: <Widget>[
//               LikeAnimation(
//                 isAnimating: widget.snap['likes'].contains(user?.id ?? ''),
//                 smallLike: true,
//                 child: IconButton(
//                   icon: widget.snap['likes'].contains(user?.id)
//                       ? const Icon(Icons.favorite, color: Colors.red)
//                       : const Icon(Icons.favorite_border),
//                   onPressed: () => FireStoreMethods().likePost(
//                     widget.snap['postId'],
//                     user?.id ?? '',
//                     widget.snap['likes'],
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.comment_outlined),
//                 onPressed: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => CommentsScreen(
//                       postId: widget.snap['postId'],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: IconButton(
//                     icon: const Icon(Icons.bookmark_border),
//                     onPressed: () {},
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // Post Footer
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 DefaultTextStyle(
//                   style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
//                   child: Text(
//                     '${widget.snap['likes'].length} likes',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ),
//                 if (widget.snap['postUrl'] != null && widget.snap['postUrl'].isNotEmpty)
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.only(top: 8),
//                     child: RichText(
//                       text: TextSpan(
//                         style: const TextStyle(color: Colors.black),
//                         children: [
//                           TextSpan(
//                             text: widget.snap['username'],
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           TextSpan(text: ' ${widget.snap['description']}'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 InkWell(
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       'View all $commentLen comments',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ),
//                   onTap: () => Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => CommentsScreen(
//                         postId: widget.snap['postId'],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 4),
//                   child: Text(
//                     DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
//                     style: const TextStyle(
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netwealth_vjti/models/professional.dart' as model;
import 'package:netwealth_vjti/resources/firestore_methods.dart';
import 'package:netwealth_vjti/resources/user_provider.dart';
import 'package:netwealth_vjti/screens/posts_screen/comments_screen.dart';
import 'package:netwealth_vjti/screens/posts_screen/like_animation.dart';
import 'package:netwealth_vjti/screens/simplification_screen.dart';
import 'package:netwealth_vjti/widgets/utils.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.Professional user = Provider.of<UserProvider>(context).getUser!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                Hero(
                  tag: 'profile_${widget.snap['postId']}',
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profImage'] ?? user.photoUrl,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'] ?? user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'] == user.id
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete'].map(
                                  (e) => InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                    onTap: () {
                                      deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ).toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),
          // Post Content
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user!.id??'',
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.snap['postUrl'] != null &&
                        widget.snap['postUrl'].isNotEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.8,
                        width: double.infinity,
                        child: Image.network(
                          widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          widget.snap['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.id),
                smallLike: true,
                child: IconButton(
                  icon: widget.snap['likes'].contains(user.id)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      widget.snap['postId'],
                      user!.id??'',
                      widget.snap['likes'],
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      postId: widget.snap['postId'],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: widget.snap['username'] ?? user.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if(widget.snap['postUrl']!=null)TextSpan(text: ' ${widget.snap['description']}'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SimplificationScreen(originalString: widget.snap['description'])));
                  },
                  child: Text("Explain this text")),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        postId: widget.snap['postId'],
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}