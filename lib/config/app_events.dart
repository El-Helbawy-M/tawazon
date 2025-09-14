abstract class AppEvents {}

class FetchDataEvent extends AppEvents {}
class SaveEvent extends AppEvents {
  final dynamic data;
  SaveEvent(this.data);
}
class UpdateEvent extends AppEvents {
  final dynamic data;
  UpdateEvent(this.data);
}
class DeleteEvent extends AppEvents {
  final dynamic data;
  DeleteEvent(this.data);
}
class ClickEvent extends AppEvents {
  final dynamic data;
  ClickEvent({this.data});
}
