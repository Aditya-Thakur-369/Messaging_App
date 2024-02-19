import 'package:chat_app/app/controller/auth/bloc/auth_bloc.dart';
import 'package:chat_app/app/utils/components/my_button.dart';
import 'package:chat_app/app/utils/components/my_textfield.dart';
import 'package:chat_app/app/utils/constants/validators.dart';
import 'package:chat_app/app/view/login/login.dart';
import 'package:chat_app/app/view/upload/uploadimgae.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginPageNavigateDoneState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        } else if (state is RegisteredSuccessState) {
          String uid = state.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UploadProfile(
                    uid: uid,
                    email: emailController.text,
                    name: nameController.text,
                    password: passwordController.text),
              ));
        } else if (state is RegisteredErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // logo

                    Image.asset(
                      'assets/images/chatify.png',
                      height: 100,
                    ),
                    const SizedBox(height: 50),
                    // welcome back, you've been missed!
                    Text(
                      'Let\'s create an account for you',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // email textfield
                    MyTextField(
                      validator: nameValidate,
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),

                    // password textfield
                    MyTextField(
                      validator: emailValidate,
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // confirm password textfield
                    MyTextField(
                      validator: passwordValidate,
                      controller: passwordController,
                      hintText: 'password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),
                    // sign in button
                    MyButton(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context)
                              .add(RegisterButtonClickedEvent(
                            email: emailController.text,
                            password: passwordController.text,
                            name: nameController.text,
                          ));
                        }
                      },
                      text: "Sign Up",
                    ),
                    const SizedBox(height: 50),
                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(LoginpagePageNavigateEvent());
                          },
                          child: const Text(
                            'Login now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
