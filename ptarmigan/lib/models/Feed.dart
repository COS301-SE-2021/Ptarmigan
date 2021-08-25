/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Feed type in your schema. */
@immutable
class Feed extends Model {
  static const classType = const _FeedModelType();
  final String id;
  final String? _feedName;
  final String? _tags;
  final String? _description;
  final int? _subscribedTo;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get feedName {
    return _feedName;
  }
  
  String? get tags {
    return _tags;
  }
  
  String? get description {
    return _description;
  }
  
  int? get subscribedTo {
    return _subscribedTo;
  }
  
  const Feed._internal({required this.id, feedName, tags, description, subscribedTo}): _feedName = feedName, _tags = tags, _description = description, _subscribedTo = subscribedTo;
  
  factory Feed({String? id, String? feedName, String? tags, String? description, int? subscribedTo}) {
    return Feed._internal(
      id: id == null ? UUID.getUUID() : id,
      feedName: feedName,
      tags: tags,
      description: description,
      subscribedTo: subscribedTo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Feed &&
      id == other.id &&
      _feedName == other._feedName &&
      _tags == other._tags &&
      _description == other._description &&
      _subscribedTo == other._subscribedTo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Feed {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("feedName=" + "$_feedName" + ", ");
    buffer.write("tags=" + "$_tags" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("subscribedTo=" + (_subscribedTo != null ? _subscribedTo!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Feed copyWith({String? id, String? feedName, String? tags, String? description, int? subscribedTo}) {
    return Feed(
      id: id ?? this.id,
      feedName: feedName ?? this.feedName,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      subscribedTo: subscribedTo ?? this.subscribedTo);
  }
  
  Feed.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _feedName = json['feedName'],
      _tags = json['tags'],
      _description = json['description'],
      _subscribedTo = json['subscribedTo'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'feedName': _feedName, 'tags': _tags, 'description': _description, 'subscribedTo': _subscribedTo
  };

  static final QueryField ID = QueryField(fieldName: "feed.id");
  static final QueryField FEEDNAME = QueryField(fieldName: "feedName");
  static final QueryField TAGS = QueryField(fieldName: "tags");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField SUBSCRIBEDTO = QueryField(fieldName: "subscribedTo");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Feed";
    modelSchemaDefinition.pluralName = "Feeds";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Feed.FEEDNAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Feed.TAGS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Feed.DESCRIPTION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Feed.SUBSCRIBEDTO,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
  });
}

class _FeedModelType extends ModelType<Feed> {
  const _FeedModelType();
  
  @override
  Feed fromJson(Map<String, dynamic> jsonData) {
    return Feed.fromJson(jsonData);
  }
}