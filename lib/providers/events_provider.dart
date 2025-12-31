import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../services/enhanced_dio_service_v2.dart';

/// Model for Event data
class EventModel {
  final String id;
  final String conferenceId;
  final String type;
  final String title;
  final String? description;
  final String? location;
  final DateTime startTime;
  final DateTime endTime;
  final double? price;
  final String? currency;
  final int? capacity;
  final bool isActive;
  final String? status;
  final bool isFeatured;
  final int displayOrder;
  final List<String>? promotionalImages;
  final String? promotionalVideo;
  final InstructorModel? instructor;
  final List<SpeakerModel>? speakers;
  final int registrationsCount;

  EventModel({
    required this.id,
    required this.conferenceId,
    required this.type,
    required this.title,
    this.description,
    this.location,
    required this.startTime,
    required this.endTime,
    this.price,
    this.currency,
    this.capacity,
    required this.isActive,
    this.status,
    this.isFeatured = false,
    this.displayOrder = 0,
    this.promotionalImages,
    this.promotionalVideo,
    this.instructor,
    this.speakers,
    this.registrationsCount = 0,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Parse promotional images
    List<String>? promoImages;
    if (json['promotionalImages'] != null) {
      if (json['promotionalImages'] is List) {
        promoImages = (json['promotionalImages'] as List).map((e) => e.toString()).toList();
      } else if (json['promotionalImages'] is String) {
        promoImages = [json['promotionalImages'] as String];
      }
    }

    return EventModel(
      id: json['id'] ?? '',
      conferenceId: json['conferenceId'] ?? '',
      type: json['type'] ?? 'COURSE',
      title: json['title'] ?? '',
      description: json['description'],
      location: json['location'],
      startTime: DateTime.parse(json['startTime'] ?? DateTime.now().toIso8601String()),
      endTime: DateTime.parse(json['endTime'] ?? DateTime.now().toIso8601String()),
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'],
      capacity: json['capacity'],
      isActive: json['isActive'] ?? true,
      status: json['status'],
      isFeatured: json['isFeatured'] ?? false,
      displayOrder: json['displayOrder'] ?? 0,
      promotionalImages: promoImages,
      promotionalVideo: json['promotionalVideo'],
      instructor: json['instructor'] != null ? InstructorModel.fromJson(json['instructor']) : null,
      speakers: json['speakers'] != null
          ? (json['speakers'] as List).map((e) => SpeakerModel.fromJson(e)).toList()
          : null,
      registrationsCount: json['registrationsCount'] ?? 0,
    );
  }

  String? get firstImageUrl {
    if (promotionalImages != null && promotionalImages!.isNotEmpty) {
      return promotionalImages!.first;
    }
    return null;
  }
}

/// Model for Instructor data
class InstructorModel {
  final String id;
  final String name;
  final String? title;
  final String? photoUrl;

  InstructorModel({
    required this.id,
    required this.name,
    this.title,
    this.photoUrl,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'],
      photoUrl: json['photoUrl'],
    );
  }
}

/// Model for Speaker data
class SpeakerModel {
  final String id;
  final String name;
  final String? title;
  final String? bio;
  final String? photoUrl;
  final String? organization;
  final String? email;

  SpeakerModel({
    required this.id,
    required this.name,
    this.title,
    this.bio,
    this.photoUrl,
    this.organization,
    this.email,
  });

  factory SpeakerModel.fromJson(Map<String, dynamic> json) {
    return SpeakerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      title: json['title'],
      bio: json['bio'],
      photoUrl: json['photoUrl'],
      organization: json['organization'],
      email: json['email'],
    );
  }
}

/// Provider for featured events
final featuredEventsProvider = FutureProvider.autoDispose<List<EventModel>>((ref) async {
  try {
    final response = await EnhancedDioServiceV2.instance.get(
      '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}',
      queryParameters: {
        'isFeatured': true,
        'limit': 10,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      List<dynamic> events = [];
      
      if (data is Map && data['data'] != null) {
        events = data['data'] as List;
      } else if (data is List) {
        events = data;
      }

      return events.map((e) => EventModel.fromJson(e)).toList();
    }
    
    return [];
  } catch (e) {
    debugPrint('❌ [EVENTS_PROVIDER] Error fetching featured events: $e');
    return [];
  }
});

/// Provider for featured speakers
final featuredSpeakersProvider = FutureProvider.autoDispose<List<SpeakerModel>>((ref) async {
  try {
    final response = await EnhancedDioServiceV2.instance.get(
      '${ApiConstants.baseUrl}${ApiConstants.speakersEndpoint}',
      queryParameters: {
        'limit': 10,
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      List<dynamic> speakers = [];
      
      if (data is Map && data['data'] != null) {
        speakers = data['data'] as List;
      } else if (data is List) {
        speakers = data;
      }

      return speakers.map((e) => SpeakerModel.fromJson(e)).toList();
    }
    
    return [];
  } catch (e) {
    debugPrint('❌ [SPEAKERS_PROVIDER] Error fetching speakers: $e');
    return [];
  }
});

/// Provider for all events (with pagination)
final allEventsProvider = FutureProvider.autoDispose.family<List<EventModel>, Map<String, dynamic>>((ref, params) async {
  try {
    final response = await EnhancedDioServiceV2.instance.get(
      '${ApiConstants.baseUrl}${ApiConstants.eventsEndpoint}',
      queryParameters: params,
    );

    if (response.statusCode == 200) {
      final data = response.data;
      List<dynamic> events = [];
      
      if (data is Map && data['data'] != null) {
        events = data['data'] as List;
      } else if (data is List) {
        events = data;
      }

      return events.map((e) => EventModel.fromJson(e)).toList();
    }
    
    return [];
  } catch (e) {
    debugPrint('❌ [EVENTS_PROVIDER] Error fetching events: $e');
    return [];
  }
});
