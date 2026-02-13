import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todolist/app/core/ui/theme_extensions.dart';

class CalendarButton extends StatelessWidget {
  final VoidCallback? onTap;
  final DateTime? selectedDate;
  final dateFormat = DateFormat('dd/MM/yyyy');

  CalendarButton({
    super.key,
    this.selectedDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey),
            borderRadius:
                BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                // Camada de Sombra com Blur
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                      sigmaX: 1, sigmaY: 1),
                  child: Icon(
                    Icons.today,
                    color: Colors.transparent,
                    shadows: [
                      Shadow(
                        color: Colors.black
                            .withOpacity(0.3),
                        offset:
                            const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Ícone Nítido
                Icon(
                  Icons.today,
                  color: selectedDate != null
                      ? context.primaryColor
                      : Colors.grey,
                ),
              ],
            ),
            SizedBox(width: 10),
            Stack(
              children: [
                // Camada de Sombra com Blur
                ImageFiltered(
                  imageFilter: ImageFilter.blur(
                      sigmaX: 0.8, sigmaY: 0.8),
                  child: Text(
                    selectedDate != null
                        ? dateFormat
                            .format(selectedDate!)
                        : 'SELECIONE UMA DATA',
                    style: (Theme.of(context)
                                .textTheme
                                .titleLarge ??
                            TextStyle())
                        .copyWith(
                      fontFamily:
                          GoogleFonts.montserrat()
                              .fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.transparent,
                      shadows: [
                        Shadow(
                          color: Colors.black
                              .withOpacity(0.25),
                          offset:
                              const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Texto Nítido
                Text(
                  selectedDate != null
                      ? dateFormat
                          .format(selectedDate!)
                      : 'SELECIONE UMA DATA',
                  style: (Theme.of(context)
                              .textTheme
                              .titleLarge ??
                          TextStyle())
                      .copyWith(
                    fontFamily:
                        GoogleFonts.montserrat()
                            .fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: selectedDate != null
                        ? context.primaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
