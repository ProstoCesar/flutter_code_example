import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_example/bloc/notification/notificator_cubit.dart';
import 'package:flutter_code_example/repository/user_repo.dart';

import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required UserRepository userRepository, required NotificatorCubit notificatorCubit}) : 
  _userRepository = userRepository,
  _notificatorCubit = notificatorCubit,
  super(Loading()) {
    on<InitUserList>(_onInitUserList);
    on<DeleteUser>(_onDeleteUser);
    on<UpdateUserList>(_onUpdateUserList);
    add(InitUserList());
  }

  final UserRepository _userRepository;
  final NotificatorCubit _notificatorCubit;

  Future<void> _onInitUserList(
    InitUserList event,
    Emitter<UserState> emit,
  ) async {
    emit(Loading());
    try {
      await _userRepository.getUserList().forEach((userList) {emit(UserList(userList: userList));});
    } catch(error) {
      emit(InitError(message: 'Ошибка инициализации'));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      await _userRepository.deleteUser(event.user);
      add(UpdateUserList());
    } catch(error) {
      _notificatorCubit.showError(CurrentNotification.anotherError);
    }
  }

  Future<void> _onUpdateUserList(
    UpdateUserList event,
    Emitter<UserState> emit,
  ) async {
    try {
      await _userRepository.getUserList().forEach((userList) {emit(UserList(userList: userList));});
    } catch(error) {
      _notificatorCubit.showError(CurrentNotification.anotherError);
    }
  }
}