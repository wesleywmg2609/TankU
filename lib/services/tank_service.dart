import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tanku/models/tank.dart';

class TankService with ChangeNotifier {
  late final User user;
  late final DatabaseReference databaseRef;
  final List<VoidCallback> _listeners = [];
  List<Tank?> _tanks = [];
  Tank? _tank;
  bool _isLoading = true;

  Tank? get tank => _tank;
  List<Tank?> get tanks => _tanks;
  bool get isLoading => _isLoading;

  TankService() {
    user = FirebaseAuth.instance.currentUser!;
    databaseRef = FirebaseDatabase.instance.ref().child('tanks/${user.uid}');
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

  void listenToAllTanksUpdates() {
  databaseRef.onValue.listen((event) {
    if (event.snapshot.exists && event.snapshot.value is Map) {
      Map data = event.snapshot.value as Map;

      // If there is data, process it and set isLoading to false
      if (data.isNotEmpty) {
        List<Tank> loadedTanks = [];
        data.forEach((key, value) {
          if (value is Map) {
            Tank tank = createTank(Map<String, dynamic>.from(value));
            tank.setId(databaseRef.child(key));
            loadedTanks.add(tank);
          }
        });

        // Update the tanks and loading state
        loadedTanks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _tanks = loadedTanks;
        _isLoading = false;
      } else {
        // If no data, still set isLoading to false
        _isLoading = false;
      }

      // Notify listeners to update UI
      _notifyListeners();
    } else {
      // In case of no data or incorrect format
      _isLoading = false;
      _notifyListeners();
    }
  });
}


  void listenToTankUpdates(DatabaseReference tankRef) {
  tankRef.onValue.listen((event) {
    if (event.snapshot.exists && event.snapshot.value is Map) {
      Map<String, dynamic> tankData = Map<String, dynamic>.from(event.snapshot.value as Map);
      if (tankData['uid'] == user.uid) {
            Tank tank = createTank(tankData);
            tank.setId(tankRef);
            _tank = tank;
            _notifyListeners();
          }
    }
  });
}

  DatabaseReference addTankToDatabase(Tank tank) {
    var id = databaseRef.push();
    id.set(tank.toJson());
    return id;
  }

  void updateTankToDatabase(Tank tank, DatabaseReference tankRef) {
    tankRef.update(tank.toJson());
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

  Future<void> removeImageFromDatabase(DatabaseReference tankRef) async {
    await tankRef.update({'imageUrl': null});
  }
}
