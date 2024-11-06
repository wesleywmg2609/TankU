import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tankyou/helper/functions.dart';
import 'package:tankyou/models/tank.dart';

final _databaseReference = FirebaseDatabase.instance.ref();

DatabaseReference addTankToDatabase(Tank tank) {
  var id = _databaseReference.child('tanks/').push();
  id.set(tank.toJson());
  return id;
}

void updateTankToDatabase(Tank tank, DatabaseReference id) {
  id.update(tank.toJson());
}

Future<void> removeImageFromDatabase(DatabaseReference id) async {
  try {
    await id.update({'imageUrl': null});
  } catch (e) {
    logger("Error updating database: $e");
    throw e;
  }
}

Future<List<Tank>> getAllTanks(String uid) async {
  DatabaseEvent databaseEvent = await _databaseReference.child('tanks/').once();
  DataSnapshot dataSnapshot = databaseEvent.snapshot;

  List<Tank> tanks = [];

  (dataSnapshot.value as Map?)?.forEach((key, value) {
    if (value is Map && value['uid'] == uid) {
      Tank tank = createTank(value.cast<String, dynamic>());
      tank.setId(_databaseReference.child('tanks/$key'));
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
      Map<String, dynamic> tankData = Map<String, dynamic>.from(dataSnapshot.value as Map);
      if (tankData.containsKey('uid')) {
        if (tankData['uid'] == uid) {
          Tank tank = createTank(tankData);
          tank.setId(tankRef);
          logger('succes');
          return tank;
        } else {
          logger('UID does not match: ${tankData['uid']} != $uid');
        }
      } else {
        logger('UID field is missing in tank data.');
      }
    } else {
      logger('Data is not a Map.');
    }
  } else {
    logger('No valid data found at the reference.');
  }

  return null; // Return null if no matching tank is found
}


Future<String> generateTankName(String userId, String name) async {
  name = name.trim();
  if (name.isEmpty) {
    DatabaseEvent databaseEvent =
        await _databaseReference.child('tanks/').once();
    DataSnapshot dataSnapshot = databaseEvent.snapshot;

    int count = 0;
    if (dataSnapshot.exists) {
      for (var child in dataSnapshot.children) {
        if (child.child('uid').value == userId) {
          count++;
        }
      }
    }
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
