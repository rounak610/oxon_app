import 'package:cloud_firestore/cloud_firestore.dart';

class DriverLocData {
  String vehicleType;

  String routeId;

  List<dynamic> locationsVisited;

  Timestamp dateOfTransport;
  bool isVehicleParked;

  String vehicleNumber;
  String? referenceId;

  DriverLocData(
      {required this.vehicleType,
      required this.vehicleNumber,
      required this.locationsVisited,
      required this.routeId,
      required this.dateOfTransport,
      required this.isVehicleParked,
      this.referenceId});

  factory DriverLocData.fromSnapshot(DocumentSnapshot snapshot) {
    final newDustbinData =
        DriverLocData.fromJson(snapshot.data() as Map<String, dynamic>);
    newDustbinData.referenceId = snapshot.reference.id;
    return newDustbinData;
  }

  factory DriverLocData.fromJson(Map<String, dynamic> json) =>
      _driverLocDataFromJson(json);

  Map<String, dynamic> toJson() => _driverLocDataToJson(this);
}

DriverLocData _driverLocDataFromJson(Map<String, dynamic> json) {
  return DriverLocData(
      vehicleType: json["vehicleType"],
      vehicleNumber: json["vehicleNumber"],
      locationsVisited: json["locationsVisited"],
      routeId: json["routeId"],
      dateOfTransport: json["dateOfTransport"],
      isVehicleParked: json["isVehicleParked"]);
}

Map<String, dynamic> _driverLocDataToJson(DriverLocData instance) =>
    <String, dynamic>{
      "vehicleType": instance.vehicleType,
      "vehicleNumber": instance.vehicleNumber,
      "locationsVisited": instance.locationsVisited,
      "routeId": instance.routeId,
      "dateOfTransport": instance.dateOfTransport,
      "isVehicleParked": instance.isVehicleParked
    };
