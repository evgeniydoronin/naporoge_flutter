// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNPStreamCollection on Isar {
  IsarCollection<NPStream> get nPStreams => this.collection();
}

const NPStreamSchema = CollectionSchema(
  name: r'NPStream',
  id: -1021827610071583135,
  properties: {
    r'courseId': PropertySchema(
      id: 0,
      name: r'courseId',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'startAt': PropertySchema(
      id: 3,
      name: r'startAt',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 4,
      name: r'title',
      type: IsarType.string,
    ),
    r'weeks': PropertySchema(
      id: 5,
      name: r'weeks',
      type: IsarType.long,
    )
  },
  estimateSize: _nPStreamEstimateSize,
  serialize: _nPStreamSerialize,
  deserialize: _nPStreamDeserialize,
  deserializeProp: _nPStreamDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'weekBacklink': LinkSchema(
      id: -4874763026407370566,
      name: r'weekBacklink',
      target: r'Week',
      single: false,
      linkName: r'nPStream',
    ),
    r'twoTargetBacklink': LinkSchema(
      id: -3308154685408856500,
      name: r'twoTargetBacklink',
      target: r'TwoTarget',
      single: false,
      linkName: r'nPStream',
    )
  },
  embeddedSchemas: {},
  getId: _nPStreamGetId,
  getLinks: _nPStreamGetLinks,
  attach: _nPStreamAttach,
  version: '3.1.0+1',
);

int _nPStreamEstimateSize(
  NPStream object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.courseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _nPStreamSerialize(
  NPStream object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.courseId);
  writer.writeString(offsets[1], object.description);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeDateTime(offsets[3], object.startAt);
  writer.writeString(offsets[4], object.title);
  writer.writeLong(offsets[5], object.weeks);
}

NPStream _nPStreamDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NPStream();
  object.courseId = reader.readStringOrNull(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isActive = reader.readBoolOrNull(offsets[2]);
  object.startAt = reader.readDateTimeOrNull(offsets[3]);
  object.title = reader.readStringOrNull(offsets[4]);
  object.weeks = reader.readLongOrNull(offsets[5]);
  return object;
}

P _nPStreamDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nPStreamGetId(NPStream object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _nPStreamGetLinks(NPStream object) {
  return [object.weekBacklink, object.twoTargetBacklink];
}

void _nPStreamAttach(IsarCollection<dynamic> col, Id id, NPStream object) {
  object.id = id;
  object.weekBacklink
      .attach(col, col.isar.collection<Week>(), r'weekBacklink', id);
  object.twoTargetBacklink
      .attach(col, col.isar.collection<TwoTarget>(), r'twoTargetBacklink', id);
}

extension NPStreamQueryWhereSort on QueryBuilder<NPStream, NPStream, QWhere> {
  QueryBuilder<NPStream, NPStream, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NPStreamQueryWhere on QueryBuilder<NPStream, NPStream, QWhereClause> {
  QueryBuilder<NPStream, NPStream, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NPStreamQueryFilter
    on QueryBuilder<NPStream, NPStream, QFilterCondition> {
  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'courseId',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'courseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'courseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'courseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> courseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'courseId',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> isActiveIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> isActiveIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isActive',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> isActiveEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startAt',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startAt',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> startAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weeks',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weeks',
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weeks',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weeks',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weeks',
        value: value,
      ));
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weeksBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weeks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NPStreamQueryObject
    on QueryBuilder<NPStream, NPStream, QFilterCondition> {}

extension NPStreamQueryLinks
    on QueryBuilder<NPStream, NPStream, QFilterCondition> {
  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> weekBacklink(
      FilterQuery<Week> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'weekBacklink');
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'weekBacklink', length, true, length, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'weekBacklink', 0, true, 0, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'weekBacklink', 0, false, 999999, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'weekBacklink', 0, true, length, include);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'weekBacklink', length, include, 999999, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      weekBacklinkLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'weekBacklink', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition> twoTargetBacklink(
      FilterQuery<TwoTarget> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'twoTargetBacklink');
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'twoTargetBacklink', length, true, length, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'twoTargetBacklink', 0, true, 0, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'twoTargetBacklink', 0, false, 999999, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'twoTargetBacklink', 0, true, length, include);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'twoTargetBacklink', length, include, 999999, true);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterFilterCondition>
      twoTargetBacklinkLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'twoTargetBacklink', lower, includeLower, upper, includeUpper);
    });
  }
}

