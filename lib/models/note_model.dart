import 'package:flutter/material.dart';

// Define the enum for sort options
enum SortOption {
  modifiedDate,
  createdDate,
  title,
}

// Define the enum for filter options
enum FilterOption {
  all,
  pinned,
}

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isPinned;
  final Color color;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.modifiedAt,
    this.isPinned = false,
    this.color = Colors.white,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    bool? isPinned,
    Color? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
    );
  }
}
