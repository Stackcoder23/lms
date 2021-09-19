import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

enum role { student, teacher}

class _RegisterState extends State<Register> {
  bool _isHidden = true;
  String? school, course;
  role? _st = role.student;

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
                        padding: EdgeInsets.only(top: 15, left: 24, right: 24, bottom: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child : ListTile(
                                      horizontalTitleGap: 2,
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
                                    )
                                ),
                                Expanded(
                                    child : ListTile(
                                      horizontalTitleGap: 2,
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
                                    )
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
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
                                  'School of Management',
                                  'School of Science',
                                  'School of Arts',
                                  'School of Design'
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
                                  'Msc',
                                  'Msc BDA',
                                  'Msc DS'
                                  'MCA',
                                  'Bsc',
                                  'BCA'
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
                                  "Choose your Program",
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
                                  onPressed: () {},
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
}
