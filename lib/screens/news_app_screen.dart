// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';



// class NewsScreen extends StatefulWidget {
//   const NewsScreen({super.key});

//   @override
//   _NewsScreenState createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   List<dynamic> _articles = [];
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     fetchNews();
//   }

//   Future<void> fetchNews() async {
//     const String apiKey = '81b3ccc3ba2948d5882e71217430cd73';
//     const String apiUrl =
//         'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$apiKey';

//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $apiKey',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         // Check if the API returned an error
//         if (data['status'] == 'error') {
//           throw Exception(data['message'] ?? 'API returned an error');
//         }

//         if (data['articles'] == null) {
//           throw Exception('No articles found in the response');
//         }

//         setState(() {
//           _articles = data['articles'];
//           _isLoading = false;
//           _error = null;
//         });
//       } else if (response.statusCode == 401) {
//         throw Exception('Invalid API key. Please check your API key.');
//       } else if (response.statusCode == 429) {
//         throw Exception('Request limit exceeded. Please try again later.');
//       } else {
//         throw Exception(
//             'Failed to load news. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _error = e.toString();
//       });
//       debugPrint('Error fetching news: $e');
//     }
//   }

//   Future<void> _openUrl(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.inAppWebView);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Could not open $url')),
//         );
//       }
//     }
//   }

//   Widget _buildErrorWidget() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.red,
//               size: 60,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _error ?? 'An error occurred',
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.red),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _isLoading = true;
//                   _error = null;
//                 });
//                 fetchNews();
//               },
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Business News'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 _isLoading = true;
//                 _error = null;
//               });
//               fetchNews();
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? _buildErrorWidget()
//               : RefreshIndicator(
//                   onRefresh: fetchNews,
//                   child: ListView.builder(
//                     itemCount: _articles.length,
//                     itemBuilder: (context, index) {
//                       final article = _articles[index];
//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         child: InkWell(
//                           onTap: () {
//                             if (article['url'] != null) {
//                               //_openUrl(article['url']);
//                             }
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (article['urlToImage'] != null)
//                                 ClipRRect(
//                                   borderRadius: const BorderRadius.vertical(
//                                     top: Radius.circular(4),
//                                   ),
//                                   child: Image.network(
//                                     article['urlToImage'],
//                                     height: 200,
//                                     width: double.infinity,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Container(
//                                         height: 200,
//                                         color: Colors.grey[200],
//                                         child: const Icon(Icons.error),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       article['title'] ?? 'No Title',
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     if (article['description'] != null)
//                                       Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 8.0),
//                                         child: Text(
//                                           article['description'],
//                                           maxLines: 3,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NewsScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> _articles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const String apiKey = '8450313c087f1b804f411e6786c037c3';
    // const String apiUrl =
    //     'https://gnews.io/api/v4/top-headlines?category=business&apikey=$apiKey';
    const String apiUrl = kIsWeb 
    ? 'https://cors-anywhere.herokuapp.com/https://gnews.io/api/v4/top-headlines?category=business&lang=en&apikey=$apiKey'
    : 'https://gnews.io/api/v4/top-headlines?category=business&lang=en&country=in&apikey=$apiKey';
    // const String apiUrl =
    //     'https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$apiKey';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the API returned an error
        // if (data['status'] == 'error') {
        //   throw Exception(data['message'] ?? 'API returned an error');
        // }

        if (data['articles'] == null) {
          throw Exception('No articles found in the response');
        }

        setState(() {
          _articles = data['articles'];
          _isLoading = false;
          _error = null;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your API key.');
      } else if (response.statusCode == 429) {
        throw Exception('Request limit exceeded. Please try again later.');
      } else {
        debugPrint('Response body: ${response.body}');
        throw Exception(
            'Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      debugPrint('Error fetching news: $e');

      if (e.toString().contains('XMLHttpRequest')) {
        setState(() {
          _error = 'Network error: Please check your internet connection and try again.';
        });
      }
    }
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              _error ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                fetchNews();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _error = null;
              });
              fetchNews();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: fetchNews,
                  child: ListView.builder(
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      final article = _articles[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            if (article['url'] != null) {
                              _openUrl(article['url']);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (article['image'] != null)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: Image.network(
                                    article['image'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.error),
                                      );
                                    },
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'] ?? 'No Title',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (article['description'] != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          article['description'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}