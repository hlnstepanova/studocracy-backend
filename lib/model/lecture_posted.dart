import 'package:studocracy_backend/studocracy_backend.dart';
import 'package:convert/convert.dart';

class LecturePosted extends Serializable{
  LecturePosted(this.title, this.endTime);

  String title;
  DateTime endTime;

  @override
  Map<String, dynamic> asMap() => {
      "title": title,
      "endTime": endTime.toIso8601String()
    };

  @override
  void readFromMap(Map<String, dynamic> object) {
    title = object['title'] as String;
    endTime = object['endTime'] as DateTime;
  }

}