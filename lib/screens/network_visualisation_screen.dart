import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/match_details.dart';
import 'package:netwealth_vjti/resources/matcher_service.dart';

import '../models/professional.dart';

class NetworkService {
  final FirebaseFirestore _firestore;
  final MatcherService _matcherService;

  NetworkService({
    FirebaseFirestore? firestore,
    MatcherService? matcherService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _matcherService = matcherService ?? MatcherService();

  Future<Professional?> getRootUser() async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc('vdpMVD2MLVSmPIIWTx3ko3pNC0I2')
          .get();

      if (!docSnapshot.exists) return null;
      return Professional.fromSnap(docSnapshot);
    } catch (e) {
      print('Error fetching root user: $e');
      return null;
    }
  }

  Future<List<Professional>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => Professional.fromSnap(doc))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<List<ScoredCandidate>> getTopConnections(
      Professional user, int limit) async {
    try {
      final allUsers = await getAllUsers();
      final candidates = allUsers.where((u) => u.id != user.id).toList();

      final matches = await _matcherService.findMatches(user, candidates);
      matches.sort((a, b) => b.score.compareTo(a.score));

      return matches.take(limit).toList();
    } catch (e) {
      print('Error getting top connections: $e');
      return [];
    }
  }
}

class NetworkVisualizationScreen extends StatefulWidget {
  const NetworkVisualizationScreen({Key? key}) : super(key: key);

  @override
  _NetworkVisualizationScreenState createState() =>
      _NetworkVisualizationScreenState();
}

