import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/model/feedback.dart';
import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/studocracy_backend.dart';

import 'lecture_controller.dart';

class FeedbackController extends ResourceController {
  FeedbackController(this.context);

  final ManagedContext context;

  @Operation.get('id')
  Future<Response> getFeedback(@Bind.path('id') String id) async{
    await LectureController.removeOldLectures(context);
    final fetchFeedbacksByLectureId = Query<LectureDBmodel>(context)
      ..join(set: (lecture) => lecture.feedbackList)
      ..where((lecture) => lecture.id).equalTo(id);
    final lecture = await fetchFeedbacksByLectureId.fetchOne();
    if(lecture == null) {
      return Response.notFound();
    }
    return Response.ok(lecture.feedbackList);
  }

  @Operation.post('id')
  Future<Response> giveFeedback(@Bind.path('id') String id, @Bind.body() FeedbackDBmodel feedbackDBmodel) async {
    await LectureController.removeOldLectures(context);
    final lecture = await context.fetchObjectWithID<LectureDBmodel>(id);
    if(lecture == null){
      return Response.notFound();
    }
    feedbackDBmodel.lecture = lecture;
    final insertFeedbackQuery = Query<FeedbackDBmodel>(context)
      ..values = feedbackDBmodel;
    final insertedFeedback = await insertFeedbackQuery.insert();
    return Response.ok(insertedFeedback);
  }
}