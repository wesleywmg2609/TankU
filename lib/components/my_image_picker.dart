import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanku/components/my_box_shadow.dart';
import 'package:tanku/components/my_icon.dart';
import 'package:tanku/components/my_image_loader.dart';
import 'package:tanku/services/image_service.dart';
import 'package:tanku/services/tank_service.dart';

// ignore: must_be_immutable
class MyImagePicker extends StatefulWidget {
  String? imageUrl;
  DatabaseReference? tankRef;

  MyImagePicker({
    super.key,
    this.imageUrl,
    this.tankRef,
  });

  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  late TankService _tankService;
  late ImageService _imageService;
  String? _imageUrl;

  @override
  void initState() {
    _tankService = Provider.of<TankService>(context, listen: false);
    _imageService = Provider.of<ImageService>(context, listen: false);

    if (widget.imageUrl != null) {
      _imageService.imageUrl = widget.imageUrl;
      _imageUrl = widget.imageUrl;
    }

    super.initState();

    _imageService.addListener(() {
      if (mounted) {
        setState(() {
          _imageUrl = _imageService.imageUrl;
        });
      }
    });
  }

  @override
  void dispose() {
    _imageService.removeListener(() {});
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final String? newImageUrl = await _imageService.uploadImage();
    if (newImageUrl != null) {
      if (_imageUrl != null) {
        await _tankService.removeImageFromDatabase(widget.tankRef!);
        await _imageService.deleteImage(_imageUrl!);
      }
      setState(() {
        _imageUrl = newImageUrl;
      });
    }
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
              onTap: _pickAndUploadImage,
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
                  child: _imageUrl != null && _imageUrl!.isNotEmpty
                      ? MyImageLoader(url: _imageUrl, size: 150)
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
        if (_imageUrl != null && _imageUrl!.isNotEmpty)
          GestureDetector(
            onTap: () async {
              if (_imageUrl != null) {
                await _tankService.removeImageFromDatabase(widget.tankRef!);
                await _imageService.deleteImage(_imageUrl!);
                setState(() {
                  _imageUrl = null;
                });
              }
            },
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
