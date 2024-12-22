// import 'package:flutter/material.dart';
// import '../models/course_model.dart';
// import '../services/course_services.dart';


// class CourseDetailScreen extends StatelessWidget {
//   final Course course;
//   final bool isEnrolled;

//   const CourseDetailScreen({
//     Key? key,
//     required this.course,
//     this.isEnrolled = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(course.title),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Center(
//                 child: Text(course.category),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               course.description,
//               style: Theme.of(context).textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Icon(Icons.timer, color: Colors.grey[600]),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${course.totalDuration} mins',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 const Spacer(),
//                 if (!isEnrolled)
//                   ElevatedButton(
//                     onPressed: () {
//                       CourseService().enrollInCourse('user10', course.id);
//                       Navigator.pop(context);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Successfully enrolled in course'),
//                         ),
//                       );
//                     },
//                     child: const Text('Enroll Now'),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Text(
//               'Course Modules',
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//             const SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: course.modules.length,
//               itemBuilder: (context, index) {
//                 final module = course.modules[index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: module.isCompleted
//                           ? Colors.green
//                           : Colors.grey[300],
//                       child: Icon(
//                         module.isCompleted
//                             ? Icons.check
//                             : Icons.play_arrow,
//                         color: module.isCompleted
//                             ? Colors.white
//                             : Colors.grey[600],
//                       ),
//                     ),
//                     title: Text(module.title),
//                     subtitle: Text('${module.duration} mins'),
//                     // trailing: isEnrolled
//                     //     ? TextButton(
//                     //         onPressed: () {
//                     //           CourseService().markModuleAsCompleted(
//                     //             'user10',
//                     //             course.id,
//                     //             module.title,
//                     //           );
//                     //         },
//                     //         child: Text(
//                     //           module.isCompleted ? 'Completed' : 'Mark Complete',
//                     //         ),
//                     //       )
//                     //     : null,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/screens/course_screen/course.dart';
import 'package:netwealth_vjti/screens/course_screen/course_service.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;
  final String userId = 'user10'; // You might want to pass this as a parameter

  const CourseDetailScreen({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(course.category),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              course.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.timer, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '${course.totalDuration} mins',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                StreamBuilder<bool>(
                  stream: CourseService().isUserCompleted(userId, course.id),
                  builder: (context, completedSnapshot) {
                    return StreamBuilder<bool>(
                      stream: CourseService().isUserEnrolled(userId, course.id),
                      builder: (context, enrolledSnapshot) {
                        final isCompleted = completedSnapshot.data ?? false;
                        final isEnrolled = enrolledSnapshot.data ?? false;

                        if (isCompleted) {
                          return ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text('Completed'),
                          );
                        } else if (isEnrolled) {
                          return ElevatedButton(
                            onPressed: () {
                              CourseService().markCourseAsCompleted(
                                userId,
                                course.id,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Course marked as completed!'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Mark as Complete'),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              CourseService().enrollInCourse(userId, course.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Successfully enrolled in course'),
                                ),
                              );
                            },
                            child: const Text('Enroll Now'),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Course Modules',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: course.modules.length,
              itemBuilder: (context, index) {
                final module = course.modules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.grey[600],
                      ),
                    ),
                    title: Text(module.title),
                    subtitle: Text('${module.duration} mins'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}