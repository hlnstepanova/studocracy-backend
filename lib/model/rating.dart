import 'package:studocracy_backend/studocracy_backend.dart';
import 'lecture.dart';

class RatingDBmodel extends ManagedObject<Rating> implements Rating{}

class Rating {

  @Column(primaryKey: true)
  int id;
  String clientId;
  DateTime created;
  String category;
  double value;

  @Relate(#ratings)
  LectureDBmodel lecture;

}