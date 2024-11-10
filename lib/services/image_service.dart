import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService with ChangeNotifier {
  String? _imageUrl;
  bool _isUploading = false;
  final List<VoidCallback> _listeners = [];

  String? get imageUrl => _imageUrl;
  bool get isUploading => _isUploading;

  set imageUrl(String? url) {
    _imageUrl = url;
    _notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    Future.delayed(Duration.zero, () {
      for (var listener in _listeners) {
        listener();
      }
    });
  }

  Future<void> uploadImage() async {
  if (_isUploading || _imageUrl != null) return;
  _isUploading = true;
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image == null) {
    _isUploading = false;
    return;
  }
  File file = File(image.path);

  try {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    String filePath = 'uploaded_images/$fileName';
    await FirebaseStorage.instance.ref(filePath).putFile(file);
    _imageUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    return;
  } catch (e) {
    print("Error uploading image: $e");
    _isUploading = false;
    return;
  } finally {
    _isUploading = false;
    _notifyListeners();
  }
}


  Future<void> deleteImage(String imageUrl) async {
    try {
      final String path = extractPathFromUrl(imageUrl);
      await FirebaseStorage.instance.ref(path).delete();
      _imageUrl = null;
    } catch (e) {
      print('Error deleting image: $e');
    }
    _notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    String encodedPath = uri.pathSegments.last;

    return Uri.decodeComponent(encodedPath);
  }
}
