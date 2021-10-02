import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/ui/Login.dart';
import 'package:lms/utils/globals.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String? sclass;

  void getclass() async{
    if(usertype == role.student.toString()) {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection("students").doc(
          userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          sclass = value.get("class");
        });
      }
      ).catchError((value) {
        setState(() {
          sclass = "error";
        });
      });
    }
    else{
      setState(() {
        sclass = "nothing";
      });
    }
  }

  _HomepageState(){
    getclass();
  }

  @override
  Widget build(BuildContext context) {
    if(usertype == role.student.toString()){
      if (sclass != null) {
        return Scaffold(
          backgroundColor: Theme
              .of(context)
              .backgroundColor,
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("courses").where(
                "class", isEqualTo: sclass).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.data!.size == 0){
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
                    onTap: (){ print(document.id); },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme
                              .of(context)
                              .primaryColor,
                          border:
                          Border.all(color: Theme
                              .of(context)
                              .accentColor, width: 2)),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        document.id,
                        style: TextStyle(color: Theme
                            .of(context)
                            .accentColor),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        );
      }
      else{
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }
    else if(usertype == role.teacher.toString()){
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add, color: Theme.of(context).accentColor,),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme
            .of(context)
            .backgroundColor,
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("courses").where(
              "teacher", isEqualTo: userLoggedIn.toString()).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.size == 0){
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
                  onTap: (){ print(document.id); },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme
                            .of(context)
                            .primaryColor,
                        border:
                        Border.all(color: Theme
                            .of(context)
                            .accentColor, width: 2)),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      document.id,
                      style: TextStyle(color: Theme
                          .of(context)
                          .accentColor),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }
    else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}



