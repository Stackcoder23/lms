import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lms/model/firebase_file.dart';
import 'package:lms/provider/FirebaseApi.dart';
import 'package:lms/ui/Login.dart';
import 'package:lms/ui/People.dart';
import 'package:lms/utils/globals.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({Key? key, required this.id}) : super(key: key);

  final String? id;

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  late Future<List<FirebaseFile>> futureFiles;

  int progress = 0;
  ReceivePort receivePort = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(receivePort.sendPort, 'downloading');

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);

    String cn = widget.id.toString();
    futureFiles = FirebaseApi.listAll('$cn/');
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort!.send(progress);
  }

  String? cid;
  File? file;
  String? cname;

  @override
  Widget build(BuildContext context) {
    cname = widget.id.toString();

    //print(cid);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(cname!),
          actions: [
            if (usertype == role.teacher.toString())
              IconButton(
                  onPressed: () {
                    addFileDialogue();
                  },
                  icon: Icon(Icons.add_circle_outline))
          ],
        ),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text("some error occurred"));
                } else {
                  final files = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12),
                      Expanded(
                          child: RefreshIndicator(
                        onRefresh: () {
                          return Future.delayed(
                              Duration(seconds: 1),
                                  () {
                                    setState(() {
                                      futureFiles = FirebaseApi.listAll('$cname/');
                                    });
                                  });
                        },
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            return buildFile(context, file);
                          },
                        ),
                      ))
                    ],
                  );
                }
            }
          },
        ));
  }

  Widget buildHeader(int length) => ListTile(
        tileColor: Theme.of(context).primaryColor,
        leading: Container(
          width: 52,
          height: 52,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        trailing: IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () async {
            download(file.ref, file.url);
            // await FirebaseApi.downloadFile(file.ref, file.url);
            //
            // final snackbar = SnackBar(content: Text("Downloaded ${file.name}"));
            // ScaffoldMessenger.of(context).showSnackBar(snackbar);
          },
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        // onTap: () async {
        //   await launch(
        //     file.url,
        //     forceSafariVC: true,
        //     forceWebView: true,
        //     enableJavaScript: true,
        //   );
        // },
      );

  void addFileDialogue() {
    final filename =
        file != null ? file!.path.split('/').last : 'No file selected';
    var alert = new AlertDialog(
      title: Text(
        "Upload a file",
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              selectfile();
            },
            child: Row(
              children: [
                Icon(Icons.file_present),
                SizedBox(width: 10),
                Text("Choose"),
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
          ),
          Text(filename),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              uploadFile();
            },
            child: Row(
              children: [
                Icon(Icons.cloud_upload),
                SizedBox(width: 10),
                Text("Upload"),
              ],
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              file = null;
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

  Future selectfile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
      Navigator.pop(context);
      addFileDialogue();
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final filename = file!.path.split('/').last;
    final destination = '$cname/$filename';

    FirebaseApi.uploadFile(destination, file!)!.whenComplete(() async {
      Navigator.pop(context);
      file = null;
      futureFiles = FirebaseApi.listAll('$cname/');
    });
  }

  void download(Reference ref, String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
              url: url, savedDir: baseStorage!.path, fileName: ref.name)
          .whenComplete(() {
        final snackbar = SnackBar(content: Text("Downloaded file"));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      });
    } else {
      print('No permission');
    }
  }
}
