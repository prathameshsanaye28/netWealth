import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boardview/board_item.dart';
import 'package:flutter_boardview/board_list.dart';
import 'package:flutter_boardview/boardview.dart';
import 'package:flutter_boardview/boardview_controller.dart';

class KanbanDetailsScreen extends StatefulWidget {
  final String projectId;

  const KanbanDetailsScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  _KanbanDetailsScreenState createState() => _KanbanDetailsScreenState();
}

class _KanbanDetailsScreenState extends State<KanbanDetailsScreen> {
  final BoardViewController _boardViewController = BoardViewController();
  List<BoardList> _boardLists = [];
  late FirebaseFirestore _firestore;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _loadBoardData();
  }

  // Load the board data from Firestore
  Future<void> _loadBoardData() async {
    final boardDoc = await _firestore
        .collection('kanban_boards')
        .doc(widget.projectId)
        .get();
    if (boardDoc.exists) {
      final boardData = boardDoc.data();
      if (boardData != null) {
        List<BoardList> loadedLists = [];
        for (var list in boardData['lists']) {
          loadedLists.add(
            BoardList(
              header: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      list['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
              items: list['items']
                  .map<BoardItem>(
                    (item) => BoardItem(
                      item: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              backgroundColor: Colors.grey[200],
              headerBackgroundColor: Colors.blue[100],
            ),
          );
        }
        setState(() {
          _boardLists = loadedLists;
        });
      }
    }
  }

  // Add a new list
  Future<void> _addNewList() async {
    TextEditingController listController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New List"),
        content: TextField(
          controller: listController,
          decoration: const InputDecoration(labelText: "List Title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newList = BoardList(
                header: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        listController.text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
                items: [],
                backgroundColor: Colors.grey[200],
                headerBackgroundColor: Colors.blue[100],
              );
              setState(() {
                _boardLists.add(newList);
              });
              _updateFirestore();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Add a new item to a specific list
  Future<void> _addNewItem(int listIndex) async {
    TextEditingController itemController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Item"),
        content: TextField(
          controller: itemController,
          decoration: const InputDecoration(labelText: "Item Title"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newItem = BoardItem(
                item: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(itemController.text),
                  ),
                ),
              );
              setState(() {
                _boardLists[listIndex].items?.add(newItem);
              });
              _updateFirestore();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // Function to handle item reordering in Firestore
  Future<void> _updateFirestore() async {
    List<Map<String, dynamic>> firestoreLists = [];
    for (var boardList in _boardLists) {
      final headerText = (boardList.header?.first as Expanded).child as Padding;
      final listTitle = (headerText.child as Text).data ?? "Unnamed List";
      final items = boardList.items?.map((item) {
        final cardText = ((item.item as Card).child as Padding).child as Text;
        return cardText.data ?? "Unnamed Item";
      }).toList();
      firestoreLists.add({
        'title': listTitle,
        'items': items,
      });
    }
    await _firestore.collection('kanban_boards').doc(widget.projectId).set({
      'lists': firestoreLists,
    });
  }

  // Add functionality for moving items between lists
  void _onItemMoved(
      int fromListIndex, int toListIndex, int fromItemIndex, int toItemIndex) {
    // Reorder the items in the lists based on the drag-and-drop
    final item = _boardLists[fromListIndex].items![fromItemIndex];
    setState(() {
      // Remove the item from the source list
      _boardLists[fromListIndex].items!.removeAt(fromItemIndex);
      // Add the item to the destination list
      _boardLists[toListIndex].items!.insert(toItemIndex, item);
    });
    _updateFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanban Board"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewList,
          ),
        ],
      ),
      body: BoardView(
        lists: _boardLists,
        boardViewController: _boardViewController,
        // onItemTapped: (fromListIndex, toListIndex, fromItemIndex, toItemIndex) {
        //   _onItemMoved(fromListIndex, toListIndex, fromItemIndex, toItemIndex);
        // },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            _addNewItem(0), // Add item to the first list for demonstration
      ),
    );
  }
}
