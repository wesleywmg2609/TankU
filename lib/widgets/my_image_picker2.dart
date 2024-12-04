import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:tanku/services/image_service.dart';
import 'package:tanku/widgets/my_button2.dart';

class MyImagePicker2 extends StatefulWidget {
  const MyImagePicker2({super.key});

  @override
  State<MyImagePicker2> createState() => _MyImagePicker2State();
}

class _MyImagePicker2State extends State<MyImagePicker2> {
  late ImageService _imageService;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _imageService = Provider.of<ImageService>(context, listen: false);

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async => await _imageService.uploadImage(),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: _imageUrl != null && _imageUrl!.isNotEmpty
                  ? Image.network(_imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Ionicons.image))
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xffffffff)),
                      width: 150,
                      height: 150,
                      child: const Icon(Ionicons.image)),
            ),
          ),
        ),
        if (_imageUrl != null && _imageUrl!.isNotEmpty) ...[
          const SizedBox(height: 10),
          MyButton2(
              icon: Ionicons.close_circle,
              onTap: () async {
                if (_imageUrl != null) {
                  await _imageService.deleteImage(_imageUrl!);
                }
              },
              color: Colors.red)
        ]
      ],
    );
  }
}
