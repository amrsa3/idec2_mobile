class VerificationRule {
  final String fieldName;
  final bool isRequired;
  final bool requiresDocument;
  final String? documentType;
  final String? description;
  final String? validationRule;

  const VerificationRule({
    required this.fieldName,
    required this.isRequired,
    required this.requiresDocument,
    this.documentType,
    this.description,
    this.validationRule,
  });

  factory VerificationRule.fromJson(Map<String, dynamic> json) {
    return VerificationRule(
      fieldName: json['fieldName'] as String,
      isRequired: json['isRequired'] as bool,
      requiresDocument: json['requiresDocument'] as bool,
      documentType: json['documentType'] as String?,
      description: json['description'] as String?,
      validationRule: json['validationRule'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldName': fieldName,
      'isRequired': isRequired,
      'requiresDocument': requiresDocument,
      'documentType': documentType,
      'description': description,
      'validationRule': validationRule,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationRule &&
        other.fieldName == fieldName &&
        other.isRequired == isRequired &&
        other.requiresDocument == requiresDocument &&
        other.documentType == documentType &&
        other.description == description &&
        other.validationRule == validationRule;
  }

  @override
  int get hashCode {
    return fieldName.hashCode ^
        isRequired.hashCode ^
        requiresDocument.hashCode ^
        documentType.hashCode ^
        description.hashCode ^
        validationRule.hashCode;
  }

  @override
  String toString() {
    return 'VerificationRule(fieldName: $fieldName, isRequired: $isRequired, requiresDocument: $requiresDocument, documentType: $documentType, description: $description, validationRule: $validationRule)';
  }
}