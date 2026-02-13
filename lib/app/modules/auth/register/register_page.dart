import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/notifier/default_listener_notifier.dart';
import 'package:todolist/app/core/todo_list_field.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';
import 'package:todolist/app/core/validator/validators.dart';
import 'package:todolist/app/core/widget/todo_list_logo.dart';
import 'package:todolist/app/modules/auth/register/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();

  final _nameEditingController =
      TextEditingController();
  final _emailEditingController =
      TextEditingController();
  final _passwordEditingController =
      TextEditingController();
  final _confirmPasswordEditingController =
      TextEditingController();

  @override
  void dispose() {
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _confirmPasswordEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final defaultListener =
        DefaultListenerNotifier(
      changeNotifier:
          context.read<RegisterController>(),
    );

    defaultListener.listener(
      context: context,
      sucessCallback:
          (notifier, listenerInstance) {
        listenerInstance.dispose();

        // SnackBar de sucesso
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            content: Text(
              'Cadastro realizado com sucesso!',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(
          Duration(milliseconds: 500),
          () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Todo List',
              style: TextStyle(
                fontSize: 10,
                color: context.primaryColor,
              ),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 15,
                color: context.primaryColor,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: ClipOval(
            child: Container(
              color: context.primaryColor
                  .withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(
                  context,
                ).size.width *
                0.5,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: ArtListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 20,
            ),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TodoListField(
                    label: 'Nome',
                    controller:
                        _nameEditingController,
                    validator:
                        Validatorless.multiple([
                      Validatorless.required(
                        'Nome obrigatório',
                      ),
                      Validatorless.min(
                        3,
                        'Nome precisa ter ao menos 3 caracteres',
                      ),
                      Validators.fullName(),
                    ]),
                  ),
                  SizedBox(height: 8),
                  TodoListField(
                    label: 'E-mail',
                    controller:
                        _emailEditingController,
                    validator:
                        Validatorless.multiple([
                      Validatorless.required(
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
                    validator:
                        Validatorless.multiple([
                      Validatorless.required(
                        'Senha obrigatória!',
                      ),
                      Validatorless.min(
                        8,
                        'Senha deve ter pelo menos 8 caracteres!',
                      ),
                      Validators.password(),
                    ]),
                    obscureText: true,
                  ),
                  SizedBox(height: 8),
                  TodoListField(
                    label: 'Confirmar Senha',
                    controller:
                        _confirmPasswordEditingController,
                    validator:
                        Validatorless.multiple([
                      Validatorless.required(
                        'Confirmar senha obrigatória!',
                      ),
                      Validators.compare(
                        _passwordEditingController,
                        'As senhas não são iguais!',
                      ),
                    ]),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Consumer<RegisterController>(
                    builder: (context,
                        registerController, _) {
                      return Align(
                        alignment:
                            Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed:
                              registerController
                                      .loading
                                  ? null
                                  : () {
                                      final formValid = _formkey
                                              .currentState
                                              ?.validate() ??
                                          false;
                                      if (formValid) {
                                        final name = _nameEditingController
                                            .text
                                            .trim();
                                        final email = _emailEditingController
                                            .text
                                            .trim();
                                        final password =
                                            _passwordEditingController
                                                .text;

                                        context
                                            .read<
                                                RegisterController>()
                                            .registerUser(
                                              email,
                                              password,
                                              name,
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
                              'Salvar',
                              style: TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
