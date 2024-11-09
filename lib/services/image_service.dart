import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService with ChangeNotifier {
  List<String> _imageUrls = [];
  bool _isLoading = false;
  bool _isUploading = false;
  
  List<String> get imageUrls => _imageUrls;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  Future<void> fetchImages() async {
    _isLoading = true;

    final ListResult result =
        await FirebaseStorage.instance.ref('uploaded_images/').listAll();

    final urls =
        await Future.wait(result.items.map(((ref) => ref.getDownloadURL())));

    _imageUrls = urls;

    _isLoading = false;

    notifyListeners();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl);

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

  Future<String?> uploadImage() async {
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

      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      _imageUrls.add(downloadUrl);

      notifyListeners();

      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;

    } finally {
      _isUploading = false;
      notifyListeners();

    }
  }
}
