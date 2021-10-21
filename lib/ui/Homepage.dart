import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/ui/CourseDetails.dart';
import 'package:lms/ui/Login.dart';
import 'package:lms/utils/globals.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? sclass, course;
  TextEditingController _courseName = new TextEditingController();

  void getclass() async {
    if (usertype == role.student.toString()) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("students")
          .doc(userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          sclass = value.get("class");
        });
      }).catchError((value) {
        setState(() {
          sclass = "error";
        });
      });
    } else {
      setState(() {
        sclass = "nothing";
      });
    }
  }

  _HomepageState() {
    getclass();
  }

  @override
  Widget build(BuildContext context) {
    if (usertype == role.student.toString()) {
      if (sclass != null) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("courses")
                .where("class", isEqualTo: sclass)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.size == 0) {
                return Center(
                  child: Text("No courses enrolled"),
                );
              }
              return GridView.count(
                padding: EdgeInsets.all(15),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                children: snapshot.data!.docs.map((document) {
                  return InkWell(
                    onTap: () {
                      openCourse(document.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                              color: Theme.of(context).accentColor, width: 2)),
                      // padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                              child: Image(
                                width: double.infinity,
                                fit: BoxFit.cover,
                              image: AssetImage('assets/course.jpg'),
                          )),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                document.id,
                                style:
                                    TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else if (usertype == role.teacher.toString()) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addCourse();
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("courses")
              .where("teacher", isEqualTo: userLoggedIn.toString())
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return Center(
                child: Text("No courses"),
              );
            }
            return GridView.count(
              padding: EdgeInsets.all(15),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: snapshot.data!.docs.map((document) {
                return InkWell(
                  onTap: () {
                    openCourse(document.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                            color: Theme.of(context).accentColor, width: 2)),
                    // padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Image(
                              width: double.infinity,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/course.jpg'),
                            )),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              document.id,
                              style:
                              TextStyle(color: Theme.of(context).accentColor, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void _addCourse() {
    var alert = new AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _courseName,
            autofocus: true,
            style: TextStyle(color: Theme.of(context).accentColor),
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter course name",
              icon: Icon(Icons.book),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: course,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
              items: <String>[
                'FYMCA',
                'SYMCA',
                'TYMCA',
                'FYMsc BDA',
                'SYMsc BDA',
                'FYMsc',
                'SYMsc',
                'FYBsc',
                'SYBsc',
                'TYBsc',
                'FYBCA',
                'SYBCA',
                'TYBCA'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                "Select course",
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
              ),
              onChanged: (String? value) {
                setState(() {
                  course = value.toString();
                });
                Navigator.pop(context);
                _addCourse();
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              _handleSubmit(_courseName.text);
              _courseName.clear();
            },
            child: Text("Add")),
        TextButton(
            onPressed: () {
              _courseName.clear();
              course = null;
              Navigator.pop(context);
            },
            child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    if (_courseName.text != "" && course != null) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("courses")
          .doc(_courseName.text);

      Map<String, dynamic> map = <String, dynamic>{
        "class": course,
        "teacher": userLoggedIn.toString()
      };
      documentReference.set(map).whenComplete(
          () => {print("$_courseName inserted"), Navigator.pop(context)});
    }
    _courseName.clear();
    course = null;
  }

  void openCourse(String id) {
    print(id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CourseDetails(id: id)),
    );
  }
}
