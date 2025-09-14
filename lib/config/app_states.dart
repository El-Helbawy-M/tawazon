abstract class AppStates {}

class InitialState extends AppStates {}
class LoadingState extends AppStates {
  final String? type;
  LoadingState({this.type});

}
class SuccessState extends AppStates {}
class ReconnectedState extends AppStates {}
class LoadedState extends AppStates {
  final dynamic data;
  final dynamic args;
  LoadedState(this.data, {this.args});
}
class EmptyState extends AppStates {}
class ErrorState extends AppStates {
  final String errorMessage;
  ErrorState(this.errorMessage);
}