class _NetworkVisualizationScreenState
    extends State<NetworkVisualizationScreen> {
  final NetworkService _networkService = NetworkService();
  Professional? _rootUser;
  final Map<String, List<ScoredCandidate>> _expandedNodes = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeNetwork();
  }

  Future<void> _initializeNetwork() async {
    setState(() => _isLoading = true);
    try {
      final rootUser = await _networkService.getRootUser();
      if (rootUser != null) {
        final topConnections =
            await _networkService.getTopConnections(rootUser, 5);
        setState(() {
          _rootUser = rootUser;
          _expandedNodes[rootUser.id!] = topConnections;
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _expandNode(Professional node) async {
    if (_expandedNodes.containsKey(node.id)) return;

    setState(() => _isLoading = true);
    try {
      final connections = await _networkService.getTopConnections(node, 5);
      setState(() {
        _expandedNodes[node.id!] = connections;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUserDetails(BuildContext context, Professional user,
      [ScoredCandidate? candidate]) {
    final matchScore = candidate?.score ?? 0.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null
                        ? Text(user.name?.substring(0, 1).toUpperCase() ?? '?')
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.name} (${user.role})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (candidate != null)
                          Text(
                            'Match Score: ${(matchScore * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: Colors.green.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Experience: ${user.yearsExperience} years'),
              if (user.technicalSkills.isNotEmpty)
                Text('Skills: ${user.skillsPreview}'),
              if (user.regulatoryExpertise.isNotEmpty)
                Text(
                    'Regulatory: ${user.regulatoryExpertise.take(2).join(", ")}'),
              Text('Jurisdiction: ${user.jurisdiction}'),
            ],
          ),
        ),
        //duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.grey.shade900,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_rootUser == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load network')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Network'),
        backgroundColor: Color.fromRGBO(224, 226, 248, 1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(224, 226, 248, 1),
              Color.fromRGBO(188, 191, 236, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: NetworkVisualizationWidget(
          rootUser: _rootUser!,
          expandedNodes: _expandedNodes,
          onNodeTap: (user, candidate) {
            _expandNode(user);
            _showUserDetails(context, user, candidate);
          },
        ),
      ),
    );
  }
}

class NetworkVisualizationWidget extends StatefulWidget {
  final Professional rootUser;
  final Map<String, List<ScoredCandidate>> expandedNodes;
  final Function(Professional, ScoredCandidate?) onNodeTap;

  const NetworkVisualizationWidget({
    Key? key,
    required this.rootUser,
    required this.expandedNodes,
    required this.onNodeTap,
  }) : super(key: key);

  @override
  _NetworkVisualizationWidgetState createState() =>
      _NetworkVisualizationWidgetState();
}

class _NetworkVisualizationWidgetState
    extends State<NetworkVisualizationWidget> {
  final Map<String, Offset> _nodePositions = {};
  double _scale = 1.0;
  Offset _position = Offset.zero;

  @override
  void initState() {
    super.initState();
    _calculatePositions();
  }

  @override
  void didUpdateWidget(NetworkVisualizationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculatePositions();
  }

  void _calculatePositions() {
    const centerX = 200.0;
    const centerY = 400.0;
    _nodePositions.clear();

    _nodePositions[widget.rootUser.id!] = const Offset(centerX, centerY);

    widget.expandedNodes.forEach((parentId, connections) {
      final parentPos = _nodePositions[parentId]!;
      final radius = 150.0;
      final angleStep = 2 * math.pi / connections.length;

      for (var i = 0; i < connections.length; i++) {
        final angle = i * angleStep;
        final x = parentPos.dx + radius * math.cos(angle);
        final y = parentPos.dy + radius * math.sin(angle);
        _nodePositions[connections[i].professional.id!] = Offset(x, y);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        setState(() {
          _scale *= details.scale;
          _position += details.focalPointDelta;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(224, 226, 248, 1),
              Color.fromRGBO(200, 202, 240, 1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomPaint(
          painter: NetworkPainter(
            rootUser: widget.rootUser,
            expandedNodes: widget.expandedNodes,
            nodePositions: _nodePositions,
            scale: _scale,
            position: _position,
          ),
          child: Stack(
            children: _buildNodes(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNodes() {
    final nodes = <Widget>[];

    Widget buildNodeWidget(Professional user, bool isRoot,
        [ScoredCandidate? candidate]) {
      return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isRoot ? Colors.blue.shade700 : Colors.blue.shade500,
              width: 3,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     spreadRadius: 1,
            //     blurRadius: 3,
            //     offset: const Offset(0, 2),
            //  ),
            //],
          ),
          child: CircleAvatar(
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(
                      user.photoUrl!,
                    )
                  : NetworkImage(
                      "https://w7.pngwing.com/pngs/867/694/png-transparent-user-profile-default-computer-icons-network-video-recorder-avatar-cartoon-maker-blue-text-logo-thumbnail.png"))
          // ClipOval(
          //   child: Stack(
          //     children: [
          //       if (user.photoUrl != null)
          //         Image.network(
          //           user.photoUrl!,
          //           height: 80,
          //           width: 80,
          //           errorBuilder: (context, error, stackTrace) =>
          //               _buildFallbackAvatar(user, isRoot),
          //         )
          //       else
          //         _buildFallbackAvatar(user, isRoot),

          //     ],
          //   ),
          // ),
          );
    }

    void addNode(Professional user, bool isRoot, [ScoredCandidate? candidate]) {
      final pos = _nodePositions[user.id!]!;
      nodes.add(
        Positioned(
          left: pos.dx - 30,
          top: pos.dy - 30,
          child: GestureDetector(
            onTap: () => widget.onNodeTap(user, candidate),
            child: buildNodeWidget(user, isRoot, candidate),
          ),
        ),
      );
    }

    addNode(widget.rootUser, true);

    widget.expandedNodes.forEach((_, connections) {
      for (final connection in connections) {
        addNode(connection.professional, false, connection);
      }
    });

    return nodes;
  }

  Widget _buildFallbackAvatar(Professional user, bool isRoot) {
    return Container(
      color: isRoot ? Colors.blue.shade700 : Colors.blue.shade500,
      child: Center(
        child: Text(
          user.name?.substring(0, 1).toUpperCase() ?? '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NetworkPainter extends CustomPainter {
  final Professional rootUser;
  final Map<String, List<ScoredCandidate>> expandedNodes;
  final Map<String, Offset> nodePositions;
  final double scale;
  final Offset position;

  NetworkPainter({
    required this.rootUser,
    required this.expandedNodes,
    required this.nodePositions,
    required this.scale,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(position.dx, position.dy);
    canvas.scale(scale);

    final paint = Paint()
      ..color = Colors.blue.shade200.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    expandedNodes.forEach((parentId, connections) {
      final parentPos = nodePositions[parentId]!;
      for (final connection in connections) {
        final childPos = nodePositions[connection.professional.id!]!;
        canvas.drawLine(parentPos, childPos, paint);
      }
    });
  }

  @override
  bool shouldRepaint(NetworkPainter oldDelegate) => true;
}
