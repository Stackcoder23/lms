import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GridView.count(
        padding: EdgeInsets.all(15),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2)),
            padding: EdgeInsets.all(10),
            child: Text(
              "Course 1",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2)),
            padding: EdgeInsets.all(10),
            child: Text(
              "Course 2",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
