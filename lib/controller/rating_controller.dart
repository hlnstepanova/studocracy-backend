import 'package:aqueduct/aqueduct.dart';
import 'package:studocracy_backend/model/lecture.dart';
import 'package:studocracy_backend/model/rating.dart';
import 'package:studocracy_backend/studocracy_backend.dart';
import '../controller/lecture_controller.dart';

class RatingController extends ResourceController {
  RatingController(this.context);

  final ManagedContext context;

  // TODO: returns the average of ALL ratings, not matching category or lectureID
  @Operation.get('id', 'category')
  Future<Response> getRatingByCategory(@Bind.path('id') String id, @Bind.path('category') String category) async {
    await LectureController.removeOldLectures(context);
    final q = Query<RatingDBmodel>(context)
      ..where((l) => l.lecture.id).equalTo(id)
      ..where((r) => r.category).equalTo(category);
    print((await q.fetch()).length);
    final averageRating = await q.reduce.average((r) => r.value);
    if(averageRating == null){
      return Response.notFound();
    }
    return Response.ok(averageRating);
  }

  @Operation.get('id')
  Future<Response> getRating(@Bind.path('id') String id) async{
    await LectureController.removeOldLectures(context);
    final fetchRatingsByLectureId = Query<LectureDBmodel>(context)
      ..join(set: (lecture) => lecture.ratings)
      ..where((lecture) => lecture.id).equalTo(id);
    final lecture = await fetchRatingsByLectureId.fetchOne();
    if(lecture == null) {
      return Response.notFound();
    }
    return Response.ok(lecture.ratings);
  }


  @Operation.post('id')
  Future<Response> giveRating(@Bind.path('id') String id, @Bind.body() RatingDBmodel ratingDBmodel) async {
    await LectureController.removeOldLectures(context);
    final lecture = await context.fetchObjectWithID<LectureDBmodel>(id);
    if(lecture == null) {
      return Response.notFound();
    }
    ratingDBmodel.created = DateTime.now();
    ratingDBmodel.lecture = lecture;
    final bool isValid = await checkForExistingRating(ratingDBmodel);
    if(!isValid) {
      return Response.badRequest();
    } else {
      final deleteRatings = Query<RatingDBmodel>(context)
        ..where((r) => r.clientId).equalTo(ratingDBmodel.clientId)
        ..where((r) => r.lecture.id).equalTo(ratingDBmodel.lecture.id)
        ..where((r) => r.category).equalTo(ratingDBmodel.category);
      await deleteRatings.delete();
    }
    final fetchAllRatings = Query<RatingDBmodel>(context);
    final int newId = generateId(await fetchAllRatings.fetch());
    ratingDBmodel.id = newId;
    final insertRatingQuery = Query<RatingDBmodel>(context)
      ..values = ratingDBmodel;
    final insertedRating = await insertRatingQuery.insert();
    return Response.ok(insertedRating);
  }

  Future<bool> checkForExistingRating(RatingDBmodel rating) async {
    final fetchRatings = Query<RatingDBmodel>(context)
      ..where((r) => r.clientId).equalTo(rating.clientId)
      ..where((r) => r.lecture.id).equalTo(rating.lecture.id);
      final List<Rating> ratings = await fetchRatings.fetch();
      bool beforeFiveMinutes = true;
      for(Rating rat in ratings) {
        if(rat.created.difference(rating.created).inMinutes > -5){
          if(rat.category == rating.category){
            beforeFiveMinutes = false;
          }
        }
      }
      return beforeFiveMinutes;
  }

  int generateId(List<Rating> allRatings) {
    final Set occupiedIds = <int>{};
    for(Rating r in allRatings){
      occupiedIds.add(r.id);
    }
    for(int i = 0; i >= 0; i++) {
      if(!occupiedIds.contains(i)) {
        return i;
      }
    }
    return 0;
  }
}