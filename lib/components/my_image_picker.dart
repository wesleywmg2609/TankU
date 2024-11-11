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
  MyBoxShadows shadows = MyBoxShadows();
  late TankService _tankService;
  late ImageService _imageService;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _tankService = Provider.of<TankService>(context, listen: false);
    _imageService = Provider.of<ImageService>(context, listen: false);

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      _imageService.imageUrl = widget.imageUrl;
    } else {
      _imageService.imageUrl = null;
    }

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

  _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async => await _imageService.uploadImage(),
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
                      child: MyIcon(icon: Icons.camera_alt)),
            ),
          ),
        ),
      ],
    );
  }

  _buildDeleteButton() {
    return GestureDetector(
      onTap: () async {
        if (_imageUrl != null) {
          if (widget.tankRef != null) {
            await _tankService.updateImageUrlInTankRef(widget.tankRef!);
          }
          await _imageService.deleteImage(_imageUrl!);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: MyIcon(
          icon: Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildImagePicker(),
        if (_imageUrl != null && _imageUrl!.isNotEmpty)
          _buildDeleteButton()
        else
          const SizedBox(height: 15),
      ],
    );
  }
}
