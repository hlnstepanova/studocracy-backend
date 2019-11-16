import 'package:studocracy_backend/studocracy_backend.dart';

class Rating extends Serializable {
  Rating(this.clientId, this.lectureId, this.category, this.value);

  String clientId;
  String lectureId;
  String category;
  double value;

  @override
  Map<String, dynamic> asMap() => {
    "clientId": clientId,
    "lectureId": lectureId,
    "category": category,
    "value": value
  };

  @override
  void readFromMap(Map<String, dynamic> object) {
    clientId = object['clientId'] as String;
    lectureId = object['lectureId'] as String;
    category = object['category'] as String;
    value = object['value'] as double;
  }


}