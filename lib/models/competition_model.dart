class CompetitionModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final Map<String, dynamic>? prizes;
  
  CompetitionModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.prizes,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'],
      titleAr: json['titleAr'],
      titleEn: json['titleEn'],
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
      prizes: json['prizes'],
    );
  }
}
