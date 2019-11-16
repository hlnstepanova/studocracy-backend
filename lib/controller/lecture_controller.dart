import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import 'package:uuid/uuid.dart';
import '../model/feedback.dart';
import '../model/lecture.dart';
import '../model/lecture_posted.dart';
import '../model/rating.dart';

class LectureController extends ResourceController{
  var uuid = Uuid();
  final _lectures = [
    Lecture("lectureId3","Betriebssysteme", DateTime.now().add(const Duration(minutes: 90))),
    Lecture("lectureId4","HSCodesign", DateTime.now().add(const Duration(minutes: 90))),
    Lecture.sample(
      "lectureId1",
      "AppDev and bla",
      DateTime.now().add(const Duration(minutes: 90)),
      {
        "speedRatings" : [
          Rating("c1", "lectureId1", "speedRatings", 2.5),
          Rating("c3", "lectureId1", "speedRatings", 9),
          Rating("c2", "lectureId1", "speedRatings", 8)
        ],

        "sizeRatings" : [
          Rating("c1", "lectureId1", "sizeRatings", 4),
          Rating("c3", "lectureId1", "sizeRatings", 5)
        ],

        "interestRatings" : [
          Rating("c1", "lectureId1", "interestRatings", 2),
          Rating("c2", "lectureId1", "interestRatings", 5),
          Rating("c3", "lectureId1", "interestRatings", 9)
        ]
      },
        [
          Feedback("c1","lectureId1","Cool lecture", 8),
          Feedback("c2","lectureId1","Nice shirt", 9),
          Feedback("c3","lectureId1","Don't understand", 6),
          Feedback("c3","lectureId1","Boring", 1),
          Feedback("c1","lectureId1","Want to sleep", 3)
        ]
    ),
    Lecture.sample(
        "lectureId2",
        "IKT",
        DateTime.now().add(const Duration(minutes: 90)),
        {
          "speedRatings" : [
            Rating("c1", "lectureId2", "speedRatings", 1),
            Rating("c3", "lectureId2", "speedRatings", 7),
            Rating("c2", "lectureId2", "speedRatings", 6)
          ],

          "sizeRatings" : [
            Rating("c1", "lectureId2", "sizeRatings", 1),
            Rating("c3", "lectureId2", "sizeRatings", 2)
          ],

          "interestRatings" : [
            Rating("c1", "lectureId2", "interestRatings", 3),
            Rating("c2", "lectureId2", "interestRatings", 4),
            Rating("c3", "lectureId2", "interestRatings", 5)
          ]
        },
        [
          Feedback("c1","lectureId2","Cool", 8),
          Feedback("c2","lectureId2","Nice", 9),
          Feedback("c3","lectureId2","Wow", 10),
          Feedback("c3","lectureId2","Very oring", 1),
          Feedback("c1","lectureId2","Can I go?", 3)
        ]
    )
  ];

  @Operation.get()
  Future<Response> getAllLectures() async {
    return Response.ok(_lectures);
  }

  @Operation.get('id', 'category')
  Future<Response>getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async{
    final lecture = _lectures.firstWhere((lecture)=>lecture.id==id,
    orElse: ()=>null);
    if (lecture == null){
      return Response.notFound();
    }

    final ratings = lecture.ratings[category];

    var result = ratings.map((rating) => rating.value).reduce((a, b) => a + b) / ratings.length;
    return Response.ok(result);
  }

  @Operation.get('id')
  Future<Response>getFeedbackList(@Bind.path('id') String id) async{
    final lecture = _lectures.firstWhere((lecture)=>lecture.id==id,
        orElse: ()=>null);
    if (lecture == null){
      return Response.notFound();
    }

    return Response.ok(lecture.feedbackList);
  }

  @Operation.post()
  Future<Response>createLecture(@Bind.body() LecturePosted lecturePosted) async{

    String id = uuid.v4();
    final lecture = Lecture(id, lecturePosted.title, lecturePosted.endTime);
    _lectures.add(lecture);

    return Response.ok(lecture);
  }


}