import 'package:flutter/material.dart';
import 'package:todolist/app/core/ui/todo_list_icons_icons.dart';

class TodoListField extends StatelessWidget {
  final String label;
  final IconButton? suffixIconButton;
  final bool obscureText;
  final ValueNotifier<bool> obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  TodoListField({
    super.key,
    required this.label,
    this.suffixIconButton,
    bool? obscureText,
    ValueNotifier<bool>? obscureTextVN,
    this.controller,
    this.validator,
    this.focusNode,
  })  : obscureText = obscureText ?? false,
        obscureTextVN = obscureTextVN ??
            ValueNotifier(obscureText ?? false),
        assert(
          obscureText != true
              ? suffixIconButton == null
              : true,
          'obscureText não pode ser enviado em conjunto com suffixIconButton',
        );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(
      context,
    ).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 1.0,
      ),
      child: SizedBox(
        width: screenWidth * 0.9,
        child: ValueListenableBuilder<bool>(
          valueListenable: obscureTextVN,
          builder: (_, obscureTextValue, child) {
            return TextFormField(
              controller: controller,
              validator: validator,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                ),
                suffixIcon: suffixIconButton ??
                    (obscureText
                        ? IconButton(
                            onPressed: () {
                              obscureTextVN
                                      .value =
                                  !obscureTextValue;
                            },
                            icon: Icon(
                              !obscureTextValue
                                  ? TodoListIcons
                                      .eye_slash
                                  : TodoListIcons
                                      .eye,
                              color: Colors.black,
                              size: 15,
                            ),
                          )
                        : null),
              ),
              obscureText: obscureTextValue,
              obscuringCharacter: '*',
              cursorColor: Colors.black,
            );
          },
        ),
      ),
    );
  }
}
