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
    notifyListeners();
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
    for (var listener in _listeners) {
      listener();
    }
  }

  Future<String?> uploadImage() async {
    if (_isUploading) return null;

    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      _isUploading = false;
      notifyListeners();
      return null;
    }

    File file = File(image.path);

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      String filePath = 'uploaded_images/$fileName';

      await FirebaseStorage.instance.ref(filePath).putFile(file);

      _imageUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      notifyListeners();

      return _imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      _isUploading = false;
      notifyListeners();
      return null;

    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final String path = extractPathFromUrl(imageUrl);
      await FirebaseStorage.instance.ref(path).delete();
    } catch (e) {
      print('Error deleting image: $e');
    }

    notifyListeners();
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    String encodedPath = uri.pathSegments.last;

    return Uri.decodeComponent(encodedPath);
  }
}