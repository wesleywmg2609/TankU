import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tankyou/models/tank.dart';

final _databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference addTankToDatabase(String uid, Tank tank) {
  var id = _databaseReference.child('tanks/$uid/').push();
  id.set(tank.toJson());
  return id;
}

void updateTankToDatabase(Tank tank, DatabaseReference id) {
  id.update(tank.toJson());
}

Future<void> removeImageFromDatabase(DatabaseReference id) async {
  await id.update({'imageUrl': null});
}

Future<List<Tank>> getAllTanks(String uid) async {
  DatabaseEvent databaseEvent =
      await _databaseReference.child('tanks/$uid/').once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;

  List<Tank> tanks = [];

  (dataSnapshot.value as Map?)?.forEach((key, value) {
    if (value is Map) {
      Tank tank = createTank(value.cast<String, dynamic>());
      tank.setId(_databaseReference.child('tanks/$uid/$key/'));
      tanks.add(tank);
    }
  });

  return tanks;
}

Future<Tank?> getTankById(DatabaseReference tankRef, String uid) async {
  DatabaseEvent databaseEvent = await tankRef.once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;

  if (dataSnapshot.exists) {
    if (dataSnapshot.value is Map) {
      Map<String, dynamic> tankData =
          Map<String, dynamic>.from(dataSnapshot.value as Map);
      if (tankData.containsKey('uid')) {
        if (tankData['uid'] == uid) {
          Tank tank = createTank(tankData);
          tank.setId(tankRef);
          return tank;
        }
      }
    }
  }

  return null;
}

DatabaseReference getTanksRef(String uid) {
  return _databaseReference.child('tanks/$uid');
}

Future<String> generateTankName(String uid, String name) async {
  name = name.trim();

  if (name.isEmpty) {
    // Directly count tanks under `tanks/{uid}`
    DatabaseEvent databaseEvent =
        await _databaseReference.child('tanks/$uid').once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;

    int count =
        dataSnapshot.children.length; // Count number of tanks for this user
    return 'Tank ${count + 1}';
  }

  return name;
}

Future<String> uploadImage(String uid, File image, String folder) async {
  String fileName = '$folder/$uid/${DateTime.now().millisecondsSinceEpoch}.png';

  final ref = FirebaseStorage.instance.ref().child(fileName);

  await ref.putFile(image);

  return ref.getDownloadURL();
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

  Future<void> deleteImages(String imageUrl) async {
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

  Future<void> uploadImage2() async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    try {
      String filePath = 'uploaded_images/${DateTime.now()}.png';

      await FirebaseStorage.instance.ref(filePath).putFile(file);

      String downloadUrl =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      _imageUrls.add(downloadUrl);
      notifyListeners();
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }

  void notifyListeners() {}
}
