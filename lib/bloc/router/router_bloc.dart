import 'package:flutter_bloc/flutter_bloc.dart';

import 'router_event.dart';
import 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  RouterBloc() : super(RouterState.userList) {
    on<GoToUserList>(_onGoToUserList);
    on<GoToNewUser>(_onGoToAddUser);
    on<GoBack>(_onGoBack);
  }
  
  List<RouterState> backPath = [];

  Future<void> _onGoToUserList(
    GoToUserList event,
    Emitter<RouterState> emit,
  ) async {
    backPath.add(state);
    emit(RouterState.userList);
  }

  Future<void> _onGoToAddUser(
    GoToNewUser event,
    Emitter<RouterState> emit,
  ) async {
    backPath.add(state);
    emit(RouterState.addUser);
  }

  Future<void> _onGoBack(
    GoBack event,
    Emitter<RouterState> emit,
  ) async {
    if (backPath.isNotEmpty) {
      emit(backPath.last);
      backPath.removeLast();
    }
  }
}