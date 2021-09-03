import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget {
  String? _itemName;
  String? _dateCreated;
  int? _id;

  NoDoItem(this._itemName, this._dateCreated);

  NoDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String? get itemName => _itemName;

  String? get dateCreated => _dateCreated;

  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["dateCreated"] = _dateCreated;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _itemName!,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            child: Text("Created on $_dateCreated",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 14,
                  fontStyle: FontStyle.italic
              ),),
          )
        ],
      ),
    );
  }
}
