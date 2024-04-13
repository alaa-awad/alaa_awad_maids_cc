import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maids_cc_alaa_awad_test/controller/todo_bloc/todo_bloc.dart';
import '../../controller/user_bloc/user_bloc.dart';
import '../../controller/user_bloc/user_state.dart';
import '../../core/routing/navigate_and_finish.dart';
import '../../core/show_toast.dart';
import '../tasks_screen/tasks_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    emailController.text = "kminchelle";
    passwordController.text = "0lelplR";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (BuildContext context, UserState state) {
          if (state is LogInErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.error,
            );
          }
          if (state is LogInSuccessState) {
            navigateAndFinish(context,const TasksScreen());
          }
        },
        builder: (BuildContext context, UserState state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                 Center(
                  child: Text("Welcome to Maids.cc",
                    style: TextStyle(
                    color: Colors.blueGrey[800],
                    fontSize: 20,
                      fontWeight: FontWeight.bold,
                  ),),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async{
                    await TodoBloc.get(context).getData();
                    UserBloc.get(context).logInCubit(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    //primary: Colors.blueGrey[800],
                    backgroundColor:Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Add navigation to register page
                    },
                    child: Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(
                        color: Colors.blueGrey[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
