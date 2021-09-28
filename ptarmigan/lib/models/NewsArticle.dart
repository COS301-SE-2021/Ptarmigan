import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Feed type in your schema. */
@immutable
class NewsArticles extends Model {
  static const classType = const _FeedModelType();
  final String id;
  final String? _title;
  final String? _description;
  final String? _url;
  final String? _urlToImage;
  final String? _content;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String? get title {
    return _title;
  }

  String? get description {
    return _description;
  }

  String? get url {
    return _url;
  }

  String? get urlToImage {
    return _urlToImage;
  }

  String? get content {
    return _content;
  }

  const NewsArticles._internal(
      {required this.id, title, description, url, urlToImage, content})
      : _title = title,
        _url = url,
        _description = description,
        _urlToImage = urlToImage,
        _content = content;

  factory NewsArticles(
      {String? id,
      String? title,
      String? description,
      String? url,
      String? urlToImage,
      String? content}) {
    return NewsArticles._internal(
        id: id == null ? UUID.getUUID() : id,
        title: title,
        url: url,
        urlToImage: urlToImage,
        description: description,
        content: content);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewsArticles &&
        _title == other._title &&
        _url == other._url &&
        _urlToImage == other._urlToImage &&
        _description == other._description &&
        _content == other._content;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("{");
    buffer.write("Title=" + "$_title" + ", ");
    buffer.write("Url=" + "$_url" + ", ");
    buffer.write("UrlToImage=" + "$_urlToImage" + ", ");
    buffer.write("Description=" + "$_description" + ", ");
    buffer.write("Content=" + "$_content" + ", ");
    buffer.write("}");

    return buffer.toString();
  }

  NewsArticles copyWith(
      {String? id,
      String? title,
      String? description,
      String? url,
      String? urlToImage,
      String? content}) {
    return NewsArticles(
        id: id ?? this.id,
        title: title ?? this.title,
        url: url ?? this.url,
        description: description ?? this.description,
        urlToImage: urlToImage ?? this.urlToImage,
        content: content ?? this.content);
  }

  NewsArticles.fromJson(Map<String, dynamic> json)
      : id = '1',
        _title = json['title'],
        _url = json['url'],
        _urlToImage = json['urlToImage'],
        _description = json['description'],
        _content = json['content'];

  Map<String, dynamic> toJson() => {
        'title': _title,
        'url': _url,
        'urlToImage': _urlToImage,
        'description': _description,
        'content': _content
      };
}

class _FeedModelType extends ModelType<NewsArticles> {
  const _FeedModelType();

  @override
  NewsArticles fromJson(Map<String, dynamic> jsonData) {
    return NewsArticles.fromJson(jsonData);
  }
}
