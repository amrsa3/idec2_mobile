class Qualification {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final String categoryId;
  final bool isActive;
  final int displayOrder;
  final bool requiresDocument;
  final String? documentType;

  const Qualification({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.descriptionAr,
    this.descriptionEn,
    required this.categoryId,
    this.isActive = true,
    this.displayOrder = 0,
    this.requiresDocument = false,
    this.documentType,
  });

  factory Qualification.fromJson(Map<String, dynamic> json) {
    return Qualification(
      id: json['id'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      categoryId: json['categoryId'] as String,
      isActive: json['isActive'] as bool? ?? true,
      displayOrder: json['displayOrder'] as int? ?? 0,
      requiresDocument: json['requiresDocument'] as bool? ?? false,
      documentType: json['documentType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'categoryId': categoryId,
      'isActive': isActive,
      'displayOrder': displayOrder,
      'requiresDocument': requiresDocument,
      'documentType': documentType,
    };
  }

  /// Get display name based on locale
  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  /// Get description based on locale
  String? getDescription(String locale) {
    return locale == 'ar' ? descriptionAr : descriptionEn;
  }

  /// Legacy method for backward compatibility
  String getDisplayName(String locale) {
    return getName(locale);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Qualification &&
        other.id == id &&
        other.nameAr == nameAr &&
        other.nameEn == nameEn &&
        other.categoryId == categoryId &&
        other.isActive == isActive &&
        other.displayOrder == displayOrder &&
        other.requiresDocument == requiresDocument &&
        other.documentType == documentType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nameAr.hashCode ^
        nameEn.hashCode ^
        categoryId.hashCode ^
        isActive.hashCode ^
        displayOrder.hashCode ^
        requiresDocument.hashCode ^
        documentType.hashCode;
  }

  @override
  String toString() {
    return 'Qualification(id: $id, nameAr: $nameAr, nameEn: $nameEn, categoryId: $categoryId, isActive: $isActive, displayOrder: $displayOrder)';
  }
}
