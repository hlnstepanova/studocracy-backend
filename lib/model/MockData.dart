import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import 'lecture.dart';

final Lecture lecture3 = Lecture("lectureId3","Betriebssysteme", DateTime.now().add(const Duration(minutes: 90)), null, null);
final Lecture lecture4 = Lecture("lectureId4","HSCodesign", DateTime.now().add(const Duration(minutes: 90)), null, null);
Lecture lecture1 = Lecture("lectureId1", "AppDev and bla", DateTime.now().add(const Duration(minutes: 90)), null, null);

List<Lecture> lectures = [ lecture3, lecture4, lecture1 ];

addMockData (ManagedContext context) {
  for(Lecture l in lectures) {
    final query = Query<LectureDBmodel>(context)
      ..values.title = l.title
      ..values.endTime = l.endTime
      ..values.id = l.id;
    query.insert();
  }
}