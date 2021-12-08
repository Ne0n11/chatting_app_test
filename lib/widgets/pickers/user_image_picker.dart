import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePicFn;

  UserImagePicker(this.imagePicFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
   File? _pickedImageFile;

  Future<void> _pickImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150 , maxWidth: 150);
    setState(() {
      _pickedImageFile = File(pickedImage!.path);
    });
    widget.imagePicFn(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
          ),
          TextButton.icon(
            onPressed: _pickImage,
            label: Text("Add image"),
            icon: Icon(Icons.image),
          ),
        ],
    );
  }
}
