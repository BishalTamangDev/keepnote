abstract class AppFailure {
  final String message;

  AppFailure({required this.message});
}

class LocalDatabaseFailure extends AppFailure {
  LocalDatabaseFailure(String message) : super(message: message);
}
