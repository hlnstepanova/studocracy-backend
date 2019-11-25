import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../model/lecture.dart';

class LectureController extends ResourceController{
  LectureController(this.context);
  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllLectures() async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    return Response.ok(await fetchLecturesQuery.fetch());
  }

  @Operation.post()
  Future<Response> createLecture(@Bind.body() LectureDBmodel lectureDBmodel) async {
    final fetchLecturesQuery = Query<LectureDBmodel>(context);
    var newId = generateId(await fetchLecturesQuery.fetch());
    print(newId);
    print(lectureDBmodel.id);
    lectureDBmodel.id = newId;
    return Response.ok(lectureDBmodel);
  }

  String generateId(List<Lecture> allLectures) {
     final Set occupiedNames = <String>{};
     if (occupiedNames.isEmpty){
       return "lecture0";
     }
     for(Lecture l in allLectures){
       occupiedNames.add(l.id);
     }
     for(int i = 0; i >= 0; i++) {
       if(!occupiedNames.contains("lecture${i}")) {
         return"lecture${i}";
       }
     }
     return null;
  }

}