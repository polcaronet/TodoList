import 'package:flutter/material.dart';

class Validators {
  Validators._();

  static FormFieldValidator compare(
    TextEditingController?
        valueTextEditingController,
    String message,
  ) {
    return (value) {
      final valueCompare =
          valueTextEditingController?.text ?? '';
      if (value == null ||
          (value != null &&
              value != valueCompare)) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> fullName() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        // Verificar números
        if (value.contains(RegExp(r'[0-9]'))) {
          return 'Nome não pode conter números!';
        }

        // Verificar caracteres especiais
        if (value.contains(
            RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
          return 'Nome não pode conter caracteres especiais!';
        }

        // Verificar se tem pelo menos 2 palavras (nome e sobrenome)
        final nameParts =
            value.trim().split(RegExp(r'\s+'));
        if (nameParts.length < 2) {
          return 'Por favor, insira nome e sobrenome!';
        }

        // Verificar se as palavras têm pelo menos 2 caracteres
        for (final part in nameParts) {
          if (part.length < 2) {
            return 'Cada nome deve ter pelo menos 2 caracteres!';
          }
        }

        // Verificar caracteres repetidos em sequência (mais de 3 iguais)
        if (RegExp(r'(.)\1{3,}')
            .hasMatch(value)) {
          return 'Nome contém muitos caracteres repetidos!';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> password() {
    return (value) {
      if (value != null && value.isNotEmpty) {
        final hasUppercase =
            value.contains(RegExp(r'[A-Z]'));
        final hasLowercase =
            value.contains(RegExp(r'[a-z]'));
        final hasNumber =
            value.contains(RegExp(r'[0-9]'));
        final hasSpecialChar = value.contains(
            RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        if (!hasUppercase) {
          return 'Deve ter pelo menos uma letra maiúscula!';
        }
        if (!hasLowercase) {
          return 'Deve ter pelo menos uma letra minúscula!';
        }
        if (!hasNumber) {
          return 'Deve ter pelo menos um número!';
        }
        if (!hasSpecialChar) {
          return 'Deve ter pelo menos um caractere especial!';
        }
      }
      return null;
    };
  }
}
