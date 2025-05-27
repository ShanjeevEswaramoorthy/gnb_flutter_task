import 'package:json_annotation/json_annotation.dart';

part 'property_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PropertyModel {
  final dynamic error;
  final FiltersApplied? filtersApplied;
  final bool? loading;
  final int? page;
  final int? pageSize;
  final List<Properties>? properties;
  final int? totalPages;
  final int? totalProperties;

  PropertyModel({
    this.error,
    this.filtersApplied,
    this.loading,
    this.page,
    this.pageSize,
    this.properties,
    this.totalPages,
    this.totalProperties,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);
}

@JsonSerializable()
class FiltersApplied {
  final dynamic location;

  @JsonKey(name: 'max_price')
  final dynamic maxPrice;

  @JsonKey(name: 'min_price')
  final dynamic minPrice;

  final String? status;
  final List<dynamic>? tags;

  FiltersApplied({
    this.location,
    this.maxPrice,
    this.minPrice,
    this.status,
    this.tags,
  });

  factory FiltersApplied.fromJson(Map<String, dynamic> json) =>
      _$FiltersAppliedFromJson(json);

  Map<String, dynamic> toJson() => _$FiltersAppliedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Properties {
  final Agent? agent;
  final int? areaSqFt;
  final int? bathrooms;
  final int? bedrooms;
  final String? currency;
  final String? dateListed;
  final String? description;
  final String? id;
  final List<String>? images;
  final Location? location;
  final int? price;
  final String? status;
  final List<String>? tags;
  final String? title;

  Properties({
    this.agent,
    this.areaSqFt,
    this.bathrooms,
    this.bedrooms,
    this.currency,
    this.dateListed,
    this.description,
    this.id,
    this.images,
    this.location,
    this.price,
    this.status,
    this.tags,
    this.title,
  });

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}

@JsonSerializable()
class Agent {
  final String? contact;
  final String? email;
  final String? name;

  Agent({this.contact, this.email, this.name});

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);

  Map<String, dynamic> toJson() => _$AgentToJson(this);
}

@JsonSerializable()
class Location {
  final String? address;
  final String? city;
  final String? country;
  final double? latitude;
  final double? longitude;
  final String? state;
  final String? zip;

  Location({
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.state,
    this.zip,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
