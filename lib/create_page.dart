import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePage extends StatefulWidget {
  final User user;

  CreatePage(this.user);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  File? _image;

  Future _getImage() async {
    final imagePicker = ImagePicker();
    print('클릭 되나');
    var image = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시물'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.send),
            tooltip: '다음',
            onPressed: () {
              print('클릭');

              final firebaseStorageRef = FirebaseStorage.instance
                  .ref()
                  .child('post')
                  .child('${DateTime.now().millisecondsSinceEpoch}.png');

              final task = firebaseStorageRef.putFile(_image!);
              //   (_image!, StorageMetadata(contentType: 'image/png'));
              task.whenComplete(() => null).then((value) {
                var downloadUrl = value.ref.getDownloadURL();

                downloadUrl.then((uri) {
                  var doc = FirebaseFirestore.instance
                      .collection('post')
                      .doc();

                  doc.set({
                    // 'id': doc.documentID,
                    'photoUrl': uri.toString(),
                    'contents': textEditingController.text,
                    'email': widget.user.email,
                    'displayName': widget.user.displayName,
                    // 'userPhotoUrl': widget.user.photoUrl,
                  }).then((onValue) {
                    // 완료 후 앞 화면으로 이동
                    Navigator.pop(context);
                  });
                });
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildBody(),
            TextField(
              decoration: const InputDecoration(hintText: '내용을 입력하세요'),
              controller: textEditingController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildBody() {
    return _image == null ? const Text('No Image') : Image.file(_image!);
  }
}