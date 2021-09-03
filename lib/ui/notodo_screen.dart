import 'package:flutter/material.dart';
import 'package:lms/model/nodo_item.dart';
import 'package:lms/utils/database_client.dart';


class NoToDoScreen extends StatefulWidget {
  const NoToDoScreen({Key? key}) : super(key: key);

  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController _textEditingController =
  new TextEditingController();
  var db = new DatabaseHelper();

  final List<NoDoItem> itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();

    _readNoDoList();
  }

  void _handleSubmit(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem = new NoDoItem(text, DateTime.now().toIso8601String());
    int savedItem = await db.saveItem(noDoItem);
    Navigator.pop(context);
    _readNoDoList();
    // NoDoItem addedItem = await db.getItem(savedItem);
    //
    // setState(() {
    //   itemList.insert(0, addedItem);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:
      itemList.isEmpty
          ? Center(
        child: Text(
          "Empty",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      )
          :
      Column(
        children: [
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  reverse: false,
                  itemCount: itemList.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      color: Theme.of(context).primaryColor,
                      child: ListTile(
                        title: itemList[index],
                        onLongPress: () =>
                            _updateNoDo(itemList[index], index),
                        trailing: Listener(
                          key: Key(itemList[index].itemName.toString()),
                          child: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPointerDown: (pointerEvent) =>
                              _deleteNoDo(itemList[index].id!.toInt()),
                        ),
                      ),
                    );
                  })),
          Divider(
            height: 1,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: new Icon(Icons.add, color: Theme.of(context).accentColor,),
          tooltip: "Add item",
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _textEditingController,
                autofocus: true,
                style: TextStyle(
                  color: Theme.of(context).accentColor
                ),
                decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "Add NoToDo",
                  icon: Icon(Icons.note_add),
                ),
              ))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              _handleSubmit(_textEditingController.text);
              _textEditingController.clear();
            },
            child: Text("Save")),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readNoDoList() async {
    List items = await db.getItems();
    itemList.clear();
    items.forEach((item) {
      setState(() {
        itemList.add(NoDoItem.map(item));
      });
      // NoDoItem noDoItem = NoDoItem.map(item);
      // print("Db Items: ${noDoItem.itemName}");
    });
  }

  _deleteNoDo(int id) async {
    await db.deleteItem(id);
    _readNoDoList();
    (context as Element).reassemble();
  }

  _updateNoDo(NoDoItem itemList, int index) async {
    var alert = new AlertDialog(
      title: Text("Update Item"),
      content: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Item",
                  hintText: "Add NoToDo",
                  icon: Icon(Icons.update_outlined),
                ),
              ))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              NoDoItem itemUpdated = NoDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": DateTime.now().toIso8601String(),
                "id": itemList.id,
              });
              await db.updateItem(itemUpdated);
              _readNoDoList();
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Update")),
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }
}
