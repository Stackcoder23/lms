import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/ui/Homepage.dart';
import 'package:lms/ui/Login.dart';
import 'package:lms/ui/People.dart';
import 'package:lms/ui/notodo_screen.dart';
import 'package:lms/utils/globals.dart';
import 'package:lms/widget/change_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String? sname;

  void getName() async {
    if (usertype == role.student.toString()) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("students")
          .doc(userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          sname = value.get("name");
        });
      }).catchError((value) {
        setState(() {
          sname = "error";
        });
      });
    } else if (usertype == role.teacher.toString()) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("teachers")
          .doc(userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          sname = value.get("name");
        });
      }).catchError((value) {
        setState(() {
          sname = "error";
        });
      });
    }
  }

  _HomeState() {
    getName();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    NoToDoScreen(),
    People()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("LMS"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                      image: AssetImage('assets/user.png'),
                      width: 60,

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Text(
                      sname.toString(),
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                "Dark Mode",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              trailing: ChangeThemeButtonWidget(),
            ),
            ListTile(
              title: Text(
                "About Us",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            ListTile(
              onTap: () async {
                final SharedPreferences loggedIn =
                    await SharedPreferences.getInstance();
                loggedIn.remove("username");
                loggedIn.remove("usertype");
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              title: Text(
                "Logout",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Center(
      //   child: Text(
      //     "Hello",
      //     style: TextStyle(color: Theme.of(context).accentColor),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(opacity: 20, size: 25),
        unselectedIconTheme: IconThemeData(opacity: 0.5, size: 15),
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: "To-Do"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "People")
        ],
      ),
    );
  }
}
