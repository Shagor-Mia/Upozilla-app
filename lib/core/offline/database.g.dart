// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlacesTable extends Places with TableInfo<$PlacesTable, Place> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImageMeta =
      const VerificationMeta('coverImage');
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
      'cover_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _galleryJsonMeta =
      const VerificationMeta('galleryJson');
  @override
  late final GeneratedColumn<String> galleryJson = GeneratedColumn<String>(
      'gallery_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isFeaturedMeta =
      const VerificationMeta('isFeatured');
  @override
  late final GeneratedColumn<bool> isFeatured = GeneratedColumn<bool>(
      'is_featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_featured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('published'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        locationId,
        name,
        slug,
        category,
        description,
        coverImage,
        galleryJson,
        latitude,
        longitude,
        isFeatured,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(Insertable<Place> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('cover_image')) {
      context.handle(
          _coverImageMeta,
          coverImage.isAcceptableOrUnknown(
              data['cover_image']!, _coverImageMeta));
    }
    if (data.containsKey('gallery_json')) {
      context.handle(
          _galleryJsonMeta,
          galleryJson.isAcceptableOrUnknown(
              data['gallery_json']!, _galleryJsonMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('is_featured')) {
      context.handle(
          _isFeaturedMeta,
          isFeatured.isAcceptableOrUnknown(
              data['is_featured']!, _isFeaturedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Place map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Place(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      coverImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image']),
      galleryJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gallery_json'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      isFeatured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_featured'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $PlacesTable createAlias(String alias) {
    return $PlacesTable(attachedDatabase, alias);
  }
}

class Place extends DataClass implements Insertable<Place> {
  final String id;
  final String locationId;
  final String name;
  final String slug;
  final String category;
  final String? description;
  final String? coverImage;
  final String galleryJson;
  final double? latitude;
  final double? longitude;
  final bool isFeatured;
  final String status;
  const Place(
      {required this.id,
      required this.locationId,
      required this.name,
      required this.slug,
      required this.category,
      this.description,
      this.coverImage,
      required this.galleryJson,
      this.latitude,
      this.longitude,
      required this.isFeatured,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    map['gallery_json'] = Variable<String>(galleryJson);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['is_featured'] = Variable<bool>(isFeatured);
    map['status'] = Variable<String>(status);
    return map;
  }

  PlacesCompanion toCompanion(bool nullToAbsent) {
    return PlacesCompanion(
      id: Value(id),
      locationId: Value(locationId),
      name: Value(name),
      slug: Value(slug),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      galleryJson: Value(galleryJson),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isFeatured: Value(isFeatured),
      status: Value(status),
    );
  }

  factory Place.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Place(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      galleryJson: serializer.fromJson<String>(json['galleryJson']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isFeatured: serializer.fromJson<bool>(json['isFeatured']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'coverImage': serializer.toJson<String?>(coverImage),
      'galleryJson': serializer.toJson<String>(galleryJson),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isFeatured': serializer.toJson<bool>(isFeatured),
      'status': serializer.toJson<String>(status),
    };
  }

  Place copyWith(
          {String? id,
          String? locationId,
          String? name,
          String? slug,
          String? category,
          Value<String?> description = const Value.absent(),
          Value<String?> coverImage = const Value.absent(),
          String? galleryJson,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          bool? isFeatured,
          String? status}) =>
      Place(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        coverImage: coverImage.present ? coverImage.value : this.coverImage,
        galleryJson: galleryJson ?? this.galleryJson,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        isFeatured: isFeatured ?? this.isFeatured,
        status: status ?? this.status,
      );
  Place copyWithCompanion(PlacesCompanion data) {
    return Place(
      id: data.id.present ? data.id.value : this.id,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      coverImage:
          data.coverImage.present ? data.coverImage.value : this.coverImage,
      galleryJson:
          data.galleryJson.present ? data.galleryJson.value : this.galleryJson,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isFeatured:
          data.isFeatured.present ? data.isFeatured.value : this.isFeatured,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Place(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('coverImage: $coverImage, ')
          ..write('galleryJson: $galleryJson, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      locationId,
      name,
      slug,
      category,
      description,
      coverImage,
      galleryJson,
      latitude,
      longitude,
      isFeatured,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Place &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.category == this.category &&
          other.description == this.description &&
          other.coverImage == this.coverImage &&
          other.galleryJson == this.galleryJson &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isFeatured == this.isFeatured &&
          other.status == this.status);
}

class PlacesCompanion extends UpdateCompanion<Place> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> coverImage;
  final Value<String> galleryJson;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isFeatured;
  final Value<String> status;
  final Value<int> rowid;
  const PlacesCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.galleryJson = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesCompanion.insert({
    required String id,
    required String locationId,
    required String name,
    required String slug,
    required String category,
    this.description = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.galleryJson = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        locationId = Value(locationId),
        name = Value(name),
        slug = Value(slug),
        category = Value(category);
  static Insertable<Place> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? coverImage,
    Expression<String>? galleryJson,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isFeatured,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (coverImage != null) 'cover_image': coverImage,
      if (galleryJson != null) 'gallery_json': galleryJson,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isFeatured != null) 'is_featured': isFeatured,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesCompanion copyWith(
      {Value<String>? id,
      Value<String>? locationId,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? category,
      Value<String?>? description,
      Value<String?>? coverImage,
      Value<String>? galleryJson,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<bool>? isFeatured,
      Value<String>? status,
      Value<int>? rowid}) {
    return PlacesCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      galleryJson: galleryJson ?? this.galleryJson,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (galleryJson.present) {
      map['gallery_json'] = Variable<String>(galleryJson.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isFeatured.present) {
      map['is_featured'] = Variable<bool>(isFeatured.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('coverImage: $coverImage, ')
          ..write('galleryJson: $galleryJson, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HospitalsTable extends Hospitals
    with TableInfo<$HospitalsTable, Hospital> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HospitalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('govt'));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactMeta =
      const VerificationMeta('contact');
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
      'contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, locationId, name, type, address, contact, latitude, longitude];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hospitals';
  @override
  VerificationContext validateIntegrity(Insertable<Hospital> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('contact')) {
      context.handle(_contactMeta,
          contact.isAcceptableOrUnknown(data['contact']!, _contactMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hospital map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hospital(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      contact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $HospitalsTable createAlias(String alias) {
    return $HospitalsTable(attachedDatabase, alias);
  }
}

class Hospital extends DataClass implements Insertable<Hospital> {
  final String id;
  final String locationId;
  final String name;
  final String type;
  final String? address;
  final String? contact;
  final double? latitude;
  final double? longitude;
  const Hospital(
      {required this.id,
      required this.locationId,
      required this.name,
      required this.type,
      this.address,
      this.contact,
      this.latitude,
      this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  HospitalsCompanion toCompanion(bool nullToAbsent) {
    return HospitalsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      name: Value(name),
      type: Value(type),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory Hospital.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hospital(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      address: serializer.fromJson<String?>(json['address']),
      contact: serializer.fromJson<String?>(json['contact']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'address': serializer.toJson<String?>(address),
      'contact': serializer.toJson<String?>(contact),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  Hospital copyWith(
          {String? id,
          String? locationId,
          String? name,
          String? type,
          Value<String?> address = const Value.absent(),
          Value<String?> contact = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent()}) =>
      Hospital(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        name: name ?? this.name,
        type: type ?? this.type,
        address: address.present ? address.value : this.address,
        contact: contact.present ? contact.value : this.contact,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
      );
  Hospital copyWithCompanion(HospitalsCompanion data) {
    return Hospital(
      id: data.id.present ? data.id.value : this.id,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      address: data.address.present ? data.address.value : this.address,
      contact: data.contact.present ? data.contact.value : this.contact,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hospital(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, locationId, name, type, address, contact, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hospital &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.name == this.name &&
          other.type == this.type &&
          other.address == this.address &&
          other.contact == this.contact &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class HospitalsCompanion extends UpdateCompanion<Hospital> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> address;
  final Value<String?> contact;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> rowid;
  const HospitalsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HospitalsCompanion.insert({
    required String id,
    required String locationId,
    required String name,
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.contact = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        locationId = Value(locationId),
        name = Value(name);
  static Insertable<Hospital> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? address,
    Expression<String>? contact,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (address != null) 'address': address,
      if (contact != null) 'contact': contact,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HospitalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? locationId,
      Value<String>? name,
      Value<String>? type,
      Value<String?>? address,
      Value<String?>? contact,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<int>? rowid}) {
    return HospitalsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HospitalsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('contact: $contact, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoctorsTable extends Doctors with TableInfo<$DoctorsTable, Doctor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoctorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hospitalIdMeta =
      const VerificationMeta('hospitalId');
  @override
  late final GeneratedColumn<String> hospitalId = GeneratedColumn<String>(
      'hospital_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _specialtyMeta =
      const VerificationMeta('specialty');
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
      'specialty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _chamberDaysJsonMeta =
      const VerificationMeta('chamberDaysJson');
  @override
  late final GeneratedColumn<String> chamberDaysJson = GeneratedColumn<String>(
      'chamber_days_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _chamberHoursMeta =
      const VerificationMeta('chamberHours');
  @override
  late final GeneratedColumn<String> chamberHours = GeneratedColumn<String>(
      'chamber_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactMeta =
      const VerificationMeta('contact');
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
      'contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, hospitalId, name, specialty, chamberDaysJson, chamberHours, contact];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doctors';
  @override
  VerificationContext validateIntegrity(Insertable<Doctor> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hospital_id')) {
      context.handle(
          _hospitalIdMeta,
          hospitalId.isAcceptableOrUnknown(
              data['hospital_id']!, _hospitalIdMeta));
    } else if (isInserting) {
      context.missing(_hospitalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(_specialtyMeta,
          specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta));
    }
    if (data.containsKey('chamber_days_json')) {
      context.handle(
          _chamberDaysJsonMeta,
          chamberDaysJson.isAcceptableOrUnknown(
              data['chamber_days_json']!, _chamberDaysJsonMeta));
    }
    if (data.containsKey('chamber_hours')) {
      context.handle(
          _chamberHoursMeta,
          chamberHours.isAcceptableOrUnknown(
              data['chamber_hours']!, _chamberHoursMeta));
    }
    if (data.containsKey('contact')) {
      context.handle(_contactMeta,
          contact.isAcceptableOrUnknown(data['contact']!, _contactMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Doctor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Doctor(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      hospitalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hospital_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      specialty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialty']),
      chamberDaysJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}chamber_days_json'])!,
      chamberHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chamber_hours']),
      contact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact']),
    );
  }

  @override
  $DoctorsTable createAlias(String alias) {
    return $DoctorsTable(attachedDatabase, alias);
  }
}

class Doctor extends DataClass implements Insertable<Doctor> {
  final String id;
  final String hospitalId;
  final String name;
  final String? specialty;
  final String chamberDaysJson;
  final String? chamberHours;
  final String? contact;
  const Doctor(
      {required this.id,
      required this.hospitalId,
      required this.name,
      this.specialty,
      required this.chamberDaysJson,
      this.chamberHours,
      this.contact});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hospital_id'] = Variable<String>(hospitalId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || specialty != null) {
      map['specialty'] = Variable<String>(specialty);
    }
    map['chamber_days_json'] = Variable<String>(chamberDaysJson);
    if (!nullToAbsent || chamberHours != null) {
      map['chamber_hours'] = Variable<String>(chamberHours);
    }
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    return map;
  }

  DoctorsCompanion toCompanion(bool nullToAbsent) {
    return DoctorsCompanion(
      id: Value(id),
      hospitalId: Value(hospitalId),
      name: Value(name),
      specialty: specialty == null && nullToAbsent
          ? const Value.absent()
          : Value(specialty),
      chamberDaysJson: Value(chamberDaysJson),
      chamberHours: chamberHours == null && nullToAbsent
          ? const Value.absent()
          : Value(chamberHours),
      contact: contact == null && nullToAbsent
          ? const Value.absent()
          : Value(contact),
    );
  }

  factory Doctor.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Doctor(
      id: serializer.fromJson<String>(json['id']),
      hospitalId: serializer.fromJson<String>(json['hospitalId']),
      name: serializer.fromJson<String>(json['name']),
      specialty: serializer.fromJson<String?>(json['specialty']),
      chamberDaysJson: serializer.fromJson<String>(json['chamberDaysJson']),
      chamberHours: serializer.fromJson<String?>(json['chamberHours']),
      contact: serializer.fromJson<String?>(json['contact']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'hospitalId': serializer.toJson<String>(hospitalId),
      'name': serializer.toJson<String>(name),
      'specialty': serializer.toJson<String?>(specialty),
      'chamberDaysJson': serializer.toJson<String>(chamberDaysJson),
      'chamberHours': serializer.toJson<String?>(chamberHours),
      'contact': serializer.toJson<String?>(contact),
    };
  }

  Doctor copyWith(
          {String? id,
          String? hospitalId,
          String? name,
          Value<String?> specialty = const Value.absent(),
          String? chamberDaysJson,
          Value<String?> chamberHours = const Value.absent(),
          Value<String?> contact = const Value.absent()}) =>
      Doctor(
        id: id ?? this.id,
        hospitalId: hospitalId ?? this.hospitalId,
        name: name ?? this.name,
        specialty: specialty.present ? specialty.value : this.specialty,
        chamberDaysJson: chamberDaysJson ?? this.chamberDaysJson,
        chamberHours:
            chamberHours.present ? chamberHours.value : this.chamberHours,
        contact: contact.present ? contact.value : this.contact,
      );
  Doctor copyWithCompanion(DoctorsCompanion data) {
    return Doctor(
      id: data.id.present ? data.id.value : this.id,
      hospitalId:
          data.hospitalId.present ? data.hospitalId.value : this.hospitalId,
      name: data.name.present ? data.name.value : this.name,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      chamberDaysJson: data.chamberDaysJson.present
          ? data.chamberDaysJson.value
          : this.chamberDaysJson,
      chamberHours: data.chamberHours.present
          ? data.chamberHours.value
          : this.chamberHours,
      contact: data.contact.present ? data.contact.value : this.contact,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Doctor(')
          ..write('id: $id, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('name: $name, ')
          ..write('specialty: $specialty, ')
          ..write('chamberDaysJson: $chamberDaysJson, ')
          ..write('chamberHours: $chamberHours, ')
          ..write('contact: $contact')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, hospitalId, name, specialty, chamberDaysJson, chamberHours, contact);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Doctor &&
          other.id == this.id &&
          other.hospitalId == this.hospitalId &&
          other.name == this.name &&
          other.specialty == this.specialty &&
          other.chamberDaysJson == this.chamberDaysJson &&
          other.chamberHours == this.chamberHours &&
          other.contact == this.contact);
}

class DoctorsCompanion extends UpdateCompanion<Doctor> {
  final Value<String> id;
  final Value<String> hospitalId;
  final Value<String> name;
  final Value<String?> specialty;
  final Value<String> chamberDaysJson;
  final Value<String?> chamberHours;
  final Value<String?> contact;
  final Value<int> rowid;
  const DoctorsCompanion({
    this.id = const Value.absent(),
    this.hospitalId = const Value.absent(),
    this.name = const Value.absent(),
    this.specialty = const Value.absent(),
    this.chamberDaysJson = const Value.absent(),
    this.chamberHours = const Value.absent(),
    this.contact = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoctorsCompanion.insert({
    required String id,
    required String hospitalId,
    required String name,
    this.specialty = const Value.absent(),
    this.chamberDaysJson = const Value.absent(),
    this.chamberHours = const Value.absent(),
    this.contact = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        hospitalId = Value(hospitalId),
        name = Value(name);
  static Insertable<Doctor> custom({
    Expression<String>? id,
    Expression<String>? hospitalId,
    Expression<String>? name,
    Expression<String>? specialty,
    Expression<String>? chamberDaysJson,
    Expression<String>? chamberHours,
    Expression<String>? contact,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hospitalId != null) 'hospital_id': hospitalId,
      if (name != null) 'name': name,
      if (specialty != null) 'specialty': specialty,
      if (chamberDaysJson != null) 'chamber_days_json': chamberDaysJson,
      if (chamberHours != null) 'chamber_hours': chamberHours,
      if (contact != null) 'contact': contact,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoctorsCompanion copyWith(
      {Value<String>? id,
      Value<String>? hospitalId,
      Value<String>? name,
      Value<String?>? specialty,
      Value<String>? chamberDaysJson,
      Value<String?>? chamberHours,
      Value<String?>? contact,
      Value<int>? rowid}) {
    return DoctorsCompanion(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      chamberDaysJson: chamberDaysJson ?? this.chamberDaysJson,
      chamberHours: chamberHours ?? this.chamberHours,
      contact: contact ?? this.contact,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (hospitalId.present) {
      map['hospital_id'] = Variable<String>(hospitalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (chamberDaysJson.present) {
      map['chamber_days_json'] = Variable<String>(chamberDaysJson.value);
    }
    if (chamberHours.present) {
      map['chamber_hours'] = Variable<String>(chamberHours.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoctorsCompanion(')
          ..write('id: $id, ')
          ..write('hospitalId: $hospitalId, ')
          ..write('name: $name, ')
          ..write('specialty: $specialty, ')
          ..write('chamberDaysJson: $chamberDaysJson, ')
          ..write('chamberHours: $chamberHours, ')
          ..write('contact: $contact, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MarketsTable extends Markets with TableInfo<$MarketsTable, Market> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketDaysJsonMeta =
      const VerificationMeta('marketDaysJson');
  @override
  late final GeneratedColumn<String> marketDaysJson = GeneratedColumn<String>(
      'market_days_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
      'start_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<String> endTime = GeneratedColumn<String>(
      'end_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('general'));
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        locationId,
        name,
        marketDaysJson,
        startTime,
        endTime,
        description,
        type,
        latitude,
        longitude
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'markets';
  @override
  VerificationContext validateIntegrity(Insertable<Market> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('market_days_json')) {
      context.handle(
          _marketDaysJsonMeta,
          marketDaysJson.isAcceptableOrUnknown(
              data['market_days_json']!, _marketDaysJsonMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Market map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Market(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      marketDaysJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}market_days_json'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_time']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
    );
  }

  @override
  $MarketsTable createAlias(String alias) {
    return $MarketsTable(attachedDatabase, alias);
  }
}

class Market extends DataClass implements Insertable<Market> {
  final String id;
  final String locationId;
  final String name;
  final String marketDaysJson;
  final String? startTime;
  final String? endTime;
  final String? description;
  final String type;
  final double? latitude;
  final double? longitude;
  const Market(
      {required this.id,
      required this.locationId,
      required this.name,
      required this.marketDaysJson,
      this.startTime,
      this.endTime,
      this.description,
      required this.type,
      this.latitude,
      this.longitude});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['name'] = Variable<String>(name);
    map['market_days_json'] = Variable<String>(marketDaysJson);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<String>(endTime);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    return map;
  }

  MarketsCompanion toCompanion(bool nullToAbsent) {
    return MarketsCompanion(
      id: Value(id),
      locationId: Value(locationId),
      name: Value(name),
      marketDaysJson: Value(marketDaysJson),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      type: Value(type),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
    );
  }

  factory Market.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Market(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      name: serializer.fromJson<String>(json['name']),
      marketDaysJson: serializer.fromJson<String>(json['marketDaysJson']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      endTime: serializer.fromJson<String?>(json['endTime']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<String>(json['type']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'name': serializer.toJson<String>(name),
      'marketDaysJson': serializer.toJson<String>(marketDaysJson),
      'startTime': serializer.toJson<String?>(startTime),
      'endTime': serializer.toJson<String?>(endTime),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<String>(type),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
    };
  }

  Market copyWith(
          {String? id,
          String? locationId,
          String? name,
          String? marketDaysJson,
          Value<String?> startTime = const Value.absent(),
          Value<String?> endTime = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? type,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent()}) =>
      Market(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        name: name ?? this.name,
        marketDaysJson: marketDaysJson ?? this.marketDaysJson,
        startTime: startTime.present ? startTime.value : this.startTime,
        endTime: endTime.present ? endTime.value : this.endTime,
        description: description.present ? description.value : this.description,
        type: type ?? this.type,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
      );
  Market copyWithCompanion(MarketsCompanion data) {
    return Market(
      id: data.id.present ? data.id.value : this.id,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      name: data.name.present ? data.name.value : this.name,
      marketDaysJson: data.marketDaysJson.present
          ? data.marketDaysJson.value
          : this.marketDaysJson,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Market(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('marketDaysJson: $marketDaysJson, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, locationId, name, marketDaysJson,
      startTime, endTime, description, type, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Market &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.name == this.name &&
          other.marketDaysJson == this.marketDaysJson &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.description == this.description &&
          other.type == this.type &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class MarketsCompanion extends UpdateCompanion<Market> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> name;
  final Value<String> marketDaysJson;
  final Value<String?> startTime;
  final Value<String?> endTime;
  final Value<String?> description;
  final Value<String> type;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<int> rowid;
  const MarketsCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.name = const Value.absent(),
    this.marketDaysJson = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketsCompanion.insert({
    required String id,
    required String locationId,
    required String name,
    this.marketDaysJson = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        locationId = Value(locationId),
        name = Value(name);
  static Insertable<Market> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? name,
    Expression<String>? marketDaysJson,
    Expression<String>? startTime,
    Expression<String>? endTime,
    Expression<String>? description,
    Expression<String>? type,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (name != null) 'name': name,
      if (marketDaysJson != null) 'market_days_json': marketDaysJson,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketsCompanion copyWith(
      {Value<String>? id,
      Value<String>? locationId,
      Value<String>? name,
      Value<String>? marketDaysJson,
      Value<String?>? startTime,
      Value<String?>? endTime,
      Value<String?>? description,
      Value<String>? type,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<int>? rowid}) {
    return MarketsCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      marketDaysJson: marketDaysJson ?? this.marketDaysJson,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (marketDaysJson.present) {
      map['market_days_json'] = Variable<String>(marketDaysJson.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<String>(endTime.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketsCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('name: $name, ')
          ..write('marketDaysJson: $marketDaysJson, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BusinessesTable extends Businesses
    with TableInfo<$BusinessesTable, BusinessesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerUserIdMeta =
      const VerificationMeta('ownerUserId');
  @override
  late final GeneratedColumn<String> ownerUserId = GeneratedColumn<String>(
      'owner_user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
      'logo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImageMeta =
      const VerificationMeta('coverImage');
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
      'cover_image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isVerifiedMeta =
      const VerificationMeta('isVerified');
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
      'is_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        locationId,
        ownerUserId,
        name,
        slug,
        category,
        description,
        logo,
        coverImage,
        phone,
        address,
        latitude,
        longitude,
        isVerified,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'businesses';
  @override
  VerificationContext validateIntegrity(Insertable<BusinessesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
          _ownerUserIdMeta,
          ownerUserId.isAcceptableOrUnknown(
              data['owner_user_id']!, _ownerUserIdMeta));
    } else if (isInserting) {
      context.missing(_ownerUserIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('logo')) {
      context.handle(
          _logoMeta, logo.isAcceptableOrUnknown(data['logo']!, _logoMeta));
    }
    if (data.containsKey('cover_image')) {
      context.handle(
          _coverImageMeta,
          coverImage.isAcceptableOrUnknown(
              data['cover_image']!, _coverImageMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('is_verified')) {
      context.handle(
          _isVerifiedMeta,
          isVerified.isAcceptableOrUnknown(
              data['is_verified']!, _isVerifiedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      ownerUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      logo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo']),
      coverImage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover_image']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      isVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_verified'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $BusinessesTable createAlias(String alias) {
    return $BusinessesTable(attachedDatabase, alias);
  }
}

class BusinessesData extends DataClass implements Insertable<BusinessesData> {
  final String id;
  final String locationId;
  final String ownerUserId;
  final String name;
  final String slug;
  final String category;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final String status;
  const BusinessesData(
      {required this.id,
      required this.locationId,
      required this.ownerUserId,
      required this.name,
      required this.slug,
      required this.category,
      this.description,
      this.logo,
      this.coverImage,
      this.phone,
      this.address,
      this.latitude,
      this.longitude,
      required this.isVerified,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['owner_user_id'] = Variable<String>(ownerUserId);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || logo != null) {
      map['logo'] = Variable<String>(logo);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    map['is_verified'] = Variable<bool>(isVerified);
    map['status'] = Variable<String>(status);
    return map;
  }

  BusinessesCompanion toCompanion(bool nullToAbsent) {
    return BusinessesCompanion(
      id: Value(id),
      locationId: Value(locationId),
      ownerUserId: Value(ownerUserId),
      name: Value(name),
      slug: Value(slug),
      category: Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      logo: logo == null && nullToAbsent ? const Value.absent() : Value(logo),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      isVerified: Value(isVerified),
      status: Value(status),
    );
  }

  factory BusinessesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessesData(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      ownerUserId: serializer.fromJson<String>(json['ownerUserId']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      logo: serializer.fromJson<String?>(json['logo']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'ownerUserId': serializer.toJson<String>(ownerUserId),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String?>(description),
      'logo': serializer.toJson<String?>(logo),
      'coverImage': serializer.toJson<String?>(coverImage),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'isVerified': serializer.toJson<bool>(isVerified),
      'status': serializer.toJson<String>(status),
    };
  }

  BusinessesData copyWith(
          {String? id,
          String? locationId,
          String? ownerUserId,
          String? name,
          String? slug,
          String? category,
          Value<String?> description = const Value.absent(),
          Value<String?> logo = const Value.absent(),
          Value<String?> coverImage = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          bool? isVerified,
          String? status}) =>
      BusinessesData(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        ownerUserId: ownerUserId ?? this.ownerUserId,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        category: category ?? this.category,
        description: description.present ? description.value : this.description,
        logo: logo.present ? logo.value : this.logo,
        coverImage: coverImage.present ? coverImage.value : this.coverImage,
        phone: phone.present ? phone.value : this.phone,
        address: address.present ? address.value : this.address,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        isVerified: isVerified ?? this.isVerified,
        status: status ?? this.status,
      );
  BusinessesData copyWithCompanion(BusinessesCompanion data) {
    return BusinessesData(
      id: data.id.present ? data.id.value : this.id,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      ownerUserId:
          data.ownerUserId.present ? data.ownerUserId.value : this.ownerUserId,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      logo: data.logo.present ? data.logo.value : this.logo,
      coverImage:
          data.coverImage.present ? data.coverImage.value : this.coverImage,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isVerified:
          data.isVerified.present ? data.isVerified.value : this.isVerified,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessesData(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('logo: $logo, ')
          ..write('coverImage: $coverImage, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isVerified: $isVerified, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      locationId,
      ownerUserId,
      name,
      slug,
      category,
      description,
      logo,
      coverImage,
      phone,
      address,
      latitude,
      longitude,
      isVerified,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessesData &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.ownerUserId == this.ownerUserId &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.category == this.category &&
          other.description == this.description &&
          other.logo == this.logo &&
          other.coverImage == this.coverImage &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isVerified == this.isVerified &&
          other.status == this.status);
}

class BusinessesCompanion extends UpdateCompanion<BusinessesData> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> ownerUserId;
  final Value<String> name;
  final Value<String> slug;
  final Value<String> category;
  final Value<String?> description;
  final Value<String?> logo;
  final Value<String?> coverImage;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<bool> isVerified;
  final Value<String> status;
  final Value<int> rowid;
  const BusinessesCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.logo = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessesCompanion.insert({
    required String id,
    required String locationId,
    required String ownerUserId,
    required String name,
    required String slug,
    required String category,
    this.description = const Value.absent(),
    this.logo = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        locationId = Value(locationId),
        ownerUserId = Value(ownerUserId),
        name = Value(name),
        slug = Value(slug),
        category = Value(category);
  static Insertable<BusinessesData> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? ownerUserId,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? category,
    Expression<String>? description,
    Expression<String>? logo,
    Expression<String>? coverImage,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isVerified,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (logo != null) 'logo': logo,
      if (coverImage != null) 'cover_image': coverImage,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isVerified != null) 'is_verified': isVerified,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessesCompanion copyWith(
      {Value<String>? id,
      Value<String>? locationId,
      Value<String>? ownerUserId,
      Value<String>? name,
      Value<String>? slug,
      Value<String>? category,
      Value<String?>? description,
      Value<String?>? logo,
      Value<String?>? coverImage,
      Value<String?>? phone,
      Value<String?>? address,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<bool>? isVerified,
      Value<String>? status,
      Value<int>? rowid}) {
    return BusinessesCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      category: category ?? this.category,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      coverImage: coverImage ?? this.coverImage,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<String>(ownerUserId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessesCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('logo: $logo, ')
          ..write('coverImage: $coverImage, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isVerified: $isVerified, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopsTable extends Shops with TableInfo<$ShopsTable, Shop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketIdMeta =
      const VerificationMeta('marketId');
  @override
  late final GeneratedColumn<String> marketId = GeneratedColumn<String>(
      'market_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _marketNameMeta =
      const VerificationMeta('marketName');
  @override
  late final GeneratedColumn<String> marketName = GeneratedColumn<String>(
      'market_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryNameMeta =
      const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
      'category_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contactPhoneMeta =
      const VerificationMeta('contactPhone');
  @override
  late final GeneratedColumn<String> contactPhone = GeneratedColumn<String>(
      'contact_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagesJsonMeta =
      const VerificationMeta('imagesJson');
  @override
  late final GeneratedColumn<String> imagesJson = GeneratedColumn<String>(
      'images_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _isFeaturedMeta =
      const VerificationMeta('isFeatured');
  @override
  late final GeneratedColumn<bool> isFeatured = GeneratedColumn<bool>(
      'is_featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_featured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _moderationStatusMeta =
      const VerificationMeta('moderationStatus');
  @override
  late final GeneratedColumn<String> moderationStatus = GeneratedColumn<String>(
      'moderation_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sellerIdMeta =
      const VerificationMeta('sellerId');
  @override
  late final GeneratedColumn<String> sellerId = GeneratedColumn<String>(
      'seller_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sellerFullNameMeta =
      const VerificationMeta('sellerFullName');
  @override
  late final GeneratedColumn<String> sellerFullName = GeneratedColumn<String>(
      'seller_full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sellerPhoneVerifiedMeta =
      const VerificationMeta('sellerPhoneVerified');
  @override
  late final GeneratedColumn<bool> sellerPhoneVerified = GeneratedColumn<bool>(
      'seller_phone_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("seller_phone_verified" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        marketId,
        marketName,
        categoryId,
        categoryName,
        name,
        description,
        contactPhone,
        imagesJson,
        isFeatured,
        status,
        moderationStatus,
        createdAt,
        sellerId,
        sellerFullName,
        sellerPhoneVerified
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shops';
  @override
  VerificationContext validateIntegrity(Insertable<Shop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('market_id')) {
      context.handle(_marketIdMeta,
          marketId.isAcceptableOrUnknown(data['market_id']!, _marketIdMeta));
    } else if (isInserting) {
      context.missing(_marketIdMeta);
    }
    if (data.containsKey('market_name')) {
      context.handle(
          _marketNameMeta,
          marketName.isAcceptableOrUnknown(
              data['market_name']!, _marketNameMeta));
    } else if (isInserting) {
      context.missing(_marketNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
          _categoryNameMeta,
          categoryName.isAcceptableOrUnknown(
              data['category_name']!, _categoryNameMeta));
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('contact_phone')) {
      context.handle(
          _contactPhoneMeta,
          contactPhone.isAcceptableOrUnknown(
              data['contact_phone']!, _contactPhoneMeta));
    }
    if (data.containsKey('images_json')) {
      context.handle(
          _imagesJsonMeta,
          imagesJson.isAcceptableOrUnknown(
              data['images_json']!, _imagesJsonMeta));
    }
    if (data.containsKey('is_featured')) {
      context.handle(
          _isFeaturedMeta,
          isFeatured.isAcceptableOrUnknown(
              data['is_featured']!, _isFeaturedMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('moderation_status')) {
      context.handle(
          _moderationStatusMeta,
          moderationStatus.isAcceptableOrUnknown(
              data['moderation_status']!, _moderationStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('seller_id')) {
      context.handle(_sellerIdMeta,
          sellerId.isAcceptableOrUnknown(data['seller_id']!, _sellerIdMeta));
    } else if (isInserting) {
      context.missing(_sellerIdMeta);
    }
    if (data.containsKey('seller_full_name')) {
      context.handle(
          _sellerFullNameMeta,
          sellerFullName.isAcceptableOrUnknown(
              data['seller_full_name']!, _sellerFullNameMeta));
    } else if (isInserting) {
      context.missing(_sellerFullNameMeta);
    }
    if (data.containsKey('seller_phone_verified')) {
      context.handle(
          _sellerPhoneVerifiedMeta,
          sellerPhoneVerified.isAcceptableOrUnknown(
              data['seller_phone_verified']!, _sellerPhoneVerifiedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shop(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      marketId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_id'])!,
      marketName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}market_name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      categoryName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_name'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      contactPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_phone']),
      imagesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}images_json'])!,
      isFeatured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_featured'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      moderationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}moderation_status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      sellerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}seller_id'])!,
      sellerFullName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}seller_full_name'])!,
      sellerPhoneVerified: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}seller_phone_verified'])!,
    );
  }

  @override
  $ShopsTable createAlias(String alias) {
    return $ShopsTable(attachedDatabase, alias);
  }
}

class Shop extends DataClass implements Insertable<Shop> {
  final String id;
  final String marketId;
  final String marketName;
  final String categoryId;
  final String categoryName;
  final String name;
  final String? description;
  final String? contactPhone;
  final String imagesJson;
  final bool isFeatured;
  final String status;
  final String moderationStatus;
  final DateTime? createdAt;
  final String sellerId;
  final String sellerFullName;
  final bool sellerPhoneVerified;
  const Shop(
      {required this.id,
      required this.marketId,
      required this.marketName,
      required this.categoryId,
      required this.categoryName,
      required this.name,
      this.description,
      this.contactPhone,
      required this.imagesJson,
      required this.isFeatured,
      required this.status,
      required this.moderationStatus,
      this.createdAt,
      required this.sellerId,
      required this.sellerFullName,
      required this.sellerPhoneVerified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['market_id'] = Variable<String>(marketId);
    map['market_name'] = Variable<String>(marketName);
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || contactPhone != null) {
      map['contact_phone'] = Variable<String>(contactPhone);
    }
    map['images_json'] = Variable<String>(imagesJson);
    map['is_featured'] = Variable<bool>(isFeatured);
    map['status'] = Variable<String>(status);
    map['moderation_status'] = Variable<String>(moderationStatus);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    map['seller_id'] = Variable<String>(sellerId);
    map['seller_full_name'] = Variable<String>(sellerFullName);
    map['seller_phone_verified'] = Variable<bool>(sellerPhoneVerified);
    return map;
  }

  ShopsCompanion toCompanion(bool nullToAbsent) {
    return ShopsCompanion(
      id: Value(id),
      marketId: Value(marketId),
      marketName: Value(marketName),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      contactPhone: contactPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPhone),
      imagesJson: Value(imagesJson),
      isFeatured: Value(isFeatured),
      status: Value(status),
      moderationStatus: Value(moderationStatus),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      sellerId: Value(sellerId),
      sellerFullName: Value(sellerFullName),
      sellerPhoneVerified: Value(sellerPhoneVerified),
    );
  }

  factory Shop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shop(
      id: serializer.fromJson<String>(json['id']),
      marketId: serializer.fromJson<String>(json['marketId']),
      marketName: serializer.fromJson<String>(json['marketName']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      contactPhone: serializer.fromJson<String?>(json['contactPhone']),
      imagesJson: serializer.fromJson<String>(json['imagesJson']),
      isFeatured: serializer.fromJson<bool>(json['isFeatured']),
      status: serializer.fromJson<String>(json['status']),
      moderationStatus: serializer.fromJson<String>(json['moderationStatus']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      sellerId: serializer.fromJson<String>(json['sellerId']),
      sellerFullName: serializer.fromJson<String>(json['sellerFullName']),
      sellerPhoneVerified:
          serializer.fromJson<bool>(json['sellerPhoneVerified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'marketId': serializer.toJson<String>(marketId),
      'marketName': serializer.toJson<String>(marketName),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'contactPhone': serializer.toJson<String?>(contactPhone),
      'imagesJson': serializer.toJson<String>(imagesJson),
      'isFeatured': serializer.toJson<bool>(isFeatured),
      'status': serializer.toJson<String>(status),
      'moderationStatus': serializer.toJson<String>(moderationStatus),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'sellerId': serializer.toJson<String>(sellerId),
      'sellerFullName': serializer.toJson<String>(sellerFullName),
      'sellerPhoneVerified': serializer.toJson<bool>(sellerPhoneVerified),
    };
  }

  Shop copyWith(
          {String? id,
          String? marketId,
          String? marketName,
          String? categoryId,
          String? categoryName,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> contactPhone = const Value.absent(),
          String? imagesJson,
          bool? isFeatured,
          String? status,
          String? moderationStatus,
          Value<DateTime?> createdAt = const Value.absent(),
          String? sellerId,
          String? sellerFullName,
          bool? sellerPhoneVerified}) =>
      Shop(
        id: id ?? this.id,
        marketId: marketId ?? this.marketId,
        marketName: marketName ?? this.marketName,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        contactPhone:
            contactPhone.present ? contactPhone.value : this.contactPhone,
        imagesJson: imagesJson ?? this.imagesJson,
        isFeatured: isFeatured ?? this.isFeatured,
        status: status ?? this.status,
        moderationStatus: moderationStatus ?? this.moderationStatus,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        sellerId: sellerId ?? this.sellerId,
        sellerFullName: sellerFullName ?? this.sellerFullName,
        sellerPhoneVerified: sellerPhoneVerified ?? this.sellerPhoneVerified,
      );
  Shop copyWithCompanion(ShopsCompanion data) {
    return Shop(
      id: data.id.present ? data.id.value : this.id,
      marketId: data.marketId.present ? data.marketId.value : this.marketId,
      marketName:
          data.marketName.present ? data.marketName.value : this.marketName,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      contactPhone: data.contactPhone.present
          ? data.contactPhone.value
          : this.contactPhone,
      imagesJson:
          data.imagesJson.present ? data.imagesJson.value : this.imagesJson,
      isFeatured:
          data.isFeatured.present ? data.isFeatured.value : this.isFeatured,
      status: data.status.present ? data.status.value : this.status,
      moderationStatus: data.moderationStatus.present
          ? data.moderationStatus.value
          : this.moderationStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sellerId: data.sellerId.present ? data.sellerId.value : this.sellerId,
      sellerFullName: data.sellerFullName.present
          ? data.sellerFullName.value
          : this.sellerFullName,
      sellerPhoneVerified: data.sellerPhoneVerified.present
          ? data.sellerPhoneVerified.value
          : this.sellerPhoneVerified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shop(')
          ..write('id: $id, ')
          ..write('marketId: $marketId, ')
          ..write('marketName: $marketName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('status: $status, ')
          ..write('moderationStatus: $moderationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('sellerId: $sellerId, ')
          ..write('sellerFullName: $sellerFullName, ')
          ..write('sellerPhoneVerified: $sellerPhoneVerified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      marketId,
      marketName,
      categoryId,
      categoryName,
      name,
      description,
      contactPhone,
      imagesJson,
      isFeatured,
      status,
      moderationStatus,
      createdAt,
      sellerId,
      sellerFullName,
      sellerPhoneVerified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shop &&
          other.id == this.id &&
          other.marketId == this.marketId &&
          other.marketName == this.marketName &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.name == this.name &&
          other.description == this.description &&
          other.contactPhone == this.contactPhone &&
          other.imagesJson == this.imagesJson &&
          other.isFeatured == this.isFeatured &&
          other.status == this.status &&
          other.moderationStatus == this.moderationStatus &&
          other.createdAt == this.createdAt &&
          other.sellerId == this.sellerId &&
          other.sellerFullName == this.sellerFullName &&
          other.sellerPhoneVerified == this.sellerPhoneVerified);
}

class ShopsCompanion extends UpdateCompanion<Shop> {
  final Value<String> id;
  final Value<String> marketId;
  final Value<String> marketName;
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> contactPhone;
  final Value<String> imagesJson;
  final Value<bool> isFeatured;
  final Value<String> status;
  final Value<String> moderationStatus;
  final Value<DateTime?> createdAt;
  final Value<String> sellerId;
  final Value<String> sellerFullName;
  final Value<bool> sellerPhoneVerified;
  final Value<int> rowid;
  const ShopsCompanion({
    this.id = const Value.absent(),
    this.marketId = const Value.absent(),
    this.marketName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.status = const Value.absent(),
    this.moderationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sellerId = const Value.absent(),
    this.sellerFullName = const Value.absent(),
    this.sellerPhoneVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopsCompanion.insert({
    required String id,
    required String marketId,
    required String marketName,
    required String categoryId,
    required String categoryName,
    required String name,
    this.description = const Value.absent(),
    this.contactPhone = const Value.absent(),
    this.imagesJson = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.status = const Value.absent(),
    this.moderationStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    required String sellerId,
    required String sellerFullName,
    this.sellerPhoneVerified = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        marketId = Value(marketId),
        marketName = Value(marketName),
        categoryId = Value(categoryId),
        categoryName = Value(categoryName),
        name = Value(name),
        sellerId = Value(sellerId),
        sellerFullName = Value(sellerFullName);
  static Insertable<Shop> custom({
    Expression<String>? id,
    Expression<String>? marketId,
    Expression<String>? marketName,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? contactPhone,
    Expression<String>? imagesJson,
    Expression<bool>? isFeatured,
    Expression<String>? status,
    Expression<String>? moderationStatus,
    Expression<DateTime>? createdAt,
    Expression<String>? sellerId,
    Expression<String>? sellerFullName,
    Expression<bool>? sellerPhoneVerified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (marketId != null) 'market_id': marketId,
      if (marketName != null) 'market_name': marketName,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (imagesJson != null) 'images_json': imagesJson,
      if (isFeatured != null) 'is_featured': isFeatured,
      if (status != null) 'status': status,
      if (moderationStatus != null) 'moderation_status': moderationStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (sellerId != null) 'seller_id': sellerId,
      if (sellerFullName != null) 'seller_full_name': sellerFullName,
      if (sellerPhoneVerified != null)
        'seller_phone_verified': sellerPhoneVerified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopsCompanion copyWith(
      {Value<String>? id,
      Value<String>? marketId,
      Value<String>? marketName,
      Value<String>? categoryId,
      Value<String>? categoryName,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? contactPhone,
      Value<String>? imagesJson,
      Value<bool>? isFeatured,
      Value<String>? status,
      Value<String>? moderationStatus,
      Value<DateTime?>? createdAt,
      Value<String>? sellerId,
      Value<String>? sellerFullName,
      Value<bool>? sellerPhoneVerified,
      Value<int>? rowid}) {
    return ShopsCompanion(
      id: id ?? this.id,
      marketId: marketId ?? this.marketId,
      marketName: marketName ?? this.marketName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      name: name ?? this.name,
      description: description ?? this.description,
      contactPhone: contactPhone ?? this.contactPhone,
      imagesJson: imagesJson ?? this.imagesJson,
      isFeatured: isFeatured ?? this.isFeatured,
      status: status ?? this.status,
      moderationStatus: moderationStatus ?? this.moderationStatus,
      createdAt: createdAt ?? this.createdAt,
      sellerId: sellerId ?? this.sellerId,
      sellerFullName: sellerFullName ?? this.sellerFullName,
      sellerPhoneVerified: sellerPhoneVerified ?? this.sellerPhoneVerified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (marketId.present) {
      map['market_id'] = Variable<String>(marketId.value);
    }
    if (marketName.present) {
      map['market_name'] = Variable<String>(marketName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (contactPhone.present) {
      map['contact_phone'] = Variable<String>(contactPhone.value);
    }
    if (imagesJson.present) {
      map['images_json'] = Variable<String>(imagesJson.value);
    }
    if (isFeatured.present) {
      map['is_featured'] = Variable<bool>(isFeatured.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (moderationStatus.present) {
      map['moderation_status'] = Variable<String>(moderationStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sellerId.present) {
      map['seller_id'] = Variable<String>(sellerId.value);
    }
    if (sellerFullName.present) {
      map['seller_full_name'] = Variable<String>(sellerFullName.value);
    }
    if (sellerPhoneVerified.present) {
      map['seller_phone_verified'] = Variable<bool>(sellerPhoneVerified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopsCompanion(')
          ..write('id: $id, ')
          ..write('marketId: $marketId, ')
          ..write('marketName: $marketName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('contactPhone: $contactPhone, ')
          ..write('imagesJson: $imagesJson, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('status: $status, ')
          ..write('moderationStatus: $moderationStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('sellerId: $sellerId, ')
          ..write('sellerFullName: $sellerFullName, ')
          ..write('sellerPhoneVerified: $sellerPhoneVerified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopCategoriesTable extends ShopCategories
    with TableInfo<$ShopCategoriesTable, ShopCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, slug, icon, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ShopCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $ShopCategoriesTable createAlias(String alias) {
    return $ShopCategoriesTable(attachedDatabase, alias);
  }
}

class ShopCategory extends DataClass implements Insertable<ShopCategory> {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final int sortOrder;
  const ShopCategory(
      {required this.id,
      required this.name,
      required this.slug,
      this.icon,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ShopCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ShopCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      slug: Value(slug),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
    );
  }

  factory ShopCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      slug: serializer.fromJson<String>(json['slug']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'slug': serializer.toJson<String>(slug),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ShopCategory copyWith(
          {String? id,
          String? name,
          String? slug,
          Value<String?> icon = const Value.absent(),
          int? sortOrder}) =>
      ShopCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        slug: slug ?? this.slug,
        icon: icon.present ? icon.value : this.icon,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  ShopCategory copyWithCompanion(ShopCategoriesCompanion data) {
    return ShopCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      slug: data.slug.present ? data.slug.value : this.slug,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, slug, icon, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.slug == this.slug &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder);
}

class ShopCategoriesCompanion extends UpdateCompanion<ShopCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> slug;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ShopCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.slug = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopCategoriesCompanion.insert({
    required String id,
    required String name,
    required String slug,
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        slug = Value(slug);
  static Insertable<ShopCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? slug,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (slug != null) 'slug': slug,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? slug,
      Value<String?>? icon,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return ShopCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('slug: $slug, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepresentativesTable extends Representatives
    with TableInfo<$RepresentativesTable, Representative> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepresentativesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<String> position = GeneratedColumn<String>(
      'position', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ward_member'));
  static const VerificationMeta _bioMeta = const VerificationMeta('bio');
  @override
  late final GeneratedColumn<String> bio = GeneratedColumn<String>(
      'bio', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        fullName,
        phone,
        locationId,
        locationName,
        position,
        bio,
        photoUrl,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'representatives';
  @override
  VerificationContext validateIntegrity(Insertable<Representative> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('bio')) {
      context.handle(
          _bioMeta, bio.isAcceptableOrUnknown(data['bio']!, _bioMeta));
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Representative map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Representative(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}position'])!,
      bio: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bio']),
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $RepresentativesTable createAlias(String alias) {
    return $RepresentativesTable(attachedDatabase, alias);
  }
}

class Representative extends DataClass implements Insertable<Representative> {
  final String id;
  final String userId;
  final String fullName;
  final String? phone;
  final String locationId;
  final String locationName;
  final String position;
  final String? bio;
  final String? photoUrl;
  final String status;
  const Representative(
      {required this.id,
      required this.userId,
      required this.fullName,
      this.phone,
      required this.locationId,
      required this.locationName,
      required this.position,
      this.bio,
      this.photoUrl,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['location_id'] = Variable<String>(locationId);
    map['location_name'] = Variable<String>(locationName);
    map['position'] = Variable<String>(position);
    if (!nullToAbsent || bio != null) {
      map['bio'] = Variable<String>(bio);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  RepresentativesCompanion toCompanion(bool nullToAbsent) {
    return RepresentativesCompanion(
      id: Value(id),
      userId: Value(userId),
      fullName: Value(fullName),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      locationId: Value(locationId),
      locationName: Value(locationName),
      position: Value(position),
      bio: bio == null && nullToAbsent ? const Value.absent() : Value(bio),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      status: Value(status),
    );
  }

  factory Representative.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Representative(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String?>(json['phone']),
      locationId: serializer.fromJson<String>(json['locationId']),
      locationName: serializer.fromJson<String>(json['locationName']),
      position: serializer.fromJson<String>(json['position']),
      bio: serializer.fromJson<String?>(json['bio']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String?>(phone),
      'locationId': serializer.toJson<String>(locationId),
      'locationName': serializer.toJson<String>(locationName),
      'position': serializer.toJson<String>(position),
      'bio': serializer.toJson<String?>(bio),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'status': serializer.toJson<String>(status),
    };
  }

  Representative copyWith(
          {String? id,
          String? userId,
          String? fullName,
          Value<String?> phone = const Value.absent(),
          String? locationId,
          String? locationName,
          String? position,
          Value<String?> bio = const Value.absent(),
          Value<String?> photoUrl = const Value.absent(),
          String? status}) =>
      Representative(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        fullName: fullName ?? this.fullName,
        phone: phone.present ? phone.value : this.phone,
        locationId: locationId ?? this.locationId,
        locationName: locationName ?? this.locationName,
        position: position ?? this.position,
        bio: bio.present ? bio.value : this.bio,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        status: status ?? this.status,
      );
  Representative copyWithCompanion(RepresentativesCompanion data) {
    return Representative(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      position: data.position.present ? data.position.value : this.position,
      bio: data.bio.present ? data.bio.value : this.bio,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Representative(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('locationId: $locationId, ')
          ..write('locationName: $locationName, ')
          ..write('position: $position, ')
          ..write('bio: $bio, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, fullName, phone, locationId,
      locationName, position, bio, photoUrl, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Representative &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.locationId == this.locationId &&
          other.locationName == this.locationName &&
          other.position == this.position &&
          other.bio == this.bio &&
          other.photoUrl == this.photoUrl &&
          other.status == this.status);
}

class RepresentativesCompanion extends UpdateCompanion<Representative> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> fullName;
  final Value<String?> phone;
  final Value<String> locationId;
  final Value<String> locationName;
  final Value<String> position;
  final Value<String?> bio;
  final Value<String?> photoUrl;
  final Value<String> status;
  final Value<int> rowid;
  const RepresentativesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.locationId = const Value.absent(),
    this.locationName = const Value.absent(),
    this.position = const Value.absent(),
    this.bio = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepresentativesCompanion.insert({
    required String id,
    required String userId,
    required String fullName,
    this.phone = const Value.absent(),
    required String locationId,
    required String locationName,
    this.position = const Value.absent(),
    this.bio = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        fullName = Value(fullName),
        locationId = Value(locationId),
        locationName = Value(locationName);
  static Insertable<Representative> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? locationId,
    Expression<String>? locationName,
    Expression<String>? position,
    Expression<String>? bio,
    Expression<String>? photoUrl,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (locationId != null) 'location_id': locationId,
      if (locationName != null) 'location_name': locationName,
      if (position != null) 'position': position,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepresentativesCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? fullName,
      Value<String?>? phone,
      Value<String>? locationId,
      Value<String>? locationName,
      Value<String>? position,
      Value<String?>? bio,
      Value<String?>? photoUrl,
      Value<String>? status,
      Value<int>? rowid}) {
    return RepresentativesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      position: position ?? this.position,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (position.present) {
      map['position'] = Variable<String>(position.value);
    }
    if (bio.present) {
      map['bio'] = Variable<String>(bio.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepresentativesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('locationId: $locationId, ')
          ..write('locationName: $locationName, ')
          ..write('position: $position, ')
          ..write('bio: $bio, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NewsArticlesTable extends NewsArticles
    with TableInfo<$NewsArticlesTable, NewsArticle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NewsArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
      'slug', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
      'published_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('published'));
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originalUrlMeta =
      const VerificationMeta('originalUrl');
  @override
  late final GeneratedColumn<String> originalUrl = GeneratedColumn<String>(
      'original_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        locationId,
        category,
        title,
        slug,
        summary,
        image,
        publishedAt,
        status,
        body,
        originalUrl
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'news_articles';
  @override
  VerificationContext validateIntegrity(Insertable<NewsArticle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
          _slugMeta, slug.isAcceptableOrUnknown(data['slug']!, _slugMeta));
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    }
    if (data.containsKey('original_url')) {
      context.handle(
          _originalUrlMeta,
          originalUrl.isAcceptableOrUnknown(
              data['original_url']!, _originalUrlMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NewsArticle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NewsArticle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      slug: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}slug'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}published_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body']),
      originalUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}original_url']),
    );
  }

  @override
  $NewsArticlesTable createAlias(String alias) {
    return $NewsArticlesTable(attachedDatabase, alias);
  }
}

class NewsArticle extends DataClass implements Insertable<NewsArticle> {
  final String id;
  final String sourceId;
  final String? locationId;
  final String? category;
  final String title;
  final String slug;
  final String? summary;
  final String? image;
  final DateTime? publishedAt;
  final String status;
  final String? body;
  final String? originalUrl;
  const NewsArticle(
      {required this.id,
      required this.sourceId,
      this.locationId,
      this.category,
      required this.title,
      required this.slug,
      this.summary,
      this.image,
      this.publishedAt,
      required this.status,
      this.body,
      this.originalUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['title'] = Variable<String>(title);
    map['slug'] = Variable<String>(slug);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    if (!nullToAbsent || originalUrl != null) {
      map['original_url'] = Variable<String>(originalUrl);
    }
    return map;
  }

  NewsArticlesCompanion toCompanion(bool nullToAbsent) {
    return NewsArticlesCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      title: Value(title),
      slug: Value(slug),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      status: Value(status),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      originalUrl: originalUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(originalUrl),
    );
  }

  factory NewsArticle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NewsArticle(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      category: serializer.fromJson<String?>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      slug: serializer.fromJson<String>(json['slug']),
      summary: serializer.fromJson<String?>(json['summary']),
      image: serializer.fromJson<String?>(json['image']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      status: serializer.fromJson<String>(json['status']),
      body: serializer.fromJson<String?>(json['body']),
      originalUrl: serializer.fromJson<String?>(json['originalUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'locationId': serializer.toJson<String?>(locationId),
      'category': serializer.toJson<String?>(category),
      'title': serializer.toJson<String>(title),
      'slug': serializer.toJson<String>(slug),
      'summary': serializer.toJson<String?>(summary),
      'image': serializer.toJson<String?>(image),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'status': serializer.toJson<String>(status),
      'body': serializer.toJson<String?>(body),
      'originalUrl': serializer.toJson<String?>(originalUrl),
    };
  }

  NewsArticle copyWith(
          {String? id,
          String? sourceId,
          Value<String?> locationId = const Value.absent(),
          Value<String?> category = const Value.absent(),
          String? title,
          String? slug,
          Value<String?> summary = const Value.absent(),
          Value<String?> image = const Value.absent(),
          Value<DateTime?> publishedAt = const Value.absent(),
          String? status,
          Value<String?> body = const Value.absent(),
          Value<String?> originalUrl = const Value.absent()}) =>
      NewsArticle(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        locationId: locationId.present ? locationId.value : this.locationId,
        category: category.present ? category.value : this.category,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        summary: summary.present ? summary.value : this.summary,
        image: image.present ? image.value : this.image,
        publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
        status: status ?? this.status,
        body: body.present ? body.value : this.body,
        originalUrl: originalUrl.present ? originalUrl.value : this.originalUrl,
      );
  NewsArticle copyWithCompanion(NewsArticlesCompanion data) {
    return NewsArticle(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      slug: data.slug.present ? data.slug.value : this.slug,
      summary: data.summary.present ? data.summary.value : this.summary,
      image: data.image.present ? data.image.value : this.image,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      status: data.status.present ? data.status.value : this.status,
      body: data.body.present ? data.body.value : this.body,
      originalUrl:
          data.originalUrl.present ? data.originalUrl.value : this.originalUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NewsArticle(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('locationId: $locationId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('status: $status, ')
          ..write('body: $body, ')
          ..write('originalUrl: $originalUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, locationId, category, title,
      slug, summary, image, publishedAt, status, body, originalUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NewsArticle &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.locationId == this.locationId &&
          other.category == this.category &&
          other.title == this.title &&
          other.slug == this.slug &&
          other.summary == this.summary &&
          other.image == this.image &&
          other.publishedAt == this.publishedAt &&
          other.status == this.status &&
          other.body == this.body &&
          other.originalUrl == this.originalUrl);
}

class NewsArticlesCompanion extends UpdateCompanion<NewsArticle> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String?> locationId;
  final Value<String?> category;
  final Value<String> title;
  final Value<String> slug;
  final Value<String?> summary;
  final Value<String?> image;
  final Value<DateTime?> publishedAt;
  final Value<String> status;
  final Value<String?> body;
  final Value<String?> originalUrl;
  final Value<int> rowid;
  const NewsArticlesCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.slug = const Value.absent(),
    this.summary = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.body = const Value.absent(),
    this.originalUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NewsArticlesCompanion.insert({
    required String id,
    required String sourceId,
    this.locationId = const Value.absent(),
    this.category = const Value.absent(),
    required String title,
    required String slug,
    this.summary = const Value.absent(),
    this.image = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.body = const Value.absent(),
    this.originalUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceId = Value(sourceId),
        title = Value(title),
        slug = Value(slug);
  static Insertable<NewsArticle> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? locationId,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? slug,
    Expression<String>? summary,
    Expression<String>? image,
    Expression<DateTime>? publishedAt,
    Expression<String>? status,
    Expression<String>? body,
    Expression<String>? originalUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (locationId != null) 'location_id': locationId,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (slug != null) 'slug': slug,
      if (summary != null) 'summary': summary,
      if (image != null) 'image': image,
      if (publishedAt != null) 'published_at': publishedAt,
      if (status != null) 'status': status,
      if (body != null) 'body': body,
      if (originalUrl != null) 'original_url': originalUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NewsArticlesCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceId,
      Value<String?>? locationId,
      Value<String?>? category,
      Value<String>? title,
      Value<String>? slug,
      Value<String?>? summary,
      Value<String?>? image,
      Value<DateTime?>? publishedAt,
      Value<String>? status,
      Value<String?>? body,
      Value<String?>? originalUrl,
      Value<int>? rowid}) {
    return NewsArticlesCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      locationId: locationId ?? this.locationId,
      category: category ?? this.category,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      summary: summary ?? this.summary,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      status: status ?? this.status,
      body: body ?? this.body,
      originalUrl: originalUrl ?? this.originalUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (originalUrl.present) {
      map['original_url'] = Variable<String>(originalUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NewsArticlesCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('locationId: $locationId, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('slug: $slug, ')
          ..write('summary: $summary, ')
          ..write('image: $image, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('status: $status, ')
          ..write('body: $body, ')
          ..write('originalUrl: $originalUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eligibilityMeta =
      const VerificationMeta('eligibility');
  @override
  late final GeneratedColumn<String> eligibility = GeneratedColumn<String>(
      'eligibility', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _requiredDocumentsJsonMeta =
      const VerificationMeta('requiredDocumentsJson');
  @override
  late final GeneratedColumn<String> requiredDocumentsJson =
      GeneratedColumn<String>('required_documents_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<double> fee = GeneratedColumn<double>(
      'fee', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _officialLinkMeta =
      const VerificationMeta('officialLink');
  @override
  late final GeneratedColumn<String> officialLink = GeneratedColumn<String>(
      'official_link', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _officeNameMeta =
      const VerificationMeta('officeName');
  @override
  late final GeneratedColumn<String> officeName = GeneratedColumn<String>(
      'office_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _officeContactMeta =
      const VerificationMeta('officeContact');
  @override
  late final GeneratedColumn<String> officeContact = GeneratedColumn<String>(
      'office_contact', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('published'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        locationId,
        categoryId,
        name,
        description,
        eligibility,
        requiredDocumentsJson,
        fee,
        officialLink,
        officeName,
        officeContact,
        status
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(Insertable<Service> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    } else if (isInserting) {
      context.missing(_locationIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('eligibility')) {
      context.handle(
          _eligibilityMeta,
          eligibility.isAcceptableOrUnknown(
              data['eligibility']!, _eligibilityMeta));
    }
    if (data.containsKey('required_documents_json')) {
      context.handle(
          _requiredDocumentsJsonMeta,
          requiredDocumentsJson.isAcceptableOrUnknown(
              data['required_documents_json']!, _requiredDocumentsJsonMeta));
    }
    if (data.containsKey('fee')) {
      context.handle(
          _feeMeta, fee.isAcceptableOrUnknown(data['fee']!, _feeMeta));
    }
    if (data.containsKey('official_link')) {
      context.handle(
          _officialLinkMeta,
          officialLink.isAcceptableOrUnknown(
              data['official_link']!, _officialLinkMeta));
    }
    if (data.containsKey('office_name')) {
      context.handle(
          _officeNameMeta,
          officeName.isAcceptableOrUnknown(
              data['office_name']!, _officeNameMeta));
    }
    if (data.containsKey('office_contact')) {
      context.handle(
          _officeContactMeta,
          officeContact.isAcceptableOrUnknown(
              data['office_contact']!, _officeContactMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      eligibility: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eligibility']),
      requiredDocumentsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}required_documents_json'])!,
      fee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fee']),
      officialLink: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_link']),
      officeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}office_name']),
      officeContact: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}office_contact']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final String id;
  final String locationId;
  final String categoryId;
  final String name;
  final String? description;
  final String? eligibility;
  final String requiredDocumentsJson;
  final double? fee;
  final String? officialLink;
  final String? officeName;
  final String? officeContact;
  final String status;
  const Service(
      {required this.id,
      required this.locationId,
      required this.categoryId,
      required this.name,
      this.description,
      this.eligibility,
      required this.requiredDocumentsJson,
      this.fee,
      this.officialLink,
      this.officeName,
      this.officeContact,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['location_id'] = Variable<String>(locationId);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || eligibility != null) {
      map['eligibility'] = Variable<String>(eligibility);
    }
    map['required_documents_json'] = Variable<String>(requiredDocumentsJson);
    if (!nullToAbsent || fee != null) {
      map['fee'] = Variable<double>(fee);
    }
    if (!nullToAbsent || officialLink != null) {
      map['official_link'] = Variable<String>(officialLink);
    }
    if (!nullToAbsent || officeName != null) {
      map['office_name'] = Variable<String>(officeName);
    }
    if (!nullToAbsent || officeContact != null) {
      map['office_contact'] = Variable<String>(officeContact);
    }
    map['status'] = Variable<String>(status);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      locationId: Value(locationId),
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      eligibility: eligibility == null && nullToAbsent
          ? const Value.absent()
          : Value(eligibility),
      requiredDocumentsJson: Value(requiredDocumentsJson),
      fee: fee == null && nullToAbsent ? const Value.absent() : Value(fee),
      officialLink: officialLink == null && nullToAbsent
          ? const Value.absent()
          : Value(officialLink),
      officeName: officeName == null && nullToAbsent
          ? const Value.absent()
          : Value(officeName),
      officeContact: officeContact == null && nullToAbsent
          ? const Value.absent()
          : Value(officeContact),
      status: Value(status),
    );
  }

  factory Service.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<String>(json['id']),
      locationId: serializer.fromJson<String>(json['locationId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      eligibility: serializer.fromJson<String?>(json['eligibility']),
      requiredDocumentsJson:
          serializer.fromJson<String>(json['requiredDocumentsJson']),
      fee: serializer.fromJson<double?>(json['fee']),
      officialLink: serializer.fromJson<String?>(json['officialLink']),
      officeName: serializer.fromJson<String?>(json['officeName']),
      officeContact: serializer.fromJson<String?>(json['officeContact']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'locationId': serializer.toJson<String>(locationId),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'eligibility': serializer.toJson<String?>(eligibility),
      'requiredDocumentsJson': serializer.toJson<String>(requiredDocumentsJson),
      'fee': serializer.toJson<double?>(fee),
      'officialLink': serializer.toJson<String?>(officialLink),
      'officeName': serializer.toJson<String?>(officeName),
      'officeContact': serializer.toJson<String?>(officeContact),
      'status': serializer.toJson<String>(status),
    };
  }

  Service copyWith(
          {String? id,
          String? locationId,
          String? categoryId,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> eligibility = const Value.absent(),
          String? requiredDocumentsJson,
          Value<double?> fee = const Value.absent(),
          Value<String?> officialLink = const Value.absent(),
          Value<String?> officeName = const Value.absent(),
          Value<String?> officeContact = const Value.absent(),
          String? status}) =>
      Service(
        id: id ?? this.id,
        locationId: locationId ?? this.locationId,
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        eligibility: eligibility.present ? eligibility.value : this.eligibility,
        requiredDocumentsJson:
            requiredDocumentsJson ?? this.requiredDocumentsJson,
        fee: fee.present ? fee.value : this.fee,
        officialLink:
            officialLink.present ? officialLink.value : this.officialLink,
        officeName: officeName.present ? officeName.value : this.officeName,
        officeContact:
            officeContact.present ? officeContact.value : this.officeContact,
        status: status ?? this.status,
      );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      eligibility:
          data.eligibility.present ? data.eligibility.value : this.eligibility,
      requiredDocumentsJson: data.requiredDocumentsJson.present
          ? data.requiredDocumentsJson.value
          : this.requiredDocumentsJson,
      fee: data.fee.present ? data.fee.value : this.fee,
      officialLink: data.officialLink.present
          ? data.officialLink.value
          : this.officialLink,
      officeName:
          data.officeName.present ? data.officeName.value : this.officeName,
      officeContact: data.officeContact.present
          ? data.officeContact.value
          : this.officeContact,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('eligibility: $eligibility, ')
          ..write('requiredDocumentsJson: $requiredDocumentsJson, ')
          ..write('fee: $fee, ')
          ..write('officialLink: $officialLink, ')
          ..write('officeName: $officeName, ')
          ..write('officeContact: $officeContact, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      locationId,
      categoryId,
      name,
      description,
      eligibility,
      requiredDocumentsJson,
      fee,
      officialLink,
      officeName,
      officeContact,
      status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.locationId == this.locationId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.eligibility == this.eligibility &&
          other.requiredDocumentsJson == this.requiredDocumentsJson &&
          other.fee == this.fee &&
          other.officialLink == this.officialLink &&
          other.officeName == this.officeName &&
          other.officeContact == this.officeContact &&
          other.status == this.status);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<String> id;
  final Value<String> locationId;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> eligibility;
  final Value<String> requiredDocumentsJson;
  final Value<double?> fee;
  final Value<String?> officialLink;
  final Value<String?> officeName;
  final Value<String?> officeContact;
  final Value<String> status;
  final Value<int> rowid;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.locationId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.eligibility = const Value.absent(),
    this.requiredDocumentsJson = const Value.absent(),
    this.fee = const Value.absent(),
    this.officialLink = const Value.absent(),
    this.officeName = const Value.absent(),
    this.officeContact = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServicesCompanion.insert({
    required String id,
    required String locationId,
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    this.eligibility = const Value.absent(),
    this.requiredDocumentsJson = const Value.absent(),
    this.fee = const Value.absent(),
    this.officialLink = const Value.absent(),
    this.officeName = const Value.absent(),
    this.officeContact = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        locationId = Value(locationId),
        categoryId = Value(categoryId),
        name = Value(name);
  static Insertable<Service> custom({
    Expression<String>? id,
    Expression<String>? locationId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? eligibility,
    Expression<String>? requiredDocumentsJson,
    Expression<double>? fee,
    Expression<String>? officialLink,
    Expression<String>? officeName,
    Expression<String>? officeContact,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locationId != null) 'location_id': locationId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (eligibility != null) 'eligibility': eligibility,
      if (requiredDocumentsJson != null)
        'required_documents_json': requiredDocumentsJson,
      if (fee != null) 'fee': fee,
      if (officialLink != null) 'official_link': officialLink,
      if (officeName != null) 'office_name': officeName,
      if (officeContact != null) 'office_contact': officeContact,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? locationId,
      Value<String>? categoryId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? eligibility,
      Value<String>? requiredDocumentsJson,
      Value<double?>? fee,
      Value<String?>? officialLink,
      Value<String?>? officeName,
      Value<String?>? officeContact,
      Value<String>? status,
      Value<int>? rowid}) {
    return ServicesCompanion(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      eligibility: eligibility ?? this.eligibility,
      requiredDocumentsJson:
          requiredDocumentsJson ?? this.requiredDocumentsJson,
      fee: fee ?? this.fee,
      officialLink: officialLink ?? this.officialLink,
      officeName: officeName ?? this.officeName,
      officeContact: officeContact ?? this.officeContact,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (eligibility.present) {
      map['eligibility'] = Variable<String>(eligibility.value);
    }
    if (requiredDocumentsJson.present) {
      map['required_documents_json'] =
          Variable<String>(requiredDocumentsJson.value);
    }
    if (fee.present) {
      map['fee'] = Variable<double>(fee.value);
    }
    if (officialLink.present) {
      map['official_link'] = Variable<String>(officialLink.value);
    }
    if (officeName.present) {
      map['office_name'] = Variable<String>(officeName.value);
    }
    if (officeContact.present) {
      map['office_contact'] = Variable<String>(officeContact.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('locationId: $locationId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('eligibility: $eligibility, ')
          ..write('requiredDocumentsJson: $requiredDocumentsJson, ')
          ..write('fee: $fee, ')
          ..write('officialLink: $officialLink, ')
          ..write('officeName: $officeName, ')
          ..write('officeContact: $officeContact, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceCategoriesTable extends ServiceCategories
    with TableInfo<$ServiceCategoriesTable, ServiceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ServiceCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
    );
  }

  @override
  $ServiceCategoriesTable createAlias(String alias) {
    return $ServiceCategoriesTable(attachedDatabase, alias);
  }
}

class ServiceCategory extends DataClass implements Insertable<ServiceCategory> {
  final String id;
  final String name;
  final String? parentId;
  const ServiceCategory({required this.id, required this.name, this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    return map;
  }

  ServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ServiceCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory ServiceCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
    };
  }

  ServiceCategory copyWith(
          {String? id,
          String? name,
          Value<String?> parentId = const Value.absent()}) =>
      ServiceCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
      );
  ServiceCategory copyWithCompanion(ServiceCategoriesCompanion data) {
    return ServiceCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId);
}

class ServiceCategoriesCompanion extends UpdateCompanion<ServiceCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<int> rowid;
  const ServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceCategoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ServiceCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentId,
      Value<int>? rowid}) {
    return ServiceCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, type, name, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(Insertable<Location> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Location(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class Location extends DataClass implements Insertable<Location> {
  final String id;
  final String type;
  final String name;
  final String? parentId;
  const Location(
      {required this.id,
      required this.type,
      required this.name,
      this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory Location.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
    };
  }

  Location copyWith(
          {String? id,
          String? type,
          String? name,
          Value<String?> parentId = const Value.absent()}) =>
      Location(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
      );
  Location copyWithCompanion(LocationsCompanion data) {
    return Location(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, name, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.parentId == this.parentId);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<int> rowid;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String id,
    required String type,
    required String name,
    this.parentId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        name = Value(name);
  static Insertable<Location> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? name,
      Value<String?>? parentId,
      Value<int>? rowid}) {
    return LocationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FaqsTable extends Faqs with TableInfo<$FaqsTable, Faq> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaqsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
      'answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('published'));
  @override
  List<GeneratedColumn> get $columns => [id, question, answer, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'faqs';
  @override
  VerificationContext validateIntegrity(Insertable<Faq> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(_answerMeta,
          answer.isAcceptableOrUnknown(data['answer']!, _answerMeta));
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Faq map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Faq(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question'])!,
      answer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answer'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $FaqsTable createAlias(String alias) {
    return $FaqsTable(attachedDatabase, alias);
  }
}

class Faq extends DataClass implements Insertable<Faq> {
  final String id;
  final String question;
  final String answer;
  final String status;
  const Faq(
      {required this.id,
      required this.question,
      required this.answer,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question'] = Variable<String>(question);
    map['answer'] = Variable<String>(answer);
    map['status'] = Variable<String>(status);
    return map;
  }

  FaqsCompanion toCompanion(bool nullToAbsent) {
    return FaqsCompanion(
      id: Value(id),
      question: Value(question),
      answer: Value(answer),
      status: Value(status),
    );
  }

  factory Faq.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Faq(
      id: serializer.fromJson<String>(json['id']),
      question: serializer.fromJson<String>(json['question']),
      answer: serializer.fromJson<String>(json['answer']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'question': serializer.toJson<String>(question),
      'answer': serializer.toJson<String>(answer),
      'status': serializer.toJson<String>(status),
    };
  }

  Faq copyWith(
          {String? id, String? question, String? answer, String? status}) =>
      Faq(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        status: status ?? this.status,
      );
  Faq copyWithCompanion(FaqsCompanion data) {
    return Faq(
      id: data.id.present ? data.id.value : this.id,
      question: data.question.present ? data.question.value : this.question,
      answer: data.answer.present ? data.answer.value : this.answer,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Faq(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, question, answer, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Faq &&
          other.id == this.id &&
          other.question == this.question &&
          other.answer == this.answer &&
          other.status == this.status);
}

class FaqsCompanion extends UpdateCompanion<Faq> {
  final Value<String> id;
  final Value<String> question;
  final Value<String> answer;
  final Value<String> status;
  final Value<int> rowid;
  const FaqsCompanion({
    this.id = const Value.absent(),
    this.question = const Value.absent(),
    this.answer = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FaqsCompanion.insert({
    required String id,
    required String question,
    required String answer,
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        question = Value(question),
        answer = Value(answer);
  static Insertable<Faq> custom({
    Expression<String>? id,
    Expression<String>? question,
    Expression<String>? answer,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (question != null) 'question': question,
      if (answer != null) 'answer': answer,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FaqsCompanion copyWith(
      {Value<String>? id,
      Value<String>? question,
      Value<String>? answer,
      Value<String>? status,
      Value<int>? rowid}) {
    return FaqsCompanion(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaqsCompanion(')
          ..write('id: $id, ')
          ..write('question: $question, ')
          ..write('answer: $answer, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetaTable extends SyncMeta
    with TableInfo<$SyncMetaTable, SyncMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [entity, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_meta';
  @override
  VerificationContext validateIntegrity(Insertable<SyncMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entity};
  @override
  SyncMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetaData(
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at'])!,
    );
  }

  @override
  $SyncMetaTable createAlias(String alias) {
    return $SyncMetaTable(attachedDatabase, alias);
  }
}

class SyncMetaData extends DataClass implements Insertable<SyncMetaData> {
  final String entity;
  final DateTime lastSyncedAt;
  const SyncMetaData({required this.entity, required this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity'] = Variable<String>(entity);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  SyncMetaCompanion toCompanion(bool nullToAbsent) {
    return SyncMetaCompanion(
      entity: Value(entity),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory SyncMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetaData(
      entity: serializer.fromJson<String>(json['entity']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entity': serializer.toJson<String>(entity),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  SyncMetaData copyWith({String? entity, DateTime? lastSyncedAt}) =>
      SyncMetaData(
        entity: entity ?? this.entity,
        lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      );
  SyncMetaData copyWithCompanion(SyncMetaCompanion data) {
    return SyncMetaData(
      entity: data.entity.present ? data.entity.value : this.entity,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaData(')
          ..write('entity: $entity, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entity, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetaData &&
          other.entity == this.entity &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncMetaCompanion extends UpdateCompanion<SyncMetaData> {
  final Value<String> entity;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const SyncMetaCompanion({
    this.entity = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetaCompanion.insert({
    required String entity,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  })  : entity = Value(entity),
        lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncMetaData> custom({
    Expression<String>? entity,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entity != null) 'entity': entity,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetaCompanion copyWith(
      {Value<String>? entity,
      Value<DateTime>? lastSyncedAt,
      Value<int>? rowid}) {
    return SyncMetaCompanion(
      entity: entity ?? this.entity,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetaCompanion(')
          ..write('entity: $entity, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(e);
  $OfflineDatabaseManager get managers => $OfflineDatabaseManager(this);
  late final $PlacesTable places = $PlacesTable(this);
  late final $HospitalsTable hospitals = $HospitalsTable(this);
  late final $DoctorsTable doctors = $DoctorsTable(this);
  late final $MarketsTable markets = $MarketsTable(this);
  late final $BusinessesTable businesses = $BusinessesTable(this);
  late final $ShopsTable shops = $ShopsTable(this);
  late final $ShopCategoriesTable shopCategories = $ShopCategoriesTable(this);
  late final $RepresentativesTable representatives =
      $RepresentativesTable(this);
  late final $NewsArticlesTable newsArticles = $NewsArticlesTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $ServiceCategoriesTable serviceCategories =
      $ServiceCategoriesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $FaqsTable faqs = $FaqsTable(this);
  late final $SyncMetaTable syncMeta = $SyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        places,
        hospitals,
        doctors,
        markets,
        businesses,
        shops,
        shopCategories,
        representatives,
        newsArticles,
        services,
        serviceCategories,
        locations,
        faqs,
        syncMeta
      ];
}

typedef $$PlacesTableCreateCompanionBuilder = PlacesCompanion Function({
  required String id,
  required String locationId,
  required String name,
  required String slug,
  required String category,
  Value<String?> description,
  Value<String?> coverImage,
  Value<String> galleryJson,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> isFeatured,
  Value<String> status,
  Value<int> rowid,
});
typedef $$PlacesTableUpdateCompanionBuilder = PlacesCompanion Function({
  Value<String> id,
  Value<String> locationId,
  Value<String> name,
  Value<String> slug,
  Value<String> category,
  Value<String?> description,
  Value<String?> coverImage,
  Value<String> galleryJson,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> isFeatured,
  Value<String> status,
  Value<int> rowid,
});

class $$PlacesTableFilterComposer
    extends Composer<_$OfflineDatabase, $PlacesTable> {
  $$PlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get galleryJson => $composableBuilder(
      column: $table.galleryJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$PlacesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $PlacesTable> {
  $$PlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get galleryJson => $composableBuilder(
      column: $table.galleryJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$PlacesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $PlacesTable> {
  $$PlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => column);

  GeneratedColumn<String> get galleryJson => $composableBuilder(
      column: $table.galleryJson, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$PlacesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$OfflineDatabase, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()> {
  $$PlacesTableTableManager(_$OfflineDatabase db, $PlacesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String> galleryJson = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion(
            id: id,
            locationId: locationId,
            name: name,
            slug: slug,
            category: category,
            description: description,
            coverImage: coverImage,
            galleryJson: galleryJson,
            latitude: latitude,
            longitude: longitude,
            isFeatured: isFeatured,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String locationId,
            required String name,
            required String slug,
            required String category,
            Value<String?> description = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String> galleryJson = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlacesCompanion.insert(
            id: id,
            locationId: locationId,
            name: name,
            slug: slug,
            category: category,
            description: description,
            coverImage: coverImage,
            galleryJson: galleryJson,
            latitude: latitude,
            longitude: longitude,
            isFeatured: isFeatured,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PlacesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $PlacesTable,
    Place,
    $$PlacesTableFilterComposer,
    $$PlacesTableOrderingComposer,
    $$PlacesTableAnnotationComposer,
    $$PlacesTableCreateCompanionBuilder,
    $$PlacesTableUpdateCompanionBuilder,
    (Place, BaseReferences<_$OfflineDatabase, $PlacesTable, Place>),
    Place,
    PrefetchHooks Function()>;
typedef $$HospitalsTableCreateCompanionBuilder = HospitalsCompanion Function({
  required String id,
  required String locationId,
  required String name,
  Value<String> type,
  Value<String?> address,
  Value<String?> contact,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});
typedef $$HospitalsTableUpdateCompanionBuilder = HospitalsCompanion Function({
  Value<String> id,
  Value<String> locationId,
  Value<String> name,
  Value<String> type,
  Value<String?> address,
  Value<String?> contact,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});

class $$HospitalsTableFilterComposer
    extends Composer<_$OfflineDatabase, $HospitalsTable> {
  $$HospitalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));
}

class $$HospitalsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $HospitalsTable> {
  $$HospitalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));
}

class $$HospitalsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $HospitalsTable> {
  $$HospitalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$HospitalsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $HospitalsTable,
    Hospital,
    $$HospitalsTableFilterComposer,
    $$HospitalsTableOrderingComposer,
    $$HospitalsTableAnnotationComposer,
    $$HospitalsTableCreateCompanionBuilder,
    $$HospitalsTableUpdateCompanionBuilder,
    (Hospital, BaseReferences<_$OfflineDatabase, $HospitalsTable, Hospital>),
    Hospital,
    PrefetchHooks Function()> {
  $$HospitalsTableTableManager(_$OfflineDatabase db, $HospitalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HospitalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HospitalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HospitalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HospitalsCompanion(
            id: id,
            locationId: locationId,
            name: name,
            type: type,
            address: address,
            contact: contact,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String locationId,
            required String name,
            Value<String> type = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HospitalsCompanion.insert(
            id: id,
            locationId: locationId,
            name: name,
            type: type,
            address: address,
            contact: contact,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HospitalsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $HospitalsTable,
    Hospital,
    $$HospitalsTableFilterComposer,
    $$HospitalsTableOrderingComposer,
    $$HospitalsTableAnnotationComposer,
    $$HospitalsTableCreateCompanionBuilder,
    $$HospitalsTableUpdateCompanionBuilder,
    (Hospital, BaseReferences<_$OfflineDatabase, $HospitalsTable, Hospital>),
    Hospital,
    PrefetchHooks Function()>;
typedef $$DoctorsTableCreateCompanionBuilder = DoctorsCompanion Function({
  required String id,
  required String hospitalId,
  required String name,
  Value<String?> specialty,
  Value<String> chamberDaysJson,
  Value<String?> chamberHours,
  Value<String?> contact,
  Value<int> rowid,
});
typedef $$DoctorsTableUpdateCompanionBuilder = DoctorsCompanion Function({
  Value<String> id,
  Value<String> hospitalId,
  Value<String> name,
  Value<String?> specialty,
  Value<String> chamberDaysJson,
  Value<String?> chamberHours,
  Value<String?> contact,
  Value<int> rowid,
});

class $$DoctorsTableFilterComposer
    extends Composer<_$OfflineDatabase, $DoctorsTable> {
  $$DoctorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hospitalId => $composableBuilder(
      column: $table.hospitalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chamberDaysJson => $composableBuilder(
      column: $table.chamberDaysJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chamberHours => $composableBuilder(
      column: $table.chamberHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnFilters(column));
}

class $$DoctorsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $DoctorsTable> {
  $$DoctorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hospitalId => $composableBuilder(
      column: $table.hospitalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialty => $composableBuilder(
      column: $table.specialty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chamberDaysJson => $composableBuilder(
      column: $table.chamberDaysJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chamberHours => $composableBuilder(
      column: $table.chamberHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contact => $composableBuilder(
      column: $table.contact, builder: (column) => ColumnOrderings(column));
}

class $$DoctorsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $DoctorsTable> {
  $$DoctorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hospitalId => $composableBuilder(
      column: $table.hospitalId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<String> get chamberDaysJson => $composableBuilder(
      column: $table.chamberDaysJson, builder: (column) => column);

  GeneratedColumn<String> get chamberHours => $composableBuilder(
      column: $table.chamberHours, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);
}

class $$DoctorsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $DoctorsTable,
    Doctor,
    $$DoctorsTableFilterComposer,
    $$DoctorsTableOrderingComposer,
    $$DoctorsTableAnnotationComposer,
    $$DoctorsTableCreateCompanionBuilder,
    $$DoctorsTableUpdateCompanionBuilder,
    (Doctor, BaseReferences<_$OfflineDatabase, $DoctorsTable, Doctor>),
    Doctor,
    PrefetchHooks Function()> {
  $$DoctorsTableTableManager(_$OfflineDatabase db, $DoctorsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoctorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoctorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoctorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> hospitalId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> specialty = const Value.absent(),
            Value<String> chamberDaysJson = const Value.absent(),
            Value<String?> chamberHours = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoctorsCompanion(
            id: id,
            hospitalId: hospitalId,
            name: name,
            specialty: specialty,
            chamberDaysJson: chamberDaysJson,
            chamberHours: chamberHours,
            contact: contact,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String hospitalId,
            required String name,
            Value<String?> specialty = const Value.absent(),
            Value<String> chamberDaysJson = const Value.absent(),
            Value<String?> chamberHours = const Value.absent(),
            Value<String?> contact = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DoctorsCompanion.insert(
            id: id,
            hospitalId: hospitalId,
            name: name,
            specialty: specialty,
            chamberDaysJson: chamberDaysJson,
            chamberHours: chamberHours,
            contact: contact,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DoctorsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $DoctorsTable,
    Doctor,
    $$DoctorsTableFilterComposer,
    $$DoctorsTableOrderingComposer,
    $$DoctorsTableAnnotationComposer,
    $$DoctorsTableCreateCompanionBuilder,
    $$DoctorsTableUpdateCompanionBuilder,
    (Doctor, BaseReferences<_$OfflineDatabase, $DoctorsTable, Doctor>),
    Doctor,
    PrefetchHooks Function()>;
typedef $$MarketsTableCreateCompanionBuilder = MarketsCompanion Function({
  required String id,
  required String locationId,
  required String name,
  Value<String> marketDaysJson,
  Value<String?> startTime,
  Value<String?> endTime,
  Value<String?> description,
  Value<String> type,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});
typedef $$MarketsTableUpdateCompanionBuilder = MarketsCompanion Function({
  Value<String> id,
  Value<String> locationId,
  Value<String> name,
  Value<String> marketDaysJson,
  Value<String?> startTime,
  Value<String?> endTime,
  Value<String?> description,
  Value<String> type,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<int> rowid,
});

class $$MarketsTableFilterComposer
    extends Composer<_$OfflineDatabase, $MarketsTable> {
  $$MarketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketDaysJson => $composableBuilder(
      column: $table.marketDaysJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));
}

class $$MarketsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $MarketsTable> {
  $$MarketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketDaysJson => $composableBuilder(
      column: $table.marketDaysJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));
}

class $$MarketsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $MarketsTable> {
  $$MarketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get marketDaysJson => $composableBuilder(
      column: $table.marketDaysJson, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$MarketsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $MarketsTable,
    Market,
    $$MarketsTableFilterComposer,
    $$MarketsTableOrderingComposer,
    $$MarketsTableAnnotationComposer,
    $$MarketsTableCreateCompanionBuilder,
    $$MarketsTableUpdateCompanionBuilder,
    (Market, BaseReferences<_$OfflineDatabase, $MarketsTable, Market>),
    Market,
    PrefetchHooks Function()> {
  $$MarketsTableTableManager(_$OfflineDatabase db, $MarketsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> marketDaysJson = const Value.absent(),
            Value<String?> startTime = const Value.absent(),
            Value<String?> endTime = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketsCompanion(
            id: id,
            locationId: locationId,
            name: name,
            marketDaysJson: marketDaysJson,
            startTime: startTime,
            endTime: endTime,
            description: description,
            type: type,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String locationId,
            required String name,
            Value<String> marketDaysJson = const Value.absent(),
            Value<String?> startTime = const Value.absent(),
            Value<String?> endTime = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MarketsCompanion.insert(
            id: id,
            locationId: locationId,
            name: name,
            marketDaysJson: marketDaysJson,
            startTime: startTime,
            endTime: endTime,
            description: description,
            type: type,
            latitude: latitude,
            longitude: longitude,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarketsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $MarketsTable,
    Market,
    $$MarketsTableFilterComposer,
    $$MarketsTableOrderingComposer,
    $$MarketsTableAnnotationComposer,
    $$MarketsTableCreateCompanionBuilder,
    $$MarketsTableUpdateCompanionBuilder,
    (Market, BaseReferences<_$OfflineDatabase, $MarketsTable, Market>),
    Market,
    PrefetchHooks Function()>;
typedef $$BusinessesTableCreateCompanionBuilder = BusinessesCompanion Function({
  required String id,
  required String locationId,
  required String ownerUserId,
  required String name,
  required String slug,
  required String category,
  Value<String?> description,
  Value<String?> logo,
  Value<String?> coverImage,
  Value<String?> phone,
  Value<String?> address,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> isVerified,
  Value<String> status,
  Value<int> rowid,
});
typedef $$BusinessesTableUpdateCompanionBuilder = BusinessesCompanion Function({
  Value<String> id,
  Value<String> locationId,
  Value<String> ownerUserId,
  Value<String> name,
  Value<String> slug,
  Value<String> category,
  Value<String?> description,
  Value<String?> logo,
  Value<String?> coverImage,
  Value<String?> phone,
  Value<String?> address,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<bool> isVerified,
  Value<String> status,
  Value<int> rowid,
});

class $$BusinessesTableFilterComposer
    extends Composer<_$OfflineDatabase, $BusinessesTable> {
  $$BusinessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$BusinessesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $BusinessesTable> {
  $$BusinessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logo => $composableBuilder(
      column: $table.logo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$BusinessesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $BusinessesTable> {
  $$BusinessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get ownerUserId => $composableBuilder(
      column: $table.ownerUserId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get logo =>
      $composableBuilder(column: $table.logo, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
      column: $table.coverImage, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
      column: $table.isVerified, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$BusinessesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $BusinessesTable,
    BusinessesData,
    $$BusinessesTableFilterComposer,
    $$BusinessesTableOrderingComposer,
    $$BusinessesTableAnnotationComposer,
    $$BusinessesTableCreateCompanionBuilder,
    $$BusinessesTableUpdateCompanionBuilder,
    (
      BusinessesData,
      BaseReferences<_$OfflineDatabase, $BusinessesTable, BusinessesData>
    ),
    BusinessesData,
    PrefetchHooks Function()> {
  $$BusinessesTableTableManager(_$OfflineDatabase db, $BusinessesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> ownerUserId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> logo = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessesCompanion(
            id: id,
            locationId: locationId,
            ownerUserId: ownerUserId,
            name: name,
            slug: slug,
            category: category,
            description: description,
            logo: logo,
            coverImage: coverImage,
            phone: phone,
            address: address,
            latitude: latitude,
            longitude: longitude,
            isVerified: isVerified,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String locationId,
            required String ownerUserId,
            required String name,
            required String slug,
            required String category,
            Value<String?> description = const Value.absent(),
            Value<String?> logo = const Value.absent(),
            Value<String?> coverImage = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<bool> isVerified = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BusinessesCompanion.insert(
            id: id,
            locationId: locationId,
            ownerUserId: ownerUserId,
            name: name,
            slug: slug,
            category: category,
            description: description,
            logo: logo,
            coverImage: coverImage,
            phone: phone,
            address: address,
            latitude: latitude,
            longitude: longitude,
            isVerified: isVerified,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BusinessesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $BusinessesTable,
    BusinessesData,
    $$BusinessesTableFilterComposer,
    $$BusinessesTableOrderingComposer,
    $$BusinessesTableAnnotationComposer,
    $$BusinessesTableCreateCompanionBuilder,
    $$BusinessesTableUpdateCompanionBuilder,
    (
      BusinessesData,
      BaseReferences<_$OfflineDatabase, $BusinessesTable, BusinessesData>
    ),
    BusinessesData,
    PrefetchHooks Function()>;
typedef $$ShopsTableCreateCompanionBuilder = ShopsCompanion Function({
  required String id,
  required String marketId,
  required String marketName,
  required String categoryId,
  required String categoryName,
  required String name,
  Value<String?> description,
  Value<String?> contactPhone,
  Value<String> imagesJson,
  Value<bool> isFeatured,
  Value<String> status,
  Value<String> moderationStatus,
  Value<DateTime?> createdAt,
  required String sellerId,
  required String sellerFullName,
  Value<bool> sellerPhoneVerified,
  Value<int> rowid,
});
typedef $$ShopsTableUpdateCompanionBuilder = ShopsCompanion Function({
  Value<String> id,
  Value<String> marketId,
  Value<String> marketName,
  Value<String> categoryId,
  Value<String> categoryName,
  Value<String> name,
  Value<String?> description,
  Value<String?> contactPhone,
  Value<String> imagesJson,
  Value<bool> isFeatured,
  Value<String> status,
  Value<String> moderationStatus,
  Value<DateTime?> createdAt,
  Value<String> sellerId,
  Value<String> sellerFullName,
  Value<bool> sellerPhoneVerified,
  Value<int> rowid,
});

class $$ShopsTableFilterComposer
    extends Composer<_$OfflineDatabase, $ShopsTable> {
  $$ShopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketId => $composableBuilder(
      column: $table.marketId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get marketName => $composableBuilder(
      column: $table.marketName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get moderationStatus => $composableBuilder(
      column: $table.moderationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sellerId => $composableBuilder(
      column: $table.sellerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sellerFullName => $composableBuilder(
      column: $table.sellerFullName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sellerPhoneVerified => $composableBuilder(
      column: $table.sellerPhoneVerified,
      builder: (column) => ColumnFilters(column));
}

class $$ShopsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $ShopsTable> {
  $$ShopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketId => $composableBuilder(
      column: $table.marketId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get marketName => $composableBuilder(
      column: $table.marketName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName => $composableBuilder(
      column: $table.categoryName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get moderationStatus => $composableBuilder(
      column: $table.moderationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sellerId => $composableBuilder(
      column: $table.sellerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sellerFullName => $composableBuilder(
      column: $table.sellerFullName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sellerPhoneVerified => $composableBuilder(
      column: $table.sellerPhoneVerified,
      builder: (column) => ColumnOrderings(column));
}

class $$ShopsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $ShopsTable> {
  $$ShopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get marketId =>
      $composableBuilder(column: $table.marketId, builder: (column) => column);

  GeneratedColumn<String> get marketName => $composableBuilder(
      column: $table.marketName, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName => $composableBuilder(
      column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get contactPhone => $composableBuilder(
      column: $table.contactPhone, builder: (column) => column);

  GeneratedColumn<String> get imagesJson => $composableBuilder(
      column: $table.imagesJson, builder: (column) => column);

  GeneratedColumn<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get moderationStatus => $composableBuilder(
      column: $table.moderationStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get sellerId =>
      $composableBuilder(column: $table.sellerId, builder: (column) => column);

  GeneratedColumn<String> get sellerFullName => $composableBuilder(
      column: $table.sellerFullName, builder: (column) => column);

  GeneratedColumn<bool> get sellerPhoneVerified => $composableBuilder(
      column: $table.sellerPhoneVerified, builder: (column) => column);
}

class $$ShopsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $ShopsTable,
    Shop,
    $$ShopsTableFilterComposer,
    $$ShopsTableOrderingComposer,
    $$ShopsTableAnnotationComposer,
    $$ShopsTableCreateCompanionBuilder,
    $$ShopsTableUpdateCompanionBuilder,
    (Shop, BaseReferences<_$OfflineDatabase, $ShopsTable, Shop>),
    Shop,
    PrefetchHooks Function()> {
  $$ShopsTableTableManager(_$OfflineDatabase db, $ShopsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> marketId = const Value.absent(),
            Value<String> marketName = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> categoryName = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String> imagesJson = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> moderationStatus = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<String> sellerId = const Value.absent(),
            Value<String> sellerFullName = const Value.absent(),
            Value<bool> sellerPhoneVerified = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopsCompanion(
            id: id,
            marketId: marketId,
            marketName: marketName,
            categoryId: categoryId,
            categoryName: categoryName,
            name: name,
            description: description,
            contactPhone: contactPhone,
            imagesJson: imagesJson,
            isFeatured: isFeatured,
            status: status,
            moderationStatus: moderationStatus,
            createdAt: createdAt,
            sellerId: sellerId,
            sellerFullName: sellerFullName,
            sellerPhoneVerified: sellerPhoneVerified,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String marketId,
            required String marketName,
            required String categoryId,
            required String categoryName,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> contactPhone = const Value.absent(),
            Value<String> imagesJson = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> moderationStatus = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            required String sellerId,
            required String sellerFullName,
            Value<bool> sellerPhoneVerified = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopsCompanion.insert(
            id: id,
            marketId: marketId,
            marketName: marketName,
            categoryId: categoryId,
            categoryName: categoryName,
            name: name,
            description: description,
            contactPhone: contactPhone,
            imagesJson: imagesJson,
            isFeatured: isFeatured,
            status: status,
            moderationStatus: moderationStatus,
            createdAt: createdAt,
            sellerId: sellerId,
            sellerFullName: sellerFullName,
            sellerPhoneVerified: sellerPhoneVerified,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShopsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $ShopsTable,
    Shop,
    $$ShopsTableFilterComposer,
    $$ShopsTableOrderingComposer,
    $$ShopsTableAnnotationComposer,
    $$ShopsTableCreateCompanionBuilder,
    $$ShopsTableUpdateCompanionBuilder,
    (Shop, BaseReferences<_$OfflineDatabase, $ShopsTable, Shop>),
    Shop,
    PrefetchHooks Function()>;
typedef $$ShopCategoriesTableCreateCompanionBuilder = ShopCategoriesCompanion
    Function({
  required String id,
  required String name,
  required String slug,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$ShopCategoriesTableUpdateCompanionBuilder = ShopCategoriesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> slug,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$ShopCategoriesTableFilterComposer
    extends Composer<_$OfflineDatabase, $ShopCategoriesTable> {
  $$ShopCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));
}

class $$ShopCategoriesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $ShopCategoriesTable> {
  $$ShopCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));
}

class $$ShopCategoriesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $ShopCategoriesTable> {
  $$ShopCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ShopCategoriesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $ShopCategoriesTable,
    ShopCategory,
    $$ShopCategoriesTableFilterComposer,
    $$ShopCategoriesTableOrderingComposer,
    $$ShopCategoriesTableAnnotationComposer,
    $$ShopCategoriesTableCreateCompanionBuilder,
    $$ShopCategoriesTableUpdateCompanionBuilder,
    (
      ShopCategory,
      BaseReferences<_$OfflineDatabase, $ShopCategoriesTable, ShopCategory>
    ),
    ShopCategory,
    PrefetchHooks Function()> {
  $$ShopCategoriesTableTableManager(
      _$OfflineDatabase db, $ShopCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopCategoriesCompanion(
            id: id,
            name: name,
            slug: slug,
            icon: icon,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String slug,
            Value<String?> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ShopCategoriesCompanion.insert(
            id: id,
            name: name,
            slug: slug,
            icon: icon,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShopCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $ShopCategoriesTable,
    ShopCategory,
    $$ShopCategoriesTableFilterComposer,
    $$ShopCategoriesTableOrderingComposer,
    $$ShopCategoriesTableAnnotationComposer,
    $$ShopCategoriesTableCreateCompanionBuilder,
    $$ShopCategoriesTableUpdateCompanionBuilder,
    (
      ShopCategory,
      BaseReferences<_$OfflineDatabase, $ShopCategoriesTable, ShopCategory>
    ),
    ShopCategory,
    PrefetchHooks Function()>;
typedef $$RepresentativesTableCreateCompanionBuilder = RepresentativesCompanion
    Function({
  required String id,
  required String userId,
  required String fullName,
  Value<String?> phone,
  required String locationId,
  required String locationName,
  Value<String> position,
  Value<String?> bio,
  Value<String?> photoUrl,
  Value<String> status,
  Value<int> rowid,
});
typedef $$RepresentativesTableUpdateCompanionBuilder = RepresentativesCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> fullName,
  Value<String?> phone,
  Value<String> locationId,
  Value<String> locationName,
  Value<String> position,
  Value<String?> bio,
  Value<String?> photoUrl,
  Value<String> status,
  Value<int> rowid,
});

class $$RepresentativesTableFilterComposer
    extends Composer<_$OfflineDatabase, $RepresentativesTable> {
  $$RepresentativesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$RepresentativesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $RepresentativesTable> {
  $$RepresentativesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bio => $composableBuilder(
      column: $table.bio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$RepresentativesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $RepresentativesTable> {
  $$RepresentativesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<String> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get bio =>
      $composableBuilder(column: $table.bio, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$RepresentativesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $RepresentativesTable,
    Representative,
    $$RepresentativesTableFilterComposer,
    $$RepresentativesTableOrderingComposer,
    $$RepresentativesTableAnnotationComposer,
    $$RepresentativesTableCreateCompanionBuilder,
    $$RepresentativesTableUpdateCompanionBuilder,
    (
      Representative,
      BaseReferences<_$OfflineDatabase, $RepresentativesTable, Representative>
    ),
    Representative,
    PrefetchHooks Function()> {
  $$RepresentativesTableTableManager(
      _$OfflineDatabase db, $RepresentativesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RepresentativesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RepresentativesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RepresentativesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> fullName = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> locationName = const Value.absent(),
            Value<String> position = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RepresentativesCompanion(
            id: id,
            userId: userId,
            fullName: fullName,
            phone: phone,
            locationId: locationId,
            locationName: locationName,
            position: position,
            bio: bio,
            photoUrl: photoUrl,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String fullName,
            Value<String?> phone = const Value.absent(),
            required String locationId,
            required String locationName,
            Value<String> position = const Value.absent(),
            Value<String?> bio = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RepresentativesCompanion.insert(
            id: id,
            userId: userId,
            fullName: fullName,
            phone: phone,
            locationId: locationId,
            locationName: locationName,
            position: position,
            bio: bio,
            photoUrl: photoUrl,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RepresentativesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $RepresentativesTable,
    Representative,
    $$RepresentativesTableFilterComposer,
    $$RepresentativesTableOrderingComposer,
    $$RepresentativesTableAnnotationComposer,
    $$RepresentativesTableCreateCompanionBuilder,
    $$RepresentativesTableUpdateCompanionBuilder,
    (
      Representative,
      BaseReferences<_$OfflineDatabase, $RepresentativesTable, Representative>
    ),
    Representative,
    PrefetchHooks Function()>;
typedef $$NewsArticlesTableCreateCompanionBuilder = NewsArticlesCompanion
    Function({
  required String id,
  required String sourceId,
  Value<String?> locationId,
  Value<String?> category,
  required String title,
  required String slug,
  Value<String?> summary,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<String> status,
  Value<String?> body,
  Value<String?> originalUrl,
  Value<int> rowid,
});
typedef $$NewsArticlesTableUpdateCompanionBuilder = NewsArticlesCompanion
    Function({
  Value<String> id,
  Value<String> sourceId,
  Value<String?> locationId,
  Value<String?> category,
  Value<String> title,
  Value<String> slug,
  Value<String?> summary,
  Value<String?> image,
  Value<DateTime?> publishedAt,
  Value<String> status,
  Value<String?> body,
  Value<String?> originalUrl,
  Value<int> rowid,
});

class $$NewsArticlesTableFilterComposer
    extends Composer<_$OfflineDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get originalUrl => $composableBuilder(
      column: $table.originalUrl, builder: (column) => ColumnFilters(column));
}

class $$NewsArticlesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slug => $composableBuilder(
      column: $table.slug, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get originalUrl => $composableBuilder(
      column: $table.originalUrl, builder: (column) => ColumnOrderings(column));
}

class $$NewsArticlesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $NewsArticlesTable> {
  $$NewsArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get originalUrl => $composableBuilder(
      column: $table.originalUrl, builder: (column) => column);
}

class $$NewsArticlesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $NewsArticlesTable,
    NewsArticle,
    $$NewsArticlesTableFilterComposer,
    $$NewsArticlesTableOrderingComposer,
    $$NewsArticlesTableAnnotationComposer,
    $$NewsArticlesTableCreateCompanionBuilder,
    $$NewsArticlesTableUpdateCompanionBuilder,
    (
      NewsArticle,
      BaseReferences<_$OfflineDatabase, $NewsArticlesTable, NewsArticle>
    ),
    NewsArticle,
    PrefetchHooks Function()> {
  $$NewsArticlesTableTableManager(
      _$OfflineDatabase db, $NewsArticlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NewsArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NewsArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NewsArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> slug = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> originalUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NewsArticlesCompanion(
            id: id,
            sourceId: sourceId,
            locationId: locationId,
            category: category,
            title: title,
            slug: slug,
            summary: summary,
            image: image,
            publishedAt: publishedAt,
            status: status,
            body: body,
            originalUrl: originalUrl,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceId,
            Value<String?> locationId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required String title,
            required String slug,
            Value<String?> summary = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<DateTime?> publishedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> body = const Value.absent(),
            Value<String?> originalUrl = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NewsArticlesCompanion.insert(
            id: id,
            sourceId: sourceId,
            locationId: locationId,
            category: category,
            title: title,
            slug: slug,
            summary: summary,
            image: image,
            publishedAt: publishedAt,
            status: status,
            body: body,
            originalUrl: originalUrl,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NewsArticlesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $NewsArticlesTable,
    NewsArticle,
    $$NewsArticlesTableFilterComposer,
    $$NewsArticlesTableOrderingComposer,
    $$NewsArticlesTableAnnotationComposer,
    $$NewsArticlesTableCreateCompanionBuilder,
    $$NewsArticlesTableUpdateCompanionBuilder,
    (
      NewsArticle,
      BaseReferences<_$OfflineDatabase, $NewsArticlesTable, NewsArticle>
    ),
    NewsArticle,
    PrefetchHooks Function()>;
typedef $$ServicesTableCreateCompanionBuilder = ServicesCompanion Function({
  required String id,
  required String locationId,
  required String categoryId,
  required String name,
  Value<String?> description,
  Value<String?> eligibility,
  Value<String> requiredDocumentsJson,
  Value<double?> fee,
  Value<String?> officialLink,
  Value<String?> officeName,
  Value<String?> officeContact,
  Value<String> status,
  Value<int> rowid,
});
typedef $$ServicesTableUpdateCompanionBuilder = ServicesCompanion Function({
  Value<String> id,
  Value<String> locationId,
  Value<String> categoryId,
  Value<String> name,
  Value<String?> description,
  Value<String?> eligibility,
  Value<String> requiredDocumentsJson,
  Value<double?> fee,
  Value<String?> officialLink,
  Value<String?> officeName,
  Value<String?> officeContact,
  Value<String> status,
  Value<int> rowid,
});

class $$ServicesTableFilterComposer
    extends Composer<_$OfflineDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eligibility => $composableBuilder(
      column: $table.eligibility, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get requiredDocumentsJson => $composableBuilder(
      column: $table.requiredDocumentsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officialLink => $composableBuilder(
      column: $table.officialLink, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officeName => $composableBuilder(
      column: $table.officeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officeContact => $composableBuilder(
      column: $table.officeContact, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$ServicesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eligibility => $composableBuilder(
      column: $table.eligibility, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get requiredDocumentsJson => $composableBuilder(
      column: $table.requiredDocumentsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fee => $composableBuilder(
      column: $table.fee, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officialLink => $composableBuilder(
      column: $table.officialLink,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officeName => $composableBuilder(
      column: $table.officeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officeContact => $composableBuilder(
      column: $table.officeContact,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get eligibility => $composableBuilder(
      column: $table.eligibility, builder: (column) => column);

  GeneratedColumn<String> get requiredDocumentsJson => $composableBuilder(
      column: $table.requiredDocumentsJson, builder: (column) => column);

  GeneratedColumn<double> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<String> get officialLink => $composableBuilder(
      column: $table.officialLink, builder: (column) => column);

  GeneratedColumn<String> get officeName => $composableBuilder(
      column: $table.officeName, builder: (column) => column);

  GeneratedColumn<String> get officeContact => $composableBuilder(
      column: $table.officeContact, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$ServicesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, BaseReferences<_$OfflineDatabase, $ServicesTable, Service>),
    Service,
    PrefetchHooks Function()> {
  $$ServicesTableTableManager(_$OfflineDatabase db, $ServicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> locationId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> eligibility = const Value.absent(),
            Value<String> requiredDocumentsJson = const Value.absent(),
            Value<double?> fee = const Value.absent(),
            Value<String?> officialLink = const Value.absent(),
            Value<String?> officeName = const Value.absent(),
            Value<String?> officeContact = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicesCompanion(
            id: id,
            locationId: locationId,
            categoryId: categoryId,
            name: name,
            description: description,
            eligibility: eligibility,
            requiredDocumentsJson: requiredDocumentsJson,
            fee: fee,
            officialLink: officialLink,
            officeName: officeName,
            officeContact: officeContact,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String locationId,
            required String categoryId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> eligibility = const Value.absent(),
            Value<String> requiredDocumentsJson = const Value.absent(),
            Value<double?> fee = const Value.absent(),
            Value<String?> officialLink = const Value.absent(),
            Value<String?> officeName = const Value.absent(),
            Value<String?> officeContact = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServicesCompanion.insert(
            id: id,
            locationId: locationId,
            categoryId: categoryId,
            name: name,
            description: description,
            eligibility: eligibility,
            requiredDocumentsJson: requiredDocumentsJson,
            fee: fee,
            officialLink: officialLink,
            officeName: officeName,
            officeContact: officeContact,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServicesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $ServicesTable,
    Service,
    $$ServicesTableFilterComposer,
    $$ServicesTableOrderingComposer,
    $$ServicesTableAnnotationComposer,
    $$ServicesTableCreateCompanionBuilder,
    $$ServicesTableUpdateCompanionBuilder,
    (Service, BaseReferences<_$OfflineDatabase, $ServicesTable, Service>),
    Service,
    PrefetchHooks Function()>;
typedef $$ServiceCategoriesTableCreateCompanionBuilder
    = ServiceCategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> parentId,
  Value<int> rowid,
});
typedef $$ServiceCategoriesTableUpdateCompanionBuilder
    = ServiceCategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<int> rowid,
});

class $$ServiceCategoriesTableFilterComposer
    extends Composer<_$OfflineDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));
}

class $$ServiceCategoriesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));
}

class $$ServiceCategoriesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);
}

class $$ServiceCategoriesTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $ServiceCategoriesTable,
    ServiceCategory,
    $$ServiceCategoriesTableFilterComposer,
    $$ServiceCategoriesTableOrderingComposer,
    $$ServiceCategoriesTableAnnotationComposer,
    $$ServiceCategoriesTableCreateCompanionBuilder,
    $$ServiceCategoriesTableUpdateCompanionBuilder,
    (
      ServiceCategory,
      BaseReferences<_$OfflineDatabase, $ServiceCategoriesTable,
          ServiceCategory>
    ),
    ServiceCategory,
    PrefetchHooks Function()> {
  $$ServiceCategoriesTableTableManager(
      _$OfflineDatabase db, $ServiceCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceCategoriesCompanion(
            id: id,
            name: name,
            parentId: parentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> parentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ServiceCategoriesCompanion.insert(
            id: id,
            name: name,
            parentId: parentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServiceCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $ServiceCategoriesTable,
    ServiceCategory,
    $$ServiceCategoriesTableFilterComposer,
    $$ServiceCategoriesTableOrderingComposer,
    $$ServiceCategoriesTableAnnotationComposer,
    $$ServiceCategoriesTableCreateCompanionBuilder,
    $$ServiceCategoriesTableUpdateCompanionBuilder,
    (
      ServiceCategory,
      BaseReferences<_$OfflineDatabase, $ServiceCategoriesTable,
          ServiceCategory>
    ),
    ServiceCategory,
    PrefetchHooks Function()>;
typedef $$LocationsTableCreateCompanionBuilder = LocationsCompanion Function({
  required String id,
  required String type,
  required String name,
  Value<String?> parentId,
  Value<int> rowid,
});
typedef $$LocationsTableUpdateCompanionBuilder = LocationsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> name,
  Value<String?> parentId,
  Value<int> rowid,
});

class $$LocationsTableFilterComposer
    extends Composer<_$OfflineDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));
}

class $$LocationsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);
}

class $$LocationsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $LocationsTable,
    Location,
    $$LocationsTableFilterComposer,
    $$LocationsTableOrderingComposer,
    $$LocationsTableAnnotationComposer,
    $$LocationsTableCreateCompanionBuilder,
    $$LocationsTableUpdateCompanionBuilder,
    (Location, BaseReferences<_$OfflineDatabase, $LocationsTable, Location>),
    Location,
    PrefetchHooks Function()> {
  $$LocationsTableTableManager(_$OfflineDatabase db, $LocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsCompanion(
            id: id,
            type: type,
            name: name,
            parentId: parentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String name,
            Value<String?> parentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocationsCompanion.insert(
            id: id,
            type: type,
            name: name,
            parentId: parentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocationsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $LocationsTable,
    Location,
    $$LocationsTableFilterComposer,
    $$LocationsTableOrderingComposer,
    $$LocationsTableAnnotationComposer,
    $$LocationsTableCreateCompanionBuilder,
    $$LocationsTableUpdateCompanionBuilder,
    (Location, BaseReferences<_$OfflineDatabase, $LocationsTable, Location>),
    Location,
    PrefetchHooks Function()>;
typedef $$FaqsTableCreateCompanionBuilder = FaqsCompanion Function({
  required String id,
  required String question,
  required String answer,
  Value<String> status,
  Value<int> rowid,
});
typedef $$FaqsTableUpdateCompanionBuilder = FaqsCompanion Function({
  Value<String> id,
  Value<String> question,
  Value<String> answer,
  Value<String> status,
  Value<int> rowid,
});

class $$FaqsTableFilterComposer
    extends Composer<_$OfflineDatabase, $FaqsTable> {
  $$FaqsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$FaqsTableOrderingComposer
    extends Composer<_$OfflineDatabase, $FaqsTable> {
  $$FaqsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get answer => $composableBuilder(
      column: $table.answer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$FaqsTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $FaqsTable> {
  $$FaqsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$FaqsTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $FaqsTable,
    Faq,
    $$FaqsTableFilterComposer,
    $$FaqsTableOrderingComposer,
    $$FaqsTableAnnotationComposer,
    $$FaqsTableCreateCompanionBuilder,
    $$FaqsTableUpdateCompanionBuilder,
    (Faq, BaseReferences<_$OfflineDatabase, $FaqsTable, Faq>),
    Faq,
    PrefetchHooks Function()> {
  $$FaqsTableTableManager(_$OfflineDatabase db, $FaqsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FaqsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FaqsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FaqsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> question = const Value.absent(),
            Value<String> answer = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FaqsCompanion(
            id: id,
            question: question,
            answer: answer,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String question,
            required String answer,
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FaqsCompanion.insert(
            id: id,
            question: question,
            answer: answer,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FaqsTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $FaqsTable,
    Faq,
    $$FaqsTableFilterComposer,
    $$FaqsTableOrderingComposer,
    $$FaqsTableAnnotationComposer,
    $$FaqsTableCreateCompanionBuilder,
    $$FaqsTableUpdateCompanionBuilder,
    (Faq, BaseReferences<_$OfflineDatabase, $FaqsTable, Faq>),
    Faq,
    PrefetchHooks Function()>;
typedef $$SyncMetaTableCreateCompanionBuilder = SyncMetaCompanion Function({
  required String entity,
  required DateTime lastSyncedAt,
  Value<int> rowid,
});
typedef $$SyncMetaTableUpdateCompanionBuilder = SyncMetaCompanion Function({
  Value<String> entity,
  Value<DateTime> lastSyncedAt,
  Value<int> rowid,
});

class $$SyncMetaTableFilterComposer
    extends Composer<_$OfflineDatabase, $SyncMetaTable> {
  $$SyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncMetaTableOrderingComposer
    extends Composer<_$OfflineDatabase, $SyncMetaTable> {
  $$SyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncMetaTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $SyncMetaTable> {
  $$SyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);
}

class $$SyncMetaTableTableManager extends RootTableManager<
    _$OfflineDatabase,
    $SyncMetaTable,
    SyncMetaData,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (
      SyncMetaData,
      BaseReferences<_$OfflineDatabase, $SyncMetaTable, SyncMetaData>
    ),
    SyncMetaData,
    PrefetchHooks Function()> {
  $$SyncMetaTableTableManager(_$OfflineDatabase db, $SyncMetaTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entity = const Value.absent(),
            Value<DateTime> lastSyncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion(
            entity: entity,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entity,
            required DateTime lastSyncedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncMetaCompanion.insert(
            entity: entity,
            lastSyncedAt: lastSyncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncMetaTableProcessedTableManager = ProcessedTableManager<
    _$OfflineDatabase,
    $SyncMetaTable,
    SyncMetaData,
    $$SyncMetaTableFilterComposer,
    $$SyncMetaTableOrderingComposer,
    $$SyncMetaTableAnnotationComposer,
    $$SyncMetaTableCreateCompanionBuilder,
    $$SyncMetaTableUpdateCompanionBuilder,
    (
      SyncMetaData,
      BaseReferences<_$OfflineDatabase, $SyncMetaTable, SyncMetaData>
    ),
    SyncMetaData,
    PrefetchHooks Function()>;

class $OfflineDatabaseManager {
  final _$OfflineDatabase _db;
  $OfflineDatabaseManager(this._db);
  $$PlacesTableTableManager get places =>
      $$PlacesTableTableManager(_db, _db.places);
  $$HospitalsTableTableManager get hospitals =>
      $$HospitalsTableTableManager(_db, _db.hospitals);
  $$DoctorsTableTableManager get doctors =>
      $$DoctorsTableTableManager(_db, _db.doctors);
  $$MarketsTableTableManager get markets =>
      $$MarketsTableTableManager(_db, _db.markets);
  $$BusinessesTableTableManager get businesses =>
      $$BusinessesTableTableManager(_db, _db.businesses);
  $$ShopsTableTableManager get shops =>
      $$ShopsTableTableManager(_db, _db.shops);
  $$ShopCategoriesTableTableManager get shopCategories =>
      $$ShopCategoriesTableTableManager(_db, _db.shopCategories);
  $$RepresentativesTableTableManager get representatives =>
      $$RepresentativesTableTableManager(_db, _db.representatives);
  $$NewsArticlesTableTableManager get newsArticles =>
      $$NewsArticlesTableTableManager(_db, _db.newsArticles);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$ServiceCategoriesTableTableManager get serviceCategories =>
      $$ServiceCategoriesTableTableManager(_db, _db.serviceCategories);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$FaqsTableTableManager get faqs => $$FaqsTableTableManager(_db, _db.faqs);
  $$SyncMetaTableTableManager get syncMeta =>
      $$SyncMetaTableTableManager(_db, _db.syncMeta);
}
