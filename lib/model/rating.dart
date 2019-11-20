import 'package:studocracy_backend/studocracy_backend.dart';

import 'lecture.dart';

class RatingDBmodel extends ManagedObject<Rating> implements Rating{}

class Rating extends Serializable {
  Rating(this.clientId, this.lecture, this.category, this.value);

  @primaryKey
  String clientId;
  @Relate(#ratings)
  LectureDBmodel lecture;
  String category;
  double value;

  @override
  Map<String, dynamic> asMap() => {
    "clientId": clientId,
    "lectureId": lecture.id,
    "category": category,
    "value": value
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    clientId = object['clientId'] as String;
    lecture = object['lectureId'] as LectureDBmodel;
    category = object['category'] as String;
    value = object['value'] as double;
  }


}