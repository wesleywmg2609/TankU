import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tankyou/models/tank.dart';

class TankService with ChangeNotifier {
  late final User user;
  late final DatabaseReference databaseRef;

  TankService() {
    user = FirebaseAuth.instance.currentUser!;
    databaseRef = FirebaseDatabase.instance.ref().child('tanks/${user.uid}');
  }

  DatabaseReference addTankToDatabase(Tank tank) {
    var id = databaseRef.push();
    id.set(tank.toJson());
    return id;
  }

  void updateTankToDatabase(Tank tank, DatabaseReference id) {
    id.update(tank.toJson());
  }

  Future<List<Tank>> getAllTanks() async {
    try {
      DatabaseEvent databaseEvent = await databaseRef.once();
      DataSnapshot dataSnapshot = databaseEvent.snapshot;

      List<Tank> tanks = [];
      (dataSnapshot.value as Map?)?.forEach((key, value) {
        if (value is Map) {
          Tank tank = createTank(Map<String, dynamic>.from(value));
          tank.setId(databaseRef.child(key));
          tanks.add(tank);
        }
      });

      return tanks;
    } catch (e) {
      print('Error fetching all tanks: $e');
      return [];
    }
  }

  Future<Tank?> getTankById(DatabaseReference tankRef) async {
    try {
      DatabaseEvent databaseEvent = await tankRef.once();
      DataSnapshot dataSnapshot = databaseEvent.snapshot;

      if (dataSnapshot.exists) {
        if (dataSnapshot.value is Map) {
          Map<String, dynamic> tankData =
              Map<String, dynamic>.from(dataSnapshot.value as Map);
          if (tankData['uid'] == user.uid) {
            Tank tank = createTank(tankData);
            tank.setId(tankRef);
            return tank;
          }
        }
      }
    } catch (e) {
      print('Error fetching tank data: $e');
    }
    return null;
  }

  Future<String> generateTankName(String name) async {
    name = name.trim();

    if (name.isEmpty) {
      try {
        DatabaseEvent databaseEvent = await databaseRef.once();
        DataSnapshot dataSnapshot = databaseEvent.snapshot;

        int count = dataSnapshot.children.length;
        return 'Tank ${count + 1}';
      } catch (e) {
        print('Error generating tank name: $e');
        return 'Tank 1';
      }
    }

    return name;
  }

  Future<void> removeImageFromDatabase(DatabaseReference id) async {
    await id.update({'imageUrl': null});
  }
}

class StorageService with ChangeNotifier {
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

  void notifyListeners() {}
}