extension NPStreamQuerySortBy on QueryBuilder<NPStream, NPStream, QSortBy> {
  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeks', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> sortByWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeks', Sort.desc);
    });
  }
}

extension NPStreamQuerySortThenBy
    on QueryBuilder<NPStream, NPStream, QSortThenBy> {
  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByCourseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByCourseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'courseId', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeks', Sort.asc);
    });
  }

  QueryBuilder<NPStream, NPStream, QAfterSortBy> thenByWeeksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeks', Sort.desc);
    });
  }
}

extension NPStreamQueryWhereDistinct
    on QueryBuilder<NPStream, NPStream, QDistinct> {
  QueryBuilder<NPStream, NPStream, QDistinct> distinctByCourseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'courseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NPStream, NPStream, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NPStream, NPStream, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<NPStream, NPStream, QDistinct> distinctByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startAt');
    });
  }

  QueryBuilder<NPStream, NPStream, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NPStream, NPStream, QDistinct> distinctByWeeks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeks');
    });
  }
}

extension NPStreamQueryProperty
    on QueryBuilder<NPStream, NPStream, QQueryProperty> {
  QueryBuilder<NPStream, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NPStream, String?, QQueryOperations> courseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'courseId');
    });
  }

  QueryBuilder<NPStream, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<NPStream, bool?, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<NPStream, DateTime?, QQueryOperations> startAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startAt');
    });
  }

  QueryBuilder<NPStream, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<NPStream, int?, QQueryOperations> weeksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeks');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeekCollection on Isar {
  IsarCollection<Week> get weeks => this.collection();
}

const WeekSchema = CollectionSchema(
  name: r'Week',
  id: 5019936486844116432,
  properties: {
    r'cells': PropertySchema(
      id: 0,
      name: r'cells',
      type: IsarType.string,
    ),
    r'monday': PropertySchema(
      id: 1,
      name: r'monday',
      type: IsarType.dateTime,
    ),
    r'progress': PropertySchema(
      id: 2,
      name: r'progress',
      type: IsarType.string,
    ),
    r'streamId': PropertySchema(
      id: 3,
      name: r'streamId',
      type: IsarType.long,
    ),
    r'systemConfirmed': PropertySchema(
      id: 4,
      name: r'systemConfirmed',
      type: IsarType.bool,
    ),
    r'userConfirmed': PropertySchema(
      id: 5,
      name: r'userConfirmed',
      type: IsarType.bool,
    ),
    r'weekNumber': PropertySchema(
      id: 6,
      name: r'weekNumber',
      type: IsarType.long,
    ),
    r'weekYear': PropertySchema(
      id: 7,
      name: r'weekYear',
      type: IsarType.long,
    )
  },
  estimateSize: _weekEstimateSize,
  serialize: _weekSerialize,
  deserialize: _weekDeserialize,
  deserializeProp: _weekDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'nPStream': LinkSchema(
      id: 8719935159304474915,
      name: r'nPStream',
      target: r'NPStream',
      single: true,
    ),
    r'dayBacklink': LinkSchema(
      id: -1836743648546559774,
      name: r'dayBacklink',
      target: r'Day',
      single: false,
      linkName: r'week',
    )
  },
  embeddedSchemas: {},
  getId: _weekGetId,
  getLinks: _weekGetLinks,
  attach: _weekAttach,
  version: '3.1.0+1',
);

