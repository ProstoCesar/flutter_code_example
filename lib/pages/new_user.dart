import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_example/bloc/new_user/new_user_bloc.dart';
import 'package:flutter_code_example/bloc/new_user/new_user_event.dart';
import 'package:flutter_code_example/bloc/new_user/new_user_state.dart';
import 'package:flutter_code_example/bloc/notification/notificator_cubit.dart';
import 'package:flutter_code_example/bloc/router/router_bloc.dart';
import 'package:flutter_code_example/bloc/router/router_event.dart';
import 'package:flutter_code_example/repository/user_repo.dart';

class NewUserPage extends StatelessWidget {
  const NewUserPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый пользователь'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<RouterBloc>().add(GoToUserList());
          }
        ),
      ),
      body: BlocListener<NotificatorCubit, CurrentNotification>(
        listener: (_, state) {
          if (state != CurrentNotification.none) {
            showErrorDialog(context).then((_) => {context.read<NotificatorCubit>().dropError()});
          }
        },
        child: BlocProvider(
          create: (_) => NewUserBloc(
            userRepository: context.read<UserRepository>(), 
            routerBloc: context.read<RouterBloc>(),
            notificatorCubit: context.read<NotificatorCubit>()
          ),
          child: BlocBuilder<NewUserBloc, NewUserState>(
            builder: (_, state) {
              if (state is Success) {
                return const SuccessView();
              } else {
                return WaitingNameView(
                  isLoading: state is Loading,
                  errorMessage: (state is Error) ? 'da' : '',
                );
              }
            },
          ),
        ),
      )
    );
  }

  Future<void> showErrorDialog(BuildContext context) async {
    await showDialog(
      context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ой! Что-то пошло не так'),
            content: const Text("Во время обратотки запроса произошла непредвиденная ошибка"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("ОК")
              ),
            ],
          );
        }
    );
  }
}

class WaitingNameView extends StatelessWidget {
  const WaitingNameView({ Key? key, required this.isLoading, required this.errorMessage }) : super(key: key);

  final bool isLoading;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('Введите имя'),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            margin: const EdgeInsets.only(bottom: 32),
            child: TextField(
              onChanged: (txt) {
                context.read<NewUserBloc>().add(ChangeNewUserName(username: txt));
              },
                
              enabled: !isLoading,
              obscureText: false,
              decoration: const InputDecoration(
                labelText: 'Имя',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))
            ),
            onPressed: errorMessage == '' && !isLoading ? () {
              context.read<NewUserBloc>().add(AddNewUser());
            } : null,
            
            child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : const Text('ДОБАВИТЬ'),
          )
        ],
      ),
    );
  }
}

class SuccessView extends StatelessWidget {
  const SuccessView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.done, size: 64,),
          Text('Пользоваьтель успешно добавлен!'),
          Text('Вы будете перенаправлены на главную страницу'),
        ],
      ),
    );
  }
}