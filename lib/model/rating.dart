import 'package:studocracy_backend/studocracy_backend.dart';
import 'lecture.dart';

class RatingDBmodel extends ManagedObject<Rating> implements Rating{}

class Rating {
  Rating(this.clientId, this.lecture, this.category, this.value);

  @Column(primaryKey: true)
  String clientId;
  String category;
  double value;

  @Relate(#ratings)
  LectureDBmodel lecture;

}