int _weekEstimateSize(
  Week object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cells;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.progress;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _weekSerialize(
  Week object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cells);
  writer.writeDateTime(offsets[1], object.monday);
  writer.writeString(offsets[2], object.progress);
  writer.writeLong(offsets[3], object.streamId);
  writer.writeBool(offsets[4], object.systemConfirmed);
  writer.writeBool(offsets[5], object.userConfirmed);
  writer.writeLong(offsets[6], object.weekNumber);
  writer.writeLong(offsets[7], object.weekYear);
}

Week _weekDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Week();
  object.cells = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.monday = reader.readDateTimeOrNull(offsets[1]);
  object.progress = reader.readStringOrNull(offsets[2]);
  object.streamId = reader.readLongOrNull(offsets[3]);
  object.systemConfirmed = reader.readBoolOrNull(offsets[4]);
  object.userConfirmed = reader.readBoolOrNull(offsets[5]);
  object.weekNumber = reader.readLongOrNull(offsets[6]);
  object.weekYear = reader.readLongOrNull(offsets[7]);
  return object;
}

P _weekDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset)) as P;
    case 5:
      return (reader.readBoolOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weekGetId(Week object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _weekGetLinks(Week object) {
  return [object.nPStream, object.dayBacklink];
}

void _weekAttach(IsarCollection<dynamic> col, Id id, Week object) {
  object.id = id;
  object.nPStream.attach(col, col.isar.collection<NPStream>(), r'nPStream', id);
  object.dayBacklink
      .attach(col, col.isar.collection<Day>(), r'dayBacklink', id);
}

extension WeekQueryWhereSort on QueryBuilder<Week, Week, QWhere> {
  QueryBuilder<Week, Week, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeekQueryWhere on QueryBuilder<Week, Week, QWhereClause> {
  QueryBuilder<Week, Week, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Week, Week, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Week, Week, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Week, Week, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeekQueryFilter on QueryBuilder<Week, Week, QFilterCondition> {
  QueryBuilder<Week, Week, QAfterFilterCondition> cellsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cells',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cells',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cells',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cells',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cells',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cells',
        value: '',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> cellsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cells',
        value: '',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'monday',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'monday',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'monday',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'monday',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'monday',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> mondayBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'monday',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'progress',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'progress',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'progress',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: '',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> progressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'progress',
        value: '',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'streamId',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'streamId',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> streamIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streamId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> systemConfirmedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'systemConfirmed',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> systemConfirmedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'systemConfirmed',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> systemConfirmedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'systemConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> userConfirmedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userConfirmed',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> userConfirmedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userConfirmed',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> userConfirmedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userConfirmed',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekNumber',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekNumber',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekYear',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekYear',
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekYear',
        value: value,
      ));
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> weekYearBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekYear',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeekQueryObject on QueryBuilder<Week, Week, QFilterCondition> {}

extension WeekQueryLinks on QueryBuilder<Week, Week, QFilterCondition> {
  QueryBuilder<Week, Week, QAfterFilterCondition> nPStream(
      FilterQuery<NPStream> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'nPStream');
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> nPStreamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'nPStream', 0, true, 0, true);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklink(
      FilterQuery<Day> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'dayBacklink');
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayBacklink', length, true, length, true);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayBacklink', 0, true, 0, true);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayBacklink', 0, false, 999999, true);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayBacklink', 0, true, length, include);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayBacklink', length, include, 999999, true);
    });
  }

  QueryBuilder<Week, Week, QAfterFilterCondition> dayBacklinkLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'dayBacklink', lower, includeLower, upper, includeUpper);
    });
  }
}

extension WeekQuerySortBy on QueryBuilder<Week, Week, QSortBy> {
  QueryBuilder<Week, Week, QAfterSortBy> sortByCells() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cells', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByCellsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cells', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByMonday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monday', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByMondayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monday', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortBySystemConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortBySystemConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByUserConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByWeekYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekYear', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> sortByWeekYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekYear', Sort.desc);
    });
  }
}

