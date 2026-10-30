/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class SpamKeywordRule
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SpamKeywordRule._({
    this.id,
    required this.pattern,
    required this.category,
    required this.severity,
    required this.isEnabled,
    required this.createdAt,
  });

  factory SpamKeywordRule({
    int? id,
    required String pattern,
    required String category,
    required String severity,
    required bool isEnabled,
    required DateTime createdAt,
  }) = _SpamKeywordRuleImpl;

  factory SpamKeywordRule.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpamKeywordRule(
      id: jsonSerialization['id'] as int?,
      pattern: jsonSerialization['pattern'] as String,
      category: jsonSerialization['category'] as String,
      severity: jsonSerialization['severity'] as String,
      isEnabled:
          _isc.BoolJsonExtension.fromJson(jsonSerialization['isEnabled']),
      createdAt:
          _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String pattern;

  String category;

  String severity;

  bool isEnabled;

  DateTime createdAt;

  /// Returns a shallow copy of this [SpamKeywordRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SpamKeywordRule copyWith({
    int? id,
    String? pattern,
    String? category,
    String? severity,
    bool? isEnabled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpamKeywordRule',
      if (id != null) 'id': id,
      'pattern': pattern,
      'category': category,
      'severity': severity,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpamKeywordRule',
      if (id != null) 'id': id,
      'pattern': pattern,
      'category': category,
      'severity': severity,
      'isEnabled': isEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SpamKeywordRuleImpl extends SpamKeywordRule {
  _SpamKeywordRuleImpl({
    int? id,
    required String pattern,
    required String category,
    required String severity,
    required bool isEnabled,
    required DateTime createdAt,
  }) : super._(
          id: id,
          pattern: pattern,
          category: category,
          severity: severity,
          isEnabled: isEnabled,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [SpamKeywordRule]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SpamKeywordRule copyWith({
    Object? id = _Undefined,
    String? pattern,
    String? category,
    String? severity,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return SpamKeywordRule(
      id: id is int? ? id : this.id,
      pattern: pattern ?? this.pattern,
      category: category ?? this.category,
      severity: severity ?? this.severity,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
