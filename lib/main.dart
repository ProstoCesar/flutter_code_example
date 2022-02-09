import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_example/bloc/notification/notificator_cubit.dart';
import 'package:flutter_code_example/pages/new_user.dart';
import 'package:flutter_code_example/pages/user_list.dart';
import 'package:flutter_code_example/repository/user_repo.dart';

import 'bloc/router/router_bloc.dart';
import 'bloc/router/router_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (_) => UserRepository(),
        child: App()
    );
  }
}

class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Open sans'
      ),
      debugShowCheckedModeBanner: false,

      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => RouterBloc()),
          BlocProvider(create: (_) => NotificatorCubit()),
        ],
        child:  BlocBuilder<RouterBloc, RouterState>(
          builder: (_, state) {
            if (state == RouterState.addUser) {
              return NewUserPage();
            }
            return UserListPage();
          },
        ),
      )
    );
  }
}