extension WeekQuerySortThenBy on QueryBuilder<Week, Week, QSortThenBy> {
  QueryBuilder<Week, Week, QAfterSortBy> thenByCells() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cells', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByCellsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cells', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByMonday() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monday', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByMondayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monday', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenBySystemConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenBySystemConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systemConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByUserConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByWeekYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekYear', Sort.asc);
    });
  }

  QueryBuilder<Week, Week, QAfterSortBy> thenByWeekYearDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekYear', Sort.desc);
    });
  }
}

extension WeekQueryWhereDistinct on QueryBuilder<Week, Week, QDistinct> {
  QueryBuilder<Week, Week, QDistinct> distinctByCells(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cells', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByMonday() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monday');
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByProgress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamId');
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctBySystemConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'systemConfirmed');
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userConfirmed');
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekNumber');
    });
  }

  QueryBuilder<Week, Week, QDistinct> distinctByWeekYear() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekYear');
    });
  }
}

extension WeekQueryProperty on QueryBuilder<Week, Week, QQueryProperty> {
  QueryBuilder<Week, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Week, String?, QQueryOperations> cellsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cells');
    });
  }

  QueryBuilder<Week, DateTime?, QQueryOperations> mondayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monday');
    });
  }

  QueryBuilder<Week, String?, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<Week, int?, QQueryOperations> streamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamId');
    });
  }

  QueryBuilder<Week, bool?, QQueryOperations> systemConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'systemConfirmed');
    });
  }

  QueryBuilder<Week, bool?, QQueryOperations> userConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userConfirmed');
    });
  }

  QueryBuilder<Week, int?, QQueryOperations> weekNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekNumber');
    });
  }

  QueryBuilder<Week, int?, QQueryOperations> weekYearProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekYear');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDayCollection on Isar {
  IsarCollection<Day> get days => this.collection();
}

const DaySchema = CollectionSchema(
  name: r'Day',
  id: 4355558770213572104,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'dateAt': PropertySchema(
      id: 1,
      name: r'dateAt',
      type: IsarType.dateTime,
    ),
    r'startAt': PropertySchema(
      id: 2,
      name: r'startAt',
      type: IsarType.dateTime,
    ),
    r'weekId': PropertySchema(
      id: 3,
      name: r'weekId',
      type: IsarType.long,
    )
  },
  estimateSize: _dayEstimateSize,
  serialize: _daySerialize,
  deserialize: _dayDeserialize,
  deserializeProp: _dayDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'week': LinkSchema(
      id: -1358179868134066193,
      name: r'week',
      target: r'Week',
      single: true,
    ),
    r'dayResultBacklink': LinkSchema(
      id: 7385795428417170791,
      name: r'dayResultBacklink',
      target: r'DayResult',
      single: false,
      linkName: r'day',
    )
  },
  embeddedSchemas: {},
  getId: _dayGetId,
  getLinks: _dayGetLinks,
  attach: _dayAttach,
  version: '3.1.0+1',
);

int _dayEstimateSize(
  Day object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _daySerialize(
  Day object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeDateTime(offsets[1], object.dateAt);
  writer.writeDateTime(offsets[2], object.startAt);
  writer.writeLong(offsets[3], object.weekId);
}

Day _dayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Day();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.dateAt = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.startAt = reader.readDateTimeOrNull(offsets[2]);
  object.weekId = reader.readLongOrNull(offsets[3]);
  return object;
}

