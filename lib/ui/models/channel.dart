

import 'member.dart';

class Channel{
  String ?id;
  String ?name;
  String ?image;
  String ?description;
  String ?url;
  String ?category;
  String ?language;
  String ?country;
  String ?urls;
  String ?status;
  String ?createdAt;
  String ?updatedAt;
  String ?deletedAt;


  //频道成员，包含单聊、群聊
  List<Member>? members;

  Channel({
    this.id,
    this.name,
    this.image,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
    this.urls,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.members,
  });
}