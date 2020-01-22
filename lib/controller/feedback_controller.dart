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
    feedbackDBmodel.created = DateTime.now();
    bool isValid = await checkForExistingFeedback(feedbackDBmodel);
    if(!isValid) {
      return Response.badRequest();
    }
    final fetchAllFeedbacks = Query<FeedbackDBmodel>(context);
    final int newId = generateId(await fetchAllFeedbacks.fetch());
    feedbackDBmodel.id = newId;
    final insertFeedbackQuery = Query<FeedbackDBmodel>(context)
      ..values = feedbackDBmodel;
    final insertedFeedback = await insertFeedbackQuery.insert();
    return Response.ok(insertedFeedback);
  }

  Future<bool> checkForExistingFeedback(FeedbackDBmodel feedback) async {
    final fetchFeedbacks = Query<FeedbackDBmodel>(context)
      ..where((r) => r.clientId).equalTo(feedback.clientId)
      ..where((r) => r.lecture.id).equalTo(feedback.lecture.id);
    final List<Feedback> feedbacks = await fetchFeedbacks.fetch();
    bool beforeFiveMinutes = true;
    for(Feedback feed in feedbacks) {
      if(feed.created.difference(feedback.created).inMinutes > -5){
        beforeFiveMinutes = false;
      }
    }
    return beforeFiveMinutes;
  }

  int generateId(List<Feedback> allFeedbacks) {
    final Set occupiedIds = <int>{};
    for(Feedback f in allFeedbacks){
      occupiedIds.add(f.id);
    }
    for(int i = 0; i >= 0; i++) {
      if(!occupiedIds.contains(i)) {
        return i;
      }
    }
    return 0;
  }
}