P _dayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dayGetId(Day object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dayGetLinks(Day object) {
  return [object.week, object.dayResultBacklink];
}

void _dayAttach(IsarCollection<dynamic> col, Id id, Day object) {
  object.id = id;
  object.week.attach(col, col.isar.collection<Week>(), r'week', id);
  object.dayResultBacklink
      .attach(col, col.isar.collection<DayResult>(), r'dayResultBacklink', id);
}

extension DayQueryWhereSort on QueryBuilder<Day, Day, QWhere> {
  QueryBuilder<Day, Day, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DayQueryWhere on QueryBuilder<Day, Day, QWhereClause> {
  QueryBuilder<Day, Day, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Day, Day, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Day, Day, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Day, Day, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DayQueryFilter on QueryBuilder<Day, Day, QFilterCondition> {
  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dateAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startAt',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> startAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'weekId',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'weekId',
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekId',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekId',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekId',
        value: value,
      ));
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DayQueryObject on QueryBuilder<Day, Day, QFilterCondition> {}

extension DayQueryLinks on QueryBuilder<Day, Day, QFilterCondition> {
  QueryBuilder<Day, Day, QAfterFilterCondition> week(FilterQuery<Week> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'week');
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> weekIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'week', 0, true, 0, true);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklink(
      FilterQuery<DayResult> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'dayResultBacklink');
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklinkLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayResultBacklink', length, true, length, true);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayResultBacklink', 0, true, 0, true);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayResultBacklink', 0, false, 999999, true);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklinkLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dayResultBacklink', 0, true, length, include);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition>
      dayResultBacklinkLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'dayResultBacklink', length, include, 999999, true);
    });
  }

  QueryBuilder<Day, Day, QAfterFilterCondition> dayResultBacklinkLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'dayResultBacklink', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DayQuerySortBy on QueryBuilder<Day, Day, QSortBy> {
  QueryBuilder<Day, Day, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByDateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByDateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByWeekId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekId', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> sortByWeekIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekId', Sort.desc);
    });
  }
}

extension DayQuerySortThenBy on QueryBuilder<Day, Day, QSortThenBy> {
  QueryBuilder<Day, Day, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByDateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByDateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByStartAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startAt', Sort.desc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByWeekId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekId', Sort.asc);
    });
  }

  QueryBuilder<Day, Day, QAfterSortBy> thenByWeekIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekId', Sort.desc);
    });
  }
}

extension DayQueryWhereDistinct on QueryBuilder<Day, Day, QDistinct> {
  QueryBuilder<Day, Day, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<Day, Day, QDistinct> distinctByDateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAt');
    });
  }

  QueryBuilder<Day, Day, QDistinct> distinctByStartAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startAt');
    });
  }

  QueryBuilder<Day, Day, QDistinct> distinctByWeekId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekId');
    });
  }
}

extension DayQueryProperty on QueryBuilder<Day, Day, QQueryProperty> {
  QueryBuilder<Day, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Day, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<Day, DateTime?, QQueryOperations> dateAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAt');
    });
  }

  QueryBuilder<Day, DateTime?, QQueryOperations> startAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startAt');
    });
  }

  QueryBuilder<Day, int?, QQueryOperations> weekIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDayResultCollection on Isar {
  IsarCollection<DayResult> get dayResults => this.collection();
}

const DayResultSchema = CollectionSchema(
  name: r'DayResult',
  id: 5536848635559855542,
  properties: {
    r'dayId': PropertySchema(
      id: 0,
      name: r'dayId',
      type: IsarType.long,
    ),
    r'desires': PropertySchema(
      id: 1,
      name: r'desires',
      type: IsarType.string,
    ),
    r'executionScope': PropertySchema(
      id: 2,
      name: r'executionScope',
      type: IsarType.long,
    ),
    r'interference': PropertySchema(
      id: 3,
      name: r'interference',
      type: IsarType.string,
    ),
    r'rejoice': PropertySchema(
      id: 4,
      name: r'rejoice',
      type: IsarType.string,
    ),
    r'reluctance': PropertySchema(
      id: 5,
      name: r'reluctance',
      type: IsarType.string,
    ),
    r'result': PropertySchema(
      id: 6,
      name: r'result',
      type: IsarType.string,
    )
  },
  estimateSize: _dayResultEstimateSize,
  serialize: _dayResultSerialize,
  deserialize: _dayResultDeserialize,
  deserializeProp: _dayResultDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'day': LinkSchema(
      id: -7053829138239311824,
      name: r'day',
      target: r'Day',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _dayResultGetId,
  getLinks: _dayResultGetLinks,
  attach: _dayResultAttach,
  version: '3.1.0+1',
);

int _dayResultEstimateSize(
  DayResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.desires;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.interference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rejoice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reluctance;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.result;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dayResultSerialize(
  DayResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayId);
  writer.writeString(offsets[1], object.desires);
  writer.writeLong(offsets[2], object.executionScope);
  writer.writeString(offsets[3], object.interference);
  writer.writeString(offsets[4], object.rejoice);
  writer.writeString(offsets[5], object.reluctance);
  writer.writeString(offsets[6], object.result);
}

DayResult _dayResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DayResult();
  object.dayId = reader.readLongOrNull(offsets[0]);
  object.desires = reader.readStringOrNull(offsets[1]);
  object.executionScope = reader.readLongOrNull(offsets[2]);
  object.id = id;
  object.interference = reader.readStringOrNull(offsets[3]);
  object.rejoice = reader.readStringOrNull(offsets[4]);
  object.reluctance = reader.readStringOrNull(offsets[5]);
  object.result = reader.readStringOrNull(offsets[6]);
  return object;
}

