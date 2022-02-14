import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoCodedLocation {
  final String compoundPlusCode;
  final String formattedAddress;

  const GeoCodedLocation({
    required this.compoundPlusCode,
    required this.formattedAddress,});

  factory GeoCodedLocation.fromMap(Map<String, dynamic> map) {
    // Check if route is not available
    if ((map['results'] as List).isEmpty) return GeoCodedLocation(compoundPlusCode: 'error', formattedAddress: 'error');

    return GeoCodedLocation(
      compoundPlusCode: map['plus_code']['compound_code'],
      formattedAddress: map['results'][0]['formatted_address']
    );
  }
}