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

abstract class SpamCheckResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SpamCheckResult._({
    required this.isSpam,
    this.reason,
    this.friendlyFeedback,
    this.matchedRule,
  });

  factory SpamCheckResult({
    required bool isSpam,
    String? reason,
    String? friendlyFeedback,
    String? matchedRule,
  }) = _SpamCheckResultImpl;

  factory SpamCheckResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SpamCheckResult(
      isSpam: _isc.BoolJsonExtension.fromJson(jsonSerialization['isSpam']),
      reason: jsonSerialization['reason'] as String?,
      friendlyFeedback: jsonSerialization['friendlyFeedback'] as String?,
      matchedRule: jsonSerialization['matchedRule'] as String?,
    );
  }

  bool isSpam;

  String? reason;

  String? friendlyFeedback;

  String? matchedRule;

  /// Returns a shallow copy of this [SpamCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SpamCheckResult copyWith({
    bool? isSpam,
    String? reason,
    String? friendlyFeedback,
    String? matchedRule,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SpamCheckResult',
      'isSpam': isSpam,
      if (reason != null) 'reason': reason,
      if (friendlyFeedback != null) 'friendlyFeedback': friendlyFeedback,
      if (matchedRule != null) 'matchedRule': matchedRule,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SpamCheckResult',
      'isSpam': isSpam,
      if (reason != null) 'reason': reason,
      if (friendlyFeedback != null) 'friendlyFeedback': friendlyFeedback,
      if (matchedRule != null) 'matchedRule': matchedRule,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SpamCheckResultImpl extends SpamCheckResult {
  _SpamCheckResultImpl({
    required bool isSpam,
    String? reason,
    String? friendlyFeedback,
    String? matchedRule,
  }) : super._(
          isSpam: isSpam,
          reason: reason,
          friendlyFeedback: friendlyFeedback,
          matchedRule: matchedRule,
        );

  /// Returns a shallow copy of this [SpamCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SpamCheckResult copyWith({
    bool? isSpam,
    Object? reason = _Undefined,
    Object? friendlyFeedback = _Undefined,
    Object? matchedRule = _Undefined,
  }) {
    return SpamCheckResult(
      isSpam: isSpam ?? this.isSpam,
      reason: reason is String? ? reason : this.reason,
      friendlyFeedback: friendlyFeedback is String?
          ? friendlyFeedback
          : this.friendlyFeedback,
      matchedRule: matchedRule is String? ? matchedRule : this.matchedRule,
    );
  }
}
