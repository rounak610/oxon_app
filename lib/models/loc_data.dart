// Copyright (c) 2021 Razeware LLC

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom
// the Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// Notwithstanding the foregoing, you may not use, copy, modify,
// merge, publish, distribute, sublicense, create a derivative work,
// and/or sell copies of the Software in any work that is designed,
// intended, or marketed for pedagogical or instructional purposes
// related to programming, coding, application development, or
// information technology. Permission for such use, copying,
// modification, merger, publication, distribution, sublicensing,
// creation of derivative works, or sale is expressly withheld.

// This project and source code may use libraries or frameworks
// that are released under various Open-Source licenses. Use of
// those libraries and frameworks are governed by their own
// individual licenses.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import 'package:cloud_firestore/cloud_firestore.dart';

class LocData {
  final int downvote;
  final bool is_displayed;
  final GeoPoint location;
  final String name;
  final String type;
  final String sub_type;
  final String u_id;
  final int upvote;

  LocData(
      {required this.downvote,
      required this.is_displayed,
      required this.location,
      required this.name,
      required this.type,
      required this.sub_type,
      required this.u_id,
      required this.upvote});

  factory LocData.fromJson(Map<String, dynamic> json) => _locDataFromJson(json);

  Map<String, dynamic> toJson() => _locDataToJson(this);
}


LocData _locDataFromJson(Map<String, dynamic> json) {
  return LocData(
    downvote: json['downvote'],
    is_displayed: json['is_displayed'],
    location: json['location'],
    name: json['name'],
    type: json['type'],
    sub_type: json['sub_type'],
    u_id: json['u_id'],
    upvote: json['upvote'],
  );
}


Map<String, dynamic> _locDataToJson(LocData instance) => <String, dynamic>{
      'downvote': instance.downvote,
      'is_displayed': instance.is_displayed,
      'location': instance.location,
      'name': instance.name,
      'type': instance.type,
      'sub_type': instance.sub_type,
      'u_id': instance.u_id,
      'upvote': instance.upvote
    };
