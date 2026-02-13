import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist/app/core/todo_list_field.dart';
import 'package:todolist/app/core/ui/messages.dart';
import 'package:todolist/app/core/validator/validators.dart';
import 'package:todolist/app/core/widget/todo_list_logo.dart';
import 'package:todolist/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEditingController =
      TextEditingController();
  final _passwordEditingController =
      TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(
      changeNotifier:
          context.read<LoginController>(),
    ).listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if (notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(
              context,
            ).showInfo(notifier.infoMessage!);
          }
        }
      },
      sucessCallback:
          (notifier, listenerInstance) {
        listenerInstance.dispose();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Login realizado com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        print(
          'Login realizado com sucesso!!!',
        );
      },
    );
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(
              context,
            ).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(height: 20),
                ArtListLogo(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TodoListField(
                          label: 'E-mail',
                          controller:
                              _emailEditingController,
                          focusNode: _emailFocus,
                          validator: Validatorless
                              .multiple([
                            Validatorless
                                .required(
                              'E-mail obrigatório!',
                            ),
                            Validatorless.email(
                              'E-mail inválido!',
                            ),
                          ]),
                        ),
                        SizedBox(height: 8),
                        TodoListField(
                          label: 'Senha',
                          controller:
                              _passwordEditingController,
                          validator: Validatorless
                              .multiple([
                            Validatorless
                                .required(
                              'Senha obrigatória!',
                            ),
                            Validatorless.min(
                              8,
                              'Senha de pelo menos 8 caracteres!',
                            ),
                            Validators.password(),
                          ]),
                          obscureText: true,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (_emailEditingController
                                    .text
                                    .isNotEmpty) {
                                  context
                                      .read<
                                          LoginController>()
                                      .forgotPassword(
                                        _emailEditingController
                                            .text,
                                      );
                                } else {
                                  _emailFocus
                                      .requestFocus();
                                  Messages.of(
                                    context,
                                  ).showError(
                                    'Digite um e-mail para recuperar a senha!',
                                  );
                                }
                              },
                              child: Text(
                                'Esqueceu a senha?',
                              ),
                            ),
                            Consumer<
                                LoginController>(
                              builder: (
                                context,
                                loginController,
                                _,
                              ) {
                                return ElevatedButton(
                                  onPressed:
                                      loginController
                                              .loading
                                          ? null
                                          : () {
                                              final formValid =
                                                  _formKey.currentState?.validate() ?? false;
                                              if (formValid) {
                                                final email = _emailEditingController.text.trim();
                                                final password = _passwordEditingController.text;

                                                context.read<LoginController>().login(
                                                      email,
                                                      password,
                                                    );
                                              }
                                            },
                                  style: ElevatedButton
                                      .styleFrom(
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        14,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .all(
                                      2.0,
                                    ),
                                    child: Text(
                                      'Login',
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffF0F3F7),
                      border: Border(
                        top: BorderSide(
                          width: 2,
                          color: Colors.grey
                              .withAlpha(50),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        SignInButton(
                          Buttons.Google,
                          text:
                              'Continue com Google',
                          padding: EdgeInsets.all(
                            8,
                          ),
                          shape:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                          onPressed: () {
                            context
                                .read<
                                    LoginController>()
                                .googleLogin();
                          },
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Text(
                              'Não tem conta?',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(
                                  '/register',
                                );
                              },
                              child: Text(
                                'Cadastre-se',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
