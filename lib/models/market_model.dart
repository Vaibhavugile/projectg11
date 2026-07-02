import 'package:cloud_firestore/cloud_firestore.dart';

class MarketModel {
  final String id;

  final String name;
  final String slug;

  final String openTime;
  final String closeTime;

  final int displayOrder;
  final int sortOrder;

  final int viewers;

  final bool isActive;
  final bool isFeatured;
  final bool favorite;

  final Map<String, dynamic>? latestResult;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const MarketModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.openTime,
    required this.closeTime,
    required this.displayOrder,
    required this.sortOrder,
    required this.viewers,
    required this.isActive,
    required this.isFeatured,
    required this.favorite,
    this.latestResult,
    this.createdAt,
    this.updatedAt,
  });

  factory MarketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MarketModel(
      id: doc.id,

      name: data["name"] ?? "",
      slug: data["slug"] ?? "",

      openTime: data["openTime"] ?? "",
      closeTime: data["closeTime"] ?? "",

      displayOrder: data["displayOrder"] ?? 1,
      sortOrder: data["sortOrder"] ?? 1,

      viewers: data["viewers"] ?? 0,

      isActive: data["isActive"] ?? true,
      isFeatured: data["isFeatured"] ?? false,
      favorite: data["favorite"] ?? false,

      latestResult:
          data["latestResult"] as Map<String, dynamic>?,

      createdAt: data["createdAt"] as Timestamp?,
      updatedAt: data["updatedAt"] as Timestamp?,
    );
  }

  factory MarketModel.fromMap(
    Map<String, dynamic> data,
    String id,
  ) {
    return MarketModel(
      id: id,

      name: data["name"] ?? "",
      slug: data["slug"] ?? "",

      openTime: data["openTime"] ?? "",
      closeTime: data["closeTime"] ?? "",

      displayOrder: data["displayOrder"] ?? 1,
      sortOrder: data["sortOrder"] ?? 1,

      viewers: data["viewers"] ?? 0,

      isActive: data["isActive"] ?? true,
      isFeatured: data["isFeatured"] ?? false,
      favorite: data["favorite"] ?? false,

      latestResult:
          data["latestResult"] as Map<String, dynamic>?,

      createdAt: data["createdAt"] as Timestamp?,
      updatedAt: data["updatedAt"] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "slug": slug,

      "openTime": openTime,
      "closeTime": closeTime,

      "displayOrder": displayOrder,
      "sortOrder": sortOrder,

      "viewers": viewers,

      "isActive": isActive,
      "isFeatured": isFeatured,
      "favorite": favorite,

      "latestResult": latestResult,

      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  MarketModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? openTime,
    String? closeTime,
    int? displayOrder,
    int? sortOrder,
    int? viewers,
    bool? isActive,
    bool? isFeatured,
    bool? favorite,
    Map<String, dynamic>? latestResult,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return MarketModel(
      id: id ?? this.id,

      name: name ?? this.name,
      slug: slug ?? this.slug,

      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,

      displayOrder: displayOrder ?? this.displayOrder,
      sortOrder: sortOrder ?? this.sortOrder,

      viewers: viewers ?? this.viewers,

      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      favorite: favorite ?? this.favorite,

      latestResult: latestResult ?? this.latestResult,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}