import 'package:flutter/material.dart';
import 'package:lms/main.dart';
import 'package:lms/ui/Register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lms/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

enum role { student, teacher }

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    getLoggedIn();
    super.initState();
  }

  bool _isHidden = true;
  late String username;
  late String pass;
  role? _st = role.student;

  getUserName(username) {
    this.username = username;
  }

  getPass(pass) {
    this.pass = pass;
  }

  void saveUser() async {
    final SharedPreferences loggedIn = await SharedPreferences.getInstance();
    loggedIn.setString('username', username);
    loggedIn.setString('usertype', _st.toString());
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<void> getLoggedIn() async {
    final SharedPreferences loggedIn = await SharedPreferences.getInstance();
    setState(() {
      userLoggedIn = loggedIn.getString('username');
    });
    // userLoggedIn != null ? Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => Home())
    // ) : null;
  }

  void loginUser() {
    DocumentReference? documentReference;
    if (_st == role.student) {
      documentReference =
          FirebaseFirestore.instance.collection("students").doc(username);
    } else if (_st == role.teacher) {
      documentReference =
          FirebaseFirestore.instance.collection("teachers").doc(username);
    }
    documentReference!
        .get()
        .then((value) => value.get("password") == pass
            ? saveUser()
            : print("Incorrect password"))
        .catchError((value) => print("User does not exist"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userLoggedIn != null
          ? Home()
          : SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 36, horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Welcome to LMS",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              )),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: ListTile(
                                      horizontalTitleGap: -8,
                                      title: Text("Student"),
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
                                      horizontalTitleGap: -8,
                                      title: Text("Teacher"),
                                      leading: Radio<role>(
                                        value: role.teacher,
                                        groupValue: _st,
                                        onChanged: (role? value) {
                                          setState(() {
                                            _st = value;
                                          });
                                        },
                                      ),
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  onChanged: (username) {
                                    getUserName(username);
                                  },
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
                                  onChanged: (pass) {
                                    getPass(pass);
                                  },
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
                                      hintText: "Password",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Theme.of(context).hintColor,
                                      )),
                                ),
                                SizedBox(
                                  height: 70,
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
                                        loginUser();
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) => Home()),
                                        // );
                                      },
                                      child: Text(
                                        "login",
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                      style: ButtonStyle(),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Register()),
                                        );
                                      },
                                      child: Text(
                                        "Create an account!!!",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color:
                                                Theme.of(context).accentColor),
                                      )),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                      style: ButtonStyle(),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Register()),
                                        );
                                      },
                                      child: Text(
                                        "Admin Login",
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.underline,
                                            color:
                                            Theme.of(context).accentColor),
                                      )),
                                ),
                              ],
                            ),
                          )),
                    ),
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
}
