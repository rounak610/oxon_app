import 'package:flutter/material.dart';
import 'dart:io';

class Concern {
  final String description;
  final issueType;
  final authorityType;
  Image image;

  Concern(
      {required this.description,
      required this.authorityType,
      required this.issueType,
      required this.image});
}
