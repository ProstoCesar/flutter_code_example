import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_example/bloc/new_user/new_user_event.dart';
import 'package:flutter_code_example/bloc/new_user/new_user_state.dart';
import 'package:flutter_code_example/bloc/notification/notificator_cubit.dart';
import 'package:flutter_code_example/bloc/router/router_bloc.dart';
import 'package:flutter_code_example/bloc/router/router_event.dart';
import 'package:flutter_code_example/repository/user_repo.dart';

class NewUserBloc extends Bloc<NewUserEvent, NewUserState> {
  NewUserBloc({required UserRepository userRepository, required RouterBloc routerBloc, required NotificatorCubit notificatorCubit}) :
  _userRepository = userRepository,
  _routerBloc = routerBloc,
  _notificatorCubit = notificatorCubit,
  super(WaitingName()) {
    on<ChangeNewUserName>(_onChangeNewUserName);
    on<AddNewUser>(_onAddNewUser);
  }

  String username = '';
  final UserRepository _userRepository;
  final RouterBloc _routerBloc;
  final NotificatorCubit _notificatorCubit;
  
  Future<void> _onChangeNewUserName(
    ChangeNewUserName event,
    Emitter<NewUserState> emit,
  ) async {
    username = event.username;
  }

  Future<void> _onAddNewUser(
    AddNewUser event,
    Emitter<NewUserState> emit,
  ) async {
    emit(Loading());
    try {
      await _userRepository.addNewUser(username);
      emit(Success());
      _routerBloc.add(GoToUserList());
    } catch (exp) {
      _notificatorCubit.showError(CurrentNotification.anotherError);
      emit(WaitingName());
    }  
  }
}