import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_image_loader.dart';

class MyImagePicker extends StatefulWidget {
  final String? initialImageUrl;
  final File? initialFile;
  final Function(File?) onImagePicked;
  final VoidCallback onImageRemoved;

  const MyImagePicker({
    super.key,
    this.initialImageUrl,
    this.initialFile,
    required this.onImagePicked,
    required this.onImageRemoved,
  });

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialFile;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _removeImage();
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.onImagePicked(_selectedImage);
    }
  }

   void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    widget.onImageRemoved();
  }

  @override
  Widget build(BuildContext context) {
    MyBoxShadows shadows = MyBoxShadows();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    shadows.darkShadow(context),
                      shadows.lightShadow(context),
                  ],
                ),
                child: Center(
                  child: widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty
                      ? MyImageLoader(url: widget.initialImageUrl, size: 150)
                      : _selectedImage != null
                          ? MyImageLoader(file: _selectedImage!, size: 150)
                          : const SizedBox(
                              width: 150,
                              height: 150,
                              child: MyIcon(
                                icon: Icons.camera_alt,
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
        if (_selectedImage != null || (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty))
          GestureDetector(
            onTap: _removeImage,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          )
        else
                          const SizedBox(height: 15),
      ],
    );
  }
}
