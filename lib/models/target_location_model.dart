import 'package:cloud_firestore/cloud_firestore.dart';

class TargetLocationModel {
  final GeoPoint coords;
  final int radius;

  TargetLocationModel({required this.coords, required this.radius});

  Map<String, dynamic> toMap() {
    return {'coords': coords, 'radius': radius};
  }

  factory TargetLocationModel.fromMap(Map<String, dynamic> map) {
    return TargetLocationModel(coords: map['coords'], radius: map['radius']);
  }
}
