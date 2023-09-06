// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_note_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDiaryNoteCollection on Isar {
  IsarCollection<DiaryNote> get diaryNotes => this.collection();
}

const DiaryNoteSchema = CollectionSchema(
  name: r'DiaryNote',
  id: 5214926931399771280,
  properties: {
    r'createAt': PropertySchema(
      id: 0,
      name: r'createAt',
      type: IsarType.dateTime,
    ),
    r'diaryNote': PropertySchema(
      id: 1,
      name: r'diaryNote',
      type: IsarType.string,
    ),
    r'updateAt': PropertySchema(
      id: 2,
      name: r'updateAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _diaryNoteEstimateSize,
  serialize: _diaryNoteSerialize,
  deserialize: _diaryNoteDeserialize,
  deserializeProp: _diaryNoteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _diaryNoteGetId,
  getLinks: _diaryNoteGetLinks,
  attach: _diaryNoteAttach,
  version: '3.1.0+1',
);

int _diaryNoteEstimateSize(
  DiaryNote object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.diaryNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _diaryNoteSerialize(
  DiaryNote object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createAt);
  writer.writeString(offsets[1], object.diaryNote);
  writer.writeDateTime(offsets[2], object.updateAt);
}

DiaryNote _diaryNoteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DiaryNote();
  object.createAt = reader.readDateTimeOrNull(offsets[0]);
  object.diaryNote = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.updateAt = reader.readDateTimeOrNull(offsets[2]);
  return object;
}

P _diaryNoteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _diaryNoteGetId(DiaryNote object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _diaryNoteGetLinks(DiaryNote object) {
  return [];
}

void _diaryNoteAttach(IsarCollection<dynamic> col, Id id, DiaryNote object) {
  object.id = id;
}

extension DiaryNoteQueryWhereSort
    on QueryBuilder<DiaryNote, DiaryNote, QWhere> {
  QueryBuilder<DiaryNote, DiaryNote, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DiaryNoteQueryWhere
    on QueryBuilder<DiaryNote, DiaryNote, QWhereClause> {
  QueryBuilder<DiaryNote, DiaryNote, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DiaryNote, DiaryNote, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterWhereClause> idBetween(
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

extension DiaryNoteQueryFilter
    on QueryBuilder<DiaryNote, DiaryNote, QFilterCondition> {
  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> createAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createAt',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition>
      createAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createAt',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> createAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> createAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> createAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> createAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'diaryNote',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition>
      diaryNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'diaryNote',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition>
      diaryNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diaryNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diaryNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diaryNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> diaryNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diaryNote',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition>
      diaryNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diaryNote',
        value: '',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> updateAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updateAt',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition>
      updateAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updateAt',
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> updateAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> updateAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> updateAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updateAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterFilterCondition> updateAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updateAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DiaryNoteQueryObject
    on QueryBuilder<DiaryNote, DiaryNote, QFilterCondition> {}

extension DiaryNoteQueryLinks
    on QueryBuilder<DiaryNote, DiaryNote, QFilterCondition> {}

extension DiaryNoteQuerySortBy on QueryBuilder<DiaryNote, DiaryNote, QSortBy> {
  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByDiaryNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diaryNote', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByDiaryNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diaryNote', Sort.desc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByUpdateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> sortByUpdateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateAt', Sort.desc);
    });
  }
}

extension DiaryNoteQuerySortThenBy
    on QueryBuilder<DiaryNote, DiaryNote, QSortThenBy> {
  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByCreateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createAt', Sort.desc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByDiaryNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diaryNote', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByDiaryNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diaryNote', Sort.desc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByUpdateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateAt', Sort.asc);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QAfterSortBy> thenByUpdateAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updateAt', Sort.desc);
    });
  }
}

extension DiaryNoteQueryWhereDistinct
    on QueryBuilder<DiaryNote, DiaryNote, QDistinct> {
  QueryBuilder<DiaryNote, DiaryNote, QDistinct> distinctByCreateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createAt');
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QDistinct> distinctByDiaryNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diaryNote', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DiaryNote, DiaryNote, QDistinct> distinctByUpdateAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updateAt');
    });
  }
}

extension DiaryNoteQueryProperty
    on QueryBuilder<DiaryNote, DiaryNote, QQueryProperty> {
  QueryBuilder<DiaryNote, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DiaryNote, DateTime?, QQueryOperations> createAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createAt');
    });
  }

  QueryBuilder<DiaryNote, String?, QQueryOperations> diaryNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diaryNote');
    });
  }

  QueryBuilder<DiaryNote, DateTime?, QQueryOperations> updateAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updateAt');
    });
  }
}
