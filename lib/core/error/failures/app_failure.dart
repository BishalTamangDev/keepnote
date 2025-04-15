abstract class Failure {
  final String message;

  Failure(this.message);
}

final class LocalDatabaseFailure extends Failure {
  LocalDatabaseFailure(super.message);
}