P _dayResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dayResultGetId(DayResult object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dayResultGetLinks(DayResult object) {
  return [object.day];
}

void _dayResultAttach(IsarCollection<dynamic> col, Id id, DayResult object) {
  object.id = id;
  object.day.attach(col, col.isar.collection<Day>(), r'day', id);
}

extension DayResultQueryWhereSort
    on QueryBuilder<DayResult, DayResult, QWhere> {
  QueryBuilder<DayResult, DayResult, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DayResultQueryWhere
    on QueryBuilder<DayResult, DayResult, QWhereClause> {
  QueryBuilder<DayResult, DayResult, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DayResultQueryFilter
    on QueryBuilder<DayResult, DayResult, QFilterCondition> {
  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayId',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayId',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayId',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayId',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayId',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'desires',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'desires',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'desires',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'desires',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'desires',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> desiresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desires',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      desiresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'desires',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'executionScope',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'executionScope',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'executionScope',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'executionScope',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'executionScope',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      executionScopeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'executionScope',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'interference',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'interference',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> interferenceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> interferenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'interference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'interference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> interferenceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'interference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'interference',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      interferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'interference',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rejoice',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rejoice',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rejoice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rejoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rejoice',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> rejoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rejoice',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      rejoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rejoice',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reluctance',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      reluctanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reluctance',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      reluctanceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reluctance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      reluctanceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reluctance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> reluctanceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reluctance',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      reluctanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reluctance',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition>
      reluctanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reluctance',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'result',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'result',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'result',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'result',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'result',
        value: '',
      ));
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> resultIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'result',
        value: '',
      ));
    });
  }
}

extension DayResultQueryObject
    on QueryBuilder<DayResult, DayResult, QFilterCondition> {}

extension DayResultQueryLinks
    on QueryBuilder<DayResult, DayResult, QFilterCondition> {
  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> day(
      FilterQuery<Day> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'day');
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterFilterCondition> dayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'day', 0, true, 0, true);
    });
  }
}

extension DayResultQuerySortBy on QueryBuilder<DayResult, DayResult, QSortBy> {
  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayId', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayId', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByDesires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desires', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByDesiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desires', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByExecutionScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionScope', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByExecutionScopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionScope', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByInterference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interference', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByInterferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interference', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByRejoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejoice', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByRejoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejoice', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByReluctance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reluctance', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByReluctanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reluctance', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> sortByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }
}

extension DayResultQuerySortThenBy
    on QueryBuilder<DayResult, DayResult, QSortThenBy> {
  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayId', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayId', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByDesires() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desires', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByDesiresDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desires', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByExecutionScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionScope', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByExecutionScopeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executionScope', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByInterference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interference', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByInterferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'interference', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByRejoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejoice', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByRejoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rejoice', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByReluctance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reluctance', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByReluctanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reluctance', Sort.desc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByResult() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.asc);
    });
  }

  QueryBuilder<DayResult, DayResult, QAfterSortBy> thenByResultDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'result', Sort.desc);
    });
  }
}

