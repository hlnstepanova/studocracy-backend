import 'package:aqueduct/aqueduct.dart';
import 'feedback.dart';
import 'rating.dart';

class Lecture {

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


}