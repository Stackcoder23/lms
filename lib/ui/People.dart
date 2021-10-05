import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/ui/Login.dart';
import 'package:lms/utils/globals.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  String? school;
  List<DocumentSnapshot> datas = <DocumentSnapshot>[];

  void getSchool() async{
    if(usertype == role.teacher.toString()) {
      DocumentReference documentReference =
        FirebaseFirestore.instance.collection("teachers").doc(
      userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          school = value.get("school");
        });
       }
      ).catchError((value) {
        setState(() {
          school = "error";
        });
      });

      QuerySnapshot snap1 =
      await FirebaseFirestore.instance.collection("teachers").where(
          "school", isEqualTo: school).get();
      setState(() {
        datas.addAll(snap1.docs);
      });

      QuerySnapshot snap =
      await FirebaseFirestore.instance.collection("students").where(
          "school", isEqualTo: school).get();
      setState(() {
        datas.addAll(snap.docs);
      });
    }
    else if(usertype == role.student.toString()) {
      DocumentReference documentReference =
      FirebaseFirestore.instance.collection("students").doc(
          userLoggedIn.toString());
      documentReference.get().then((value) {
        setState(() {
          school = value.get("school");
        });
      }
      ).catchError((value) {
        setState(() {
          school = "error";
        });
      });
      QuerySnapshot snap1 =
      await FirebaseFirestore.instance.collection("teachers").where(
          "school", isEqualTo: school).get();
      setState(() {
        datas.addAll(snap1.docs);
      });

        QuerySnapshot snap =
        await FirebaseFirestore.instance.collection("students").where(
            "school", isEqualTo: school).get();
        setState(() {
          datas.addAll(snap.docs);
        });
    }

    else{
      setState(() {
        school = "nothing";
      });
    }
  }

  _PeopleState(){
    getSchool();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: datas.length,
            itemBuilder: (context, index){
              try{
                return ListTile(
                  trailing: Text("Student", style: TextStyle(color: Theme.of(context).accentColor),),
                  title: Text('${datas[index]["name"]}', style: TextStyle(color: Theme.of(context).accentColor)),
                  subtitle: Text('${datas[index]["class"]}', style: TextStyle(color: Theme.of(context).accentColor)),
                );
              }
              catch(Exception){
                return ListTile(
                  trailing: Text("Teacher", style: TextStyle(color: Theme.of(context).accentColor)),
                  title: Text('${datas[index]["name"]}', style: TextStyle(color: Theme.of(context).accentColor)),
                );
              }
            }),
      )
    );
  }
}
