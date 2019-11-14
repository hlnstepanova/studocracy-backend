import 'package:aqueduct/aqueduct.dart';
import 'dart:convert';

class LecturePosted implements Serializable{
  LecturePosted(this.title, this.endTime);

  String title;
  DateTime endTime;

  Map<String, dynamic> asMap() {
    return {
      "title": title,
      "endTime": endTime
    };
  }

  void readFromMap(Map<String, dynamic> inputMap) {
    title = inputMap['title'].toString();
    // TODO: find a way to convert
    // endTime = inputMap['endTime'];
  }


  @override
  APISchemaObject documentSchema(APIDocumentContext context) {
    // not used
    return null;
  }

  @override
  void read(Map<String, dynamic> object, {Iterable<String> ignore, Iterable<String> reject, Iterable<String> require}) {
    // not used
  }
}