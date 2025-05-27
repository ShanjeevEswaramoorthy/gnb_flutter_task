// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      error: json['error'],
      filtersApplied:
          json['filtersApplied'] == null
              ? null
              : FiltersApplied.fromJson(
                json['filtersApplied'] as Map<String, dynamic>,
              ),
      loading: json['loading'] as bool?,
      page: (json['page'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      properties:
          (json['properties'] as List<dynamic>?)
              ?.map((e) => Properties.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalPages: (json['totalPages'] as num?)?.toInt(),
      totalProperties: (json['totalProperties'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'error': instance.error,
      'filtersApplied': instance.filtersApplied?.toJson(),
      'loading': instance.loading,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'properties': instance.properties?.map((e) => e.toJson()).toList(),
      'totalPages': instance.totalPages,
      'totalProperties': instance.totalProperties,
    };

FiltersApplied _$FiltersAppliedFromJson(Map<String, dynamic> json) =>
    FiltersApplied(
      location: json['location'],
      maxPrice: json['max_price'],
      minPrice: json['min_price'],
      status: json['status'] as String?,
      tags: json['tags'] as List<dynamic>?,
    );

Map<String, dynamic> _$FiltersAppliedToJson(FiltersApplied instance) =>
    <String, dynamic>{
      'location': instance.location,
      'max_price': instance.maxPrice,
      'min_price': instance.minPrice,
      'status': instance.status,
      'tags': instance.tags,
    };

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
  agent:
      json['agent'] == null
          ? null
          : Agent.fromJson(json['agent'] as Map<String, dynamic>),
  areaSqFt: (json['areaSqFt'] as num?)?.toInt(),
  bathrooms: (json['bathrooms'] as num?)?.toInt(),
  bedrooms: (json['bedrooms'] as num?)?.toInt(),
  currency: json['currency'] as String?,
  dateListed: json['dateListed'] as String?,
  description: json['description'] as String?,
  id: json['id'] as String?,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
  location:
      json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
  price: (json['price'] as num?)?.toInt(),
  status: json['status'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'agent': instance.agent?.toJson(),
      'areaSqFt': instance.areaSqFt,
      'bathrooms': instance.bathrooms,
      'bedrooms': instance.bedrooms,
      'currency': instance.currency,
      'dateListed': instance.dateListed,
      'description': instance.description,
      'id': instance.id,
      'images': instance.images,
      'location': instance.location?.toJson(),
      'price': instance.price,
      'status': instance.status,
      'tags': instance.tags,
      'title': instance.title,
    };

Agent _$AgentFromJson(Map<String, dynamic> json) => Agent(
  contact: json['contact'] as String?,
  email: json['email'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$AgentToJson(Agent instance) => <String, dynamic>{
  'contact': instance.contact,
  'email': instance.email,
  'name': instance.name,
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  address: json['address'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  state: json['state'] as String?,
  zip: json['zip'] as String?,
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'address': instance.address,
  'city': instance.city,
  'country': instance.country,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'state': instance.state,
  'zip': instance.zip,
};
