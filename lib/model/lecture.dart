import 'package:studocracy_backend/studocracy_backend.dart';
import 'feedback.dart';
import 'rating.dart';

class Lecture extends Serializable{

  Lecture(this.id, this.title, this.endTime);

  String id;
  String title;
  DateTime endTime;
  Map<String, List<Rating>> ratings = {
    "speedRatings" : [],
    "sizeRatings" : [],
    "interestRatings" : [],
  };
  List<Feedback> feedbackList = [];

  @override
  Map<String, dynamic> asMap() {
    // TODO: implement asMap
    return null;
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    // TODO: implement readFromMap
  }


}