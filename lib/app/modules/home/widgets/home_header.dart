import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/app/core/auth/auth_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 20.0),
      child: Selector<AuthProvider, String>(
          selector: (context, authProvider) =>
              authProvider
                  .user?.displayName ??
              'Não informado',
          builder: (_, value, __) {
            return Text(
              'E ai, $value 🥳',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontFamily: GoogleFonts
                        .eduNswActFoundation()
                    .fontFamily,
                color: Color.fromRGBO(
                    221, 226, 233, 1),
                fontSize: 32,
                fontWeight: FontWeight.w800,
                shadows: [
                  Shadow(
                    color: Colors.black
                        .withOpacity(0.4),
                    offset:
                        const Offset(2, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
