import 'package:studocracy_backend/controller/feedback_controller.dart';
import 'package:studocracy_backend/controller/rating_controller.dart';

import 'controller/lecture_controller.dart';
import 'studocracy_backend.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class StudocracyBackendChannel extends ApplicationChannel {
  ManagedContext context;
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo('bybhzicwddnmug', 'c4d444e065b07d9df5a45b982921cbcd27ee7ee9cf8cd62446e6b3354341e60a', 'ec2-54-247-96-169.eu-west-1.compute.amazonaws.com', 5432, 'dbseipa6mbbetg');
    context = ManagedContext(dataModel, psc);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route('/lectures/[:id/]')
      .link(() => LectureController(context));

    router
      .route('/rating/[:id/[:category/]]')
      .link(() => RatingController(context));

    router
      .route('/feedback/[:id/]')
      .link(() => FeedbackController(context));

    return router;
  }
}