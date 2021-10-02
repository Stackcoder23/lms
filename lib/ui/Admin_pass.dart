import 'package:flutter/material.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  bool _isHidden = true;
  late String pass;

  getPass(pass) {
    this.pass = pass;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
            width: 300,
            child:
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
          ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.all(40),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    //loginUser();
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
          ]
        ),
      ),
    );
  }
  void _togglePasswordView() async {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}