extension DayResultQueryWhereDistinct
    on QueryBuilder<DayResult, DayResult, QDistinct> {
  QueryBuilder<DayResult, DayResult, QDistinct> distinctByDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayId');
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByDesires(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'desires', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByExecutionScope() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'executionScope');
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByInterference(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'interference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByRejoice(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rejoice', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByReluctance(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reluctance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DayResult, DayResult, QDistinct> distinctByResult(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'result', caseSensitive: caseSensitive);
    });
  }
}

extension DayResultQueryProperty
    on QueryBuilder<DayResult, DayResult, QQueryProperty> {
  QueryBuilder<DayResult, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DayResult, int?, QQueryOperations> dayIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayId');
    });
  }

  QueryBuilder<DayResult, String?, QQueryOperations> desiresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'desires');
    });
  }

  QueryBuilder<DayResult, int?, QQueryOperations> executionScopeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executionScope');
    });
  }

  QueryBuilder<DayResult, String?, QQueryOperations> interferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'interference');
    });
  }

  QueryBuilder<DayResult, String?, QQueryOperations> rejoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rejoice');
    });
  }

  QueryBuilder<DayResult, String?, QQueryOperations> reluctanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reluctance');
    });
  }

  QueryBuilder<DayResult, String?, QQueryOperations> resultProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'result');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTwoTargetCollection on Isar {
  IsarCollection<TwoTarget> get twoTargets => this.collection();
}

const TwoTargetSchema = CollectionSchema(
  name: r'TwoTarget',
  id: 779779140772234718,
  properties: {
    r'minimum': PropertySchema(
      id: 0,
      name: r'minimum',
      type: IsarType.string,
    ),
    r'streamId': PropertySchema(
      id: 1,
      name: r'streamId',
      type: IsarType.long,
    ),
    r'targetOneDescription': PropertySchema(
      id: 2,
      name: r'targetOneDescription',
      type: IsarType.string,
    ),
    r'targetOneTitle': PropertySchema(
      id: 3,
      name: r'targetOneTitle',
      type: IsarType.string,
    ),
    r'targetTwoDescription': PropertySchema(
      id: 4,
      name: r'targetTwoDescription',
      type: IsarType.string,
    ),
    r'targetTwoTitle': PropertySchema(
      id: 5,
      name: r'targetTwoTitle',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _twoTargetEstimateSize,
  serialize: _twoTargetSerialize,
  deserialize: _twoTargetDeserialize,
  deserializeProp: _twoTargetDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'nPStream': LinkSchema(
      id: -64755847094805169,
      name: r'nPStream',
      target: r'NPStream',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _twoTargetGetId,
  getLinks: _twoTargetGetLinks,
  attach: _twoTargetAttach,
  version: '3.1.0+1',
);

int _twoTargetEstimateSize(
  TwoTarget object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.minimum;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetOneDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetOneTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetTwoDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.targetTwoTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _twoTargetSerialize(
  TwoTarget object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.minimum);
  writer.writeLong(offsets[1], object.streamId);
  writer.writeString(offsets[2], object.targetOneDescription);
  writer.writeString(offsets[3], object.targetOneTitle);
  writer.writeString(offsets[4], object.targetTwoDescription);
  writer.writeString(offsets[5], object.targetTwoTitle);
  writer.writeString(offsets[6], object.title);
}

TwoTarget _twoTargetDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TwoTarget();
  object.id = id;
  object.minimum = reader.readStringOrNull(offsets[0]);
  object.streamId = reader.readLongOrNull(offsets[1]);
  object.targetOneDescription = reader.readStringOrNull(offsets[2]);
  object.targetOneTitle = reader.readStringOrNull(offsets[3]);
  object.targetTwoDescription = reader.readStringOrNull(offsets[4]);
  object.targetTwoTitle = reader.readStringOrNull(offsets[5]);
  object.title = reader.readStringOrNull(offsets[6]);
  return object;
}

P _twoTargetDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _twoTargetGetId(TwoTarget object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _twoTargetGetLinks(TwoTarget object) {
  return [object.nPStream];
}

void _twoTargetAttach(IsarCollection<dynamic> col, Id id, TwoTarget object) {
  object.id = id;
  object.nPStream.attach(col, col.isar.collection<NPStream>(), r'nPStream', id);
}

extension TwoTargetQueryWhereSort
    on QueryBuilder<TwoTarget, TwoTarget, QWhere> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TwoTargetQueryWhere
    on QueryBuilder<TwoTarget, TwoTarget, QWhereClause> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TwoTargetQueryFilter
    on QueryBuilder<TwoTarget, TwoTarget, QFilterCondition> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'minimum',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'minimum',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'minimum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'minimum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'minimum',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> minimumIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'minimum',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      minimumIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'minimum',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> streamIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'streamId',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      streamIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'streamId',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> streamIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> streamIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> streamIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streamId',
        value: value,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> streamIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streamId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetOneDescription',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetOneDescription',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetOneDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetOneDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetOneDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetOneDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetOneDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetOneTitle',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetOneTitle',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetOneTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetOneTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetOneTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetOneTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetOneTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetOneTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetTwoDescription',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetTwoDescription',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetTwoDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetTwoDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetTwoDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTwoDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetTwoDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetTwoTitle',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetTwoTitle',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetTwoTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetTwoTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetTwoTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTwoTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition>
      targetTwoTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetTwoTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension TwoTargetQueryObject
    on QueryBuilder<TwoTarget, TwoTarget, QFilterCondition> {}

extension TwoTargetQueryLinks
    on QueryBuilder<TwoTarget, TwoTarget, QFilterCondition> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> nPStream(
      FilterQuery<NPStream> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'nPStream');
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterFilterCondition> nPStreamIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'nPStream', 0, true, 0, true);
    });
  }
}

