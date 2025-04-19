class StoreModel {
  String fsqId;
  int distance;
  Geocodes geocodes;
  String link;
  Location location;
  String name;

  StoreModel({
    required this.fsqId,
    required this.distance,
    required this.geocodes,
    required this.link,
    required this.location,
    required this.name,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      fsqId: json['fsq_id'],
      distance: json['distance'],
      geocodes: Geocodes.fromJson(json['geocodes']),
      link: json['link'] ?? '',
      location: Location.fromJson(json['location']),
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fsq_id': fsqId,
      'name': name,
      'distance': distance,
      'latitude': geocodes.main.latitude,
      'longitude': geocodes.main.longitude,
      'link': link,
      'address': location.address ?? '',
      'country': location.country.name,
      'formatted_address': location.formattedAddress,
    };
  }
}

class GeoBounds {
  Circle circle;

  GeoBounds({required this.circle});
  factory GeoBounds.fromJson(Map<String, dynamic> json) {
    return GeoBounds(circle: Circle.fromJson(json['circle']));
  }
}

class Circle {
  storeCenter center;
  int radius;

  Circle({required this.center, required this.radius});
  factory Circle.fromJson(Map<String, dynamic> json) {
    return Circle(
      center: storeCenter.fromJson(json['center']),
      radius: json['radius'],
    );
  }
}

class storeCenter {
  double latitude;
  double longitude;

  storeCenter({required this.latitude, required this.longitude});
  factory storeCenter.fromJson(Map<String, dynamic> json) {
    return storeCenter(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

class Geocodes {
  storeCenter main;
  storeCenter? dropOff;
  storeCenter? roof;

  Geocodes({required this.main, this.dropOff, this.roof});
  factory Geocodes.fromJson(Map<String, dynamic> json) {
    return Geocodes(
      main: storeCenter.fromJson(json['main']),
      dropOff:
          json['drop_off'] != null
              ? storeCenter.fromJson(json['drop_off'])
              : null,
      roof: json['roof'] != null ? storeCenter.fromJson(json['roof']) : null,
    );
  }
}

class Location {
  Country country;
  String? crossStreet;
  String formattedAddress;
  String? locality;
  String? region;
  String? address;
  String? postTown;

  Location({
    required this.country,
    this.crossStreet,
    required this.formattedAddress,
    this.locality,
    this.region,
    this.address,
    this.postTown,
  });
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: Country.values.firstWhere(
        (e) => e.toString() == 'Country.${json['country']}',
      ),
      crossStreet: json['cross_street'],
      formattedAddress: json['formatted_address'],
      locality: json['locality'],
      region: json['region'],
      address: json['address'],
      postTown: json['post_town'],
    );
  }
}

enum Country { EG }
