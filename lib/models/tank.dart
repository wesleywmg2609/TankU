import 'package:firebase_database/firebase_database.dart';

class Tank {
  // ignore: unused_field
  late DatabaseReference id;
  String? uid;
  String? imageUrl;
  String? name;
  String? waterType;
  int? width;
  int? depth;
  int? height;
  String? setupAt;
  List<String>? equipments;
  String createdAt;

  Tank(this.uid, this.imageUrl, this.name, this.waterType, this.width, this.depth, this.height, this.setupAt,  this.equipments, {String? createdAt})
      : this.createdAt = createdAt ?? DateTime.now().toIso8601String();

  void setId(DatabaseReference id) {
    this.id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'imageUrl': this.imageUrl,
      'name': this.name,
      'waterType': this.waterType,
      'width': this.width,
      'depth': this.depth,
      'height': this.height,
      'setupAt': this.setupAt,
      'equipments': this.equipments,
      'createdAt': this.createdAt,
    };
  }
}

Tank createTank(Map<String, dynamic> record) {
  Map<String, dynamic> attributes = {
    'uid': record['uid'] ?? '',
    'imageUrl': record['imageUrl'] ?? '',
    'name': record['name'] ?? '',
    'waterType': record['waterType'] ?? '',
    'width': record['width']?.toInt() ?? 0,
    'depth': record['depth']?.toInt() ?? 0,
    'height': record['height']?.toInt() ?? 0,
    'setupAt': record['setupAt'] ?? '',
    'equipments': List<String>.from(record['equipments'] ?? []),
    'createdAt': record['createdAt'] ?? DateTime.now().toIso8601String(),
  };

  Tank tank = Tank(
    attributes['uid'],
    attributes['imageUrl'],
    attributes['name'],
    attributes['waterType'],
    attributes['width'],
    attributes['depth'],
    attributes['height'],
    attributes['setupAt'],
    attributes['equipments'],
    createdAt: attributes['createdAt'],
  );

  return tank;
}
