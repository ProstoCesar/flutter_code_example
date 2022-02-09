import 'package:flutter_bloc/flutter_bloc.dart';

enum CurrentNotification {
  none,
  anotherError
}

class NotificatorCubit extends Cubit<CurrentNotification> {
  NotificatorCubit() : super(CurrentNotification.none);

  void showError(CurrentNotification currentNotification) {
    emit(currentNotification);

  }  

  void dropError() {
    emit(CurrentNotification.none);
  }
}