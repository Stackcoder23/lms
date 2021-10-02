import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lms/ui/Login.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

enum role { student, teacher }

class _RegisterState extends State<Register> {
  bool _isHidden = true;
  String? school, course;
  role? _st = role.student;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  TextEditingController repasscontroller = new TextEditingController();

  registerUser() {
    bool isValid = EmailValidator.validate(emailcontroller.text);
    if (namecontroller.text != "" &&
        emailcontroller.text != "" &&
        passcontroller.text != "" &&
        repasscontroller.text != "" &&
        school != null) {
      if (isValid) {
        if (passcontroller.text == repasscontroller.text) {
          if (_st == role.student) {
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection("students")
                .doc(emailcontroller.text);

            Map<String, dynamic> map = <String, dynamic>{
              "name": namecontroller.text,
              "password": passcontroller.text,
              "school": school,
              "class": course
            };

            documentReference.set(map).whenComplete(() => {
                  print("$emailcontroller inserted"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  )
                });
          } else if (_st == role.teacher) {
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection("teachers")
                .doc(emailcontroller.text);

            Map<String, dynamic> map = <String, dynamic>{
              "name": namecontroller.text,
              "password": passcontroller.text,
              "school": school,
            };

            documentReference.set(map).whenComplete(() => {
                  print("$emailcontroller inserted"),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  )
                });
          }
        } else {
          showAlertDialog(context, "passwords doesn't match");
          print("passwords doesn't match");
        }
      } else {
        print("Email not Valid");
        showAlertDialog(context, "Please enter a valid email");
      }
    } else {
      showAlertDialog(context, "Fields cannot be empty");
      print("Cant be empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          )),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 15, left: 24, right: 24, bottom: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: ListTile(
                                  horizontalTitleGap: 2,
                                  title: Text(
                                    "Student",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  leading: Radio<role>(
                                    value: role.student,
                                    groupValue: _st,
                                    onChanged: (role? value) {
                                      setState(() {
                                        _st = value;
                                      });
                                    },
                                  ),
                                )),
                                Expanded(
                                    child: ListTile(
                                  horizontalTitleGap: 2,
                                  title: Text(
                                    "Teacher",
                                    style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  leading: Radio<role>(
                                    value: role.teacher,
                                    groupValue: _st,
                                    onChanged: (role? value) {
                                      setState(() {
                                        _st = value;
                                      });
                                    },
                                  ),
                                ))
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: namecontroller,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: "Name",
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Theme.of(context).hintColor,
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: emailcontroller,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: "Email ID",
                                  prefixIcon: Icon(
                                    Icons.account_circle,
                                    color: Theme.of(context).hintColor,
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: passcontroller,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                              enableSuggestions: false,
                              autocorrect: false,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: "Set Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).hintColor,
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: repasscontroller,
                              style: TextStyle(
                                color: Theme.of(context).accentColor,
                              ),
                              enableSuggestions: false,
                              autocorrect: false,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: _togglePasswordView,
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.black12,
                                  hintText: "Re-enter Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Theme.of(context).hintColor,
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: school,
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                                items: <String>[
                                  'School of Computer Science',
                                  // 'School of Management',
                                  // 'School of Science',
                                  // 'School of Arts',
                                  // 'School of Design'
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
                                  "Choose your School",
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 16,
                                  ),
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    school = value.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (_st == role.student)
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 8, bottom: 8),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                    "Choose your course",
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      course = value.toString();
                                    });
                                  },
                                ),
                              ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor),
                                  ),
                                  onPressed: () {
                                    registerUser();
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(fontSize: 20),
                                  )),
                            ),
                          ],
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  showAlertDialog(BuildContext context, String message) {
    // Create button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
