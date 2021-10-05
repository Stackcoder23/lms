import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:lms/model/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file){
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }


  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async{
    final ref1 = FirebaseStorage.instance.ref(path);
    final res = await ref1.listAll();

    final urls = await _getDownloadLinks(res.items);

      return urls
          .asMap()
          .map((index, url) {
        final ref1 = res.items[index];
        final name = ref1.name;
        final file = FirebaseFile(ref: ref1, name: name, url: url);
        return MapEntry(index, file);
      })
          .values
          .toList();
  }

  static Future downloadFile(Reference ref ,String url) async {

    // final taskId = await FlutterDownloader.enqueue(
    //   url: url,
    //   savedDir: 'downloads/',
    //   showNotification: true, // show download progress in status bar (for Android)
    //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    // );
  }

}