extension TwoTargetQuerySortBy on QueryBuilder<TwoTarget, TwoTarget, QSortBy> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByMinimum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimum', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByMinimumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimum', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      sortByTargetOneDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneDescription', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      sortByTargetOneDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneDescription', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTargetOneTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneTitle', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTargetOneTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneTitle', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      sortByTargetTwoDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoDescription', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      sortByTargetTwoDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoDescription', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTargetTwoTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoTitle', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTargetTwoTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoTitle', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TwoTargetQuerySortThenBy
    on QueryBuilder<TwoTarget, TwoTarget, QSortThenBy> {
  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByMinimum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimum', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByMinimumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minimum', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByStreamIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streamId', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      thenByTargetOneDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneDescription', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      thenByTargetOneDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneDescription', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTargetOneTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneTitle', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTargetOneTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetOneTitle', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      thenByTargetTwoDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoDescription', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy>
      thenByTargetTwoDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoDescription', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTargetTwoTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoTitle', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTargetTwoTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTwoTitle', Sort.desc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension TwoTargetQueryWhereDistinct
    on QueryBuilder<TwoTarget, TwoTarget, QDistinct> {
  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByMinimum(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minimum', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByStreamId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streamId');
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByTargetOneDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetOneDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByTargetOneTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetOneTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByTargetTwoDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetTwoDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByTargetTwoTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetTwoTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TwoTarget, TwoTarget, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension TwoTargetQueryProperty
    on QueryBuilder<TwoTarget, TwoTarget, QQueryProperty> {
  QueryBuilder<TwoTarget, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations> minimumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minimum');
    });
  }

  QueryBuilder<TwoTarget, int?, QQueryOperations> streamIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streamId');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations>
      targetOneDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetOneDescription');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations> targetOneTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetOneTitle');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations>
      targetTwoDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetTwoDescription');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations> targetTwoTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetTwoTitle');
    });
  }

  QueryBuilder<TwoTarget, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
