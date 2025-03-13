import 'package:flutter/material.dart';

class Note {
  final String id;
  String title;
  String content;
  Color color;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
    required this.modifiedAt,
    this.isPinned = false,
  });

  Note copyWith({
    String? title,
    String? content,
    Color? color,
    DateTime? modifiedAt,
    bool? isPinned,
  }) {
    return Note(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
