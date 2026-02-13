import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoListUiConfig {
  TodoListUiConfig._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff5c77ce),
        primaryColorLight:
            const Color(0xffabc8f7),
        appBarTheme: AppBarTheme(
          backgroundColor:
              const Color(0xff5c77ce),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: GoogleFonts.recursive(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          elevation: 4,
          shadowColor: Colors.black.withValues(
            alpha: 0.4,
          ),
        ),
        progressIndicatorTheme:
            ProgressIndicatorThemeData(
          color: Colors.white,
          linearMinHeight: 8, // altura opcional
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(
            alpha: 0.3,
          ),
          scrimColor: Colors.black.withValues(
            alpha: 0.5,
          ),
        ),
        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xff5c77ce),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.recursive(
            fontSize: 57,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          headlineLarge: GoogleFonts.recursive(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
          titleLarge: GoogleFonts.recursive(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyLarge: GoogleFonts.recursive(
            fontSize: 18,
            color: Colors.black87,
          ),
          bodyMedium: GoogleFonts.recursive(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodySmall: GoogleFonts.recursive(
            fontSize: 14,
            color: Colors.black54,
          ),
          labelSmall: GoogleFonts.recursive(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle:
              GoogleFonts.poppinsTextTheme()
                  .bodyLarge!
                  .copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
          backgroundColor:
              const Color(0xff5c77ce),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

  // Estilo para DrawerHeader
  static BoxDecoration
      get drawerHeaderDecoration => BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff5c77ce),
                Color(0xff7a91db),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          );

  // TextStyle para títulos dentro do Drawer
  static TextStyle get drawerTitleStyle =>
      GoogleFonts.eduNswActFoundation(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  // TextStyle para subtítulos dentro do Drawer
  static TextStyle get drawerSubtitleStyle =>
      GoogleFonts.recursive(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.white70,
      );

  // TextStyle para itens de menu do Drawer
  static TextStyle get drawerItemStyle =>
      GoogleFonts.recursive(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      );

  // TextStyle para itens de menu selecionados
  static TextStyle get drawerItemSelectedStyle =>
      GoogleFonts.recursive(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: const Color(0xff5c77ce),
      );

  // Cor de fundo para item selecionado
  static Color get drawerItemSelectedBackground =>
      const Color(0xffabc8f7)
          .withValues(alpha: 0.3);

  // Cor do avatar no Drawer
  static Color get avatarBackgroundColor =>
      const Color(0xfff0a9d4);
}

/**  Estilos Disponíveis
 *  Theme.of(context).textTheme.displayLarge - para títulos muito grandes
    Theme.of(context).textTheme.headlineLarge - para títulos grandes
    Theme.of(context).textTheme.titleLarge - para títulos
    Theme.of(context).textTheme.bodyLarge - para textos grandes
    Theme.of(context).textTheme.bodyMedium - para textos médios
    Theme.of(context).textTheme.bodySmall - para textos pequenos
    Theme.of(context).textTheme.labelSmall - para labels  
  **/


/**
 * Exemplo de copyWith
 * 
 * child: Text(
            'E ai, Anselmo Polcaro',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(
                  fontFamily: GoogleFonts
                          .eduNswActFoundation()
                      .fontFamily,
                  fontWeight: FontWeight.w600,
                ),
          ),
 *  **/