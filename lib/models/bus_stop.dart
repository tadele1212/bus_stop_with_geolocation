class BusStop {
  final String seq;
  final String name;
  final double km;
  final double? latitude;
  final double? longitude;

  BusStop({
    required this.seq,
    required this.name,
    required this.km,
    this.latitude,
    this.longitude,
  });

  factory BusStop.fromMap(Map<String, dynamic> map) {
    return BusStop(
      seq: map['seq'].toString(),
      name: map['name'] as String,
      km: double.parse(map['km'].toString()),
      latitude: map['latitude'] != null ? double.parse(map['latitude'].toString()) : null,
      longitude: map['longitude'] != null ? double.parse(map['longitude'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'seq': seq,
      'name': name,
      'km': km,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
} 