import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_example/bloc/notification/notificator_cubit.dart';
import 'package:flutter_code_example/bloc/router/router_bloc.dart';
import 'package:flutter_code_example/bloc/router/router_event.dart';
import 'package:flutter_code_example/bloc/user_list/user_bloc.dart';
import 'package:flutter_code_example/bloc/user_list/user_event.dart';
import 'package:flutter_code_example/bloc/user_list/user_state.dart';
import 'package:flutter_code_example/models/user.dart';
import 'package:flutter_code_example/repository/user_repo.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список пользователей'),
      ),
      body: BlocProvider(
        create: (_) => UserBloc(
          userRepository: RepositoryProvider.of<UserRepository>(context),
          notificatorCubit: context.read<NotificatorCubit>()
        ),
        child: const UserListBuilder()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<RouterBloc>().add(GoToNewUser());
          },
          child: const Icon(Icons.add),
        ),
      );
  }
}

class UserListBuilder extends StatelessWidget {
  const UserListBuilder({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserBloc>().add(UpdateUserList());
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (_, state) {
          if (state is UserList) {
            return UserListView(userList: state.userList);
          } else if (state is InitError) {
            return InitErrorView();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}


class UserListView extends StatelessWidget {
  UserListView({ Key? key, required this.userList }) : super(key: key);

  List<User> userList;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                bool needDeleteUser = await _showConfirmationDialog(context);
                if (needDeleteUser) {
                  context.read<UserBloc>().add(DeleteUser(user: userList[index]));
                }
              },
              child: UserItem(user: userList[index])
          );
        }
      ),
      Positioned(
        left: 20.0,
        bottom: 20.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.touch_app, size: 48),
            Text('удалить', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))
          ],
        )
      ),
    ],
  );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Вы уверены, что хотите удалить пользователя?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("НЕТ"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("ДА")
            ),
          ],
        );
      },
    );
  }
}

class UserItem extends StatelessWidget {
  UserItem({ Key? key, required this.user }) : super(key: key);

  User user;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user.id.toString()),
            Text(user.name)
          ],
        ),
      ),
    );
  }
}

class InitErrorView extends StatelessWidget {
  const InitErrorView({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('Во время загрузки данных произошла ошибка'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))
            ),
            onPressed: () {
              context.read<UserBloc>().add(InitUserList());
            },
            
            child: const Text('ПОВТОРИТЬ'),
          ),
        ],
      ),
    );